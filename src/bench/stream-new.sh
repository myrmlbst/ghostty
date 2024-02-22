#!/usr/bin/env bash
#
# This is a trivial helper script to help run the stream benchmark.
# You probably want to tweak this script depending on what you're
# trying to measure.

# Options:
# - "ascii", uniform random ASCII bytes
# - "utf8", uniform random unicode characters, encoded as utf8
# - "rand", pure random data, will contain many invalid code sequences.
DATA="ascii"
SIZE="25000000"

# Uncomment to test with an active terminal state.
# ARGS=" --terminal"

# Generate the benchmark input ahead of time so it's not included in the time.
./zig-out/bin/bench-stream --mode=gen-$DATA | head -c $SIZE > /tmp/ghostty_bench_data

# Uncomment to instead use the contents of `stream.txt` as input. (Ignores SIZE)
# echo $(cat ./stream.txt) > /tmp/ghostty_bench_data

hyperfine \
  --warmup 10 \
  -n noop \
  "./zig-out/bin/bench-stream --mode=noop </tmp/ghostty_bench_data" \
  -n old \
  "./zig-out/bin/bench-stream --mode=simd --terminal=old </tmp/ghostty_bench_data" \
  -n new \
  "./zig-out/bin/bench-stream --mode=simd --terminal=new </tmp/ghostty_bench_data"
