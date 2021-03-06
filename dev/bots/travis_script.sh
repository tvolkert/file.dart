#!/bin/bash
set -ex

export PATH="$HOME/dart-sdk/bin:$PATH"
export ROOT="$PWD"
export PACKAGES=("file" "file_testing")

if [[ "$SHARD" == "dartfmt" ]]; then
  dartfmt --dry-run --set-exit-if-changed packages || exit $?
elif [[ "$SHARD" == "analyze" ]]; then
  for package in "${PACKAGES[@]}"; do
    echo "Analyzing packages/$package"
    cd $ROOT/packages/$package
    dartanalyzer --enable-experiment=non-nullable --options=$ROOT/analysis_options.yaml . || exit $?
  done
else
  # tests shard
  cd $ROOT/packages/file
  pub run --enable-experiment=non-nullable test -j1 -rexpanded || exit $?
fi
