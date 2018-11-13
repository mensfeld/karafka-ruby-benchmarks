# frozen_string_literal: true
require 'benchmark/ips'
require 'forwardable'
require 'karafka'

Karafka::Loader.load(Karafka::App.root)
ENV['RACK_ENV'] ||= 'development'
ENV['KARAFKA_ENV'] ||= ENV['RACK_ENV']

class App < Karafka::App
    setup do |config|
    config.kafka.seed_brokers = %w[kafka://127.0.0.1:9092]
    config.client_id = 'example_app'
    config.backend = :inline
    config.batch_fetching = true
  end
end

ApplicationConsumer = Class.new(Karafka::BaseConsumer)

class CallbackedConsumer < ApplicationConsumer
  include Karafka::Consumers::Callbacks
  after_fetch { @x = 0 }
  before_stop { @x = 1 }
  before_poll { @x = 2 }
  after_poll  { @x = 3 }

  def consume
  end
end

class CallbackedConsumerWithMethod < ApplicationConsumer
  include Karafka::Consumers::Callbacks
  after_fetch :a
  before_stop :a
  before_poll :a
  after_poll  :a

  def consume
  end

  def a
    @x = 3
  end
end

class NonCallbackedConsumerIncludeMixin < ApplicationConsumer
  include Karafka::Consumers::Callbacks

  def consume
  end
end

class NonCallbackedConsumer < ApplicationConsumer
  def consume
  end
end

App.consumer_groups.draw do
  consumer_group :batched_group do
    batch_fetching true

    topic :non_callbacked_consumer do
      consumer NonCallbackedConsumer
      batch_consuming true
    end

    topic :non_callbacked_consumer_include_mixin do
      consumer NonCallbackedConsumerIncludeMixin
      batch_consuming true
    end

    topic :callbacked_data do
      consumer CallbackedConsumer
      batch_consuming true
    end

    topic :callbacked_with_method_data do
      consumer CallbackedConsumerWithMethod
      batch_consuming true
    end
  end
end

consumer = CallbackedConsumer.new(App.consumer_groups[0].topics[0])
consumer_with_m = CallbackedConsumerWithMethod.new(App.consumer_groups[0].topics[3])
non_callbacked_consumer = NonCallbackedConsumer.new(App.consumer_groups[0].topics[1])
non_callbacked_consumer_include_mixin = NonCallbackedConsumerIncludeMixin.new(App.consumer_groups[0].topics[2])

consumer_with_m.params_batch = []
consumer.params_batch = []
non_callbacked_consumer.params_batch = []
non_callbacked_consumer_include_mixin.params_batch = []

Benchmark.ips do |x|
  x.config(time: 20, warmup: 10)
  x.report("With Callbacks") { consumer.call }
  x.report("With Callbacks method") { consumer_with_m.call }
  x.report("With Mixin Included") { non_callbacked_consumer_include_mixin.call }
  x.report("Without Mixin Included") { non_callbacked_consumer.call }
end
