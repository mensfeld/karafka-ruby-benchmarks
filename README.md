# Karafka framework 1.3-wip benchmarks for multiple Ruby versions

It assumes `rbenv` and `tee` are installed.

Results will be available in the `./results` directory.

```
git clone https://github.com/mensfeld/karafka-ruby-benchmarks.git
cd karafka-ruby-benchmarks
./run.sh
```

Example results from my machine with `x.config(time: 2, warmup: 1)`:

```
 ----------- Running ruby 2.5.3p105 (2018-10-18 revision 65156) [x86_64-linux] -----------
Warming up --------------------------------------
      With Callbacks    20.790k i/100ms
With Callbacks method
                        18.234k i/100ms
 With Mixin Included    24.233k i/100ms
Without Mixin Included
                        50.900k i/100ms
Calculating -------------------------------------
      With Callbacks    231.126k (± 5.5%) i/s -    478.170k in   2.075291s
With Callbacks method
                        217.537k (± 8.6%) i/s -    437.616k in   2.030386s
 With Mixin Included    287.325k (± 7.9%) i/s -    581.592k in   2.038106s
Without Mixin Included
                        551.016k (±13.6%) i/s -      1.120M in   2.074300s

 ----------- Running ruby 2.6.0preview3 (2018-11-06 trunk 65578) [x86_64-linux] -----------
Warming up --------------------------------------
      With Callbacks    25.621k i/100ms
With Callbacks method
                        23.984k i/100ms
 With Mixin Included    31.640k i/100ms
Without Mixin Included
                        63.270k i/100ms
Calculating -------------------------------------
      With Callbacks    278.907k (± 3.3%) i/s -    563.662k in   2.023384s
With Callbacks method
                        257.906k (± 5.9%) i/s -    527.648k in   2.053968s
 With Mixin Included    354.110k (± 4.9%) i/s -    727.720k in   2.060612s
Without Mixin Included
                        738.423k (± 5.3%) i/s -      1.518M in   2.063298s

 ----------- Running ruby 2.6.0preview3 (2018-11-06 trunk 65578) [x86_64-linux] --jit --disable-gem --jit-wait  -----------
Warming up --------------------------------------
      With Callbacks     1.000  i/100ms
With Callbacks method
                        15.668k i/100ms
 With Mixin Included    27.792k i/100ms
Without Mixin Included
                        56.559k i/100ms
Calculating -------------------------------------
      With Callbacks    307.573k (±10.2%) i/s -    476.671k in   1.766912s
With Callbacks method
                        272.402k (± 4.4%) i/s -    548.380k in   2.017724s
 With Mixin Included    324.966k (±10.3%) i/s -    667.008k in   2.076704s
Without Mixin Included
                        687.036k (±10.9%) i/s -      1.357M in   2.006277s
```
