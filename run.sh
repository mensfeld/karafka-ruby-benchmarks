#!/bin/bash

TIMESTAMP=$(date +%s)
JIT_FLAGS="--jit --disable-gem --jit-wait"

RED='\033[0;31m'
NC='\033[0m' # No Color

# Get the karafka repo with a 1.3-wip branch
git clone --single-branch -b 1.3-wip git@github.com:karafka/karafka.git

cd karafka

# Remove any leftovers from previous benchmarkings
git clean -fd
git reset --hard

# Update if anything newer is available
git pull origin 1.3-wip

# Add the ips gem. It's not in the repo as it does not run for jruby
echo "gem 'benchmark-ips'" >> Gemfile

eval "$(rbenv init -)"

rbenv shell 2.5.3 && bundle install
rbenv shell 2.6.0-preview3 && bundle install

cd ..
cp bench13.rb ./karafka

mkdir -p ./results

cd karafka

rbenv shell 2.5.3
printf " ----------- ${RED}Running $(ruby -v)${NC} -----------\n"
bundle exec ruby bench13.rb | tee ../results/$TIMESTAMP-ruby-2.5.3.txt
printf "\n"

rbenv shell 2.6.0-preview3
printf " ----------- ${RED}Running $(ruby -v)${NC} -----------\n"
bundle exec ruby bench13.rb | tee ../results/$TIMESTAMP-ruby-2.6.0.txt
printf "\n"

rbenv shell 2.6.0-preview3
printf " ----------- ${RED}Running $(ruby -v) $JIT_FLAGS ${NC} -----------\n"
bundle exec ruby $JIT_FLAGS bench13.rb | tee ../results/$TIMESTAMP-ruby-2.6.0-jit.txt
printf "\n"
