#!/bin/bash

#filename showArgs.sh

for i in `seq 1 $#`
do
    echo $i is $1
    shift
done
