#!/bin/bash

#filename function_debug.sh

function DEBUG()
{
    [ "$_DEBUG" == "on" ] && $@ || :
}

for i in {1..10}
do
	DEBUG echo "I is $i"
done
