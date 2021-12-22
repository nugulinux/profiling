#!/bin/sh

if [ "$#" -ne 1 ]; then
	echo "Illegal number of parameters"
	exit 1
fi

TEST=$1
OUTDIR=/tmp/www

if [ ! -d "$OUTDIR" ]; then
    echo "Create output directory $OUTDIR"
    mkdir -p $OUTDIR
fi

echo "Start profiling for $TEST"
nugu_prof -n 5 -c $TEST \
    -i /usr/share/nugu/testcases/$TEST.raw \
    -o $TEST.csv

if [ ! -f $TEST.csv ]; then
    echo "Profiling failed."
    exit 1
fi

echo "Profiling result"
cat $TEST.csv

echo "Download the profiling log file for $TEST"
wget --no-verbose -P $OUTDIR \
    https://nugulinux.github.io/profiling/$TEST.csv
if [ $? -eq 0 ]; then
    echo "Download success"

    # Append the result to profiling log file
    tail -n +2 $TEST.csv >> $OUTDIR/$TEST.csv
else
    echo "There is no profiling log file for $TEST"
    cp $TEST.csv $OUTDIR/$TEST.csv
fi
