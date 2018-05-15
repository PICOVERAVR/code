#!/usr/bin/env bash

echo "running script $0..."
IFS=,

echo "$# global args $*"

if cd $1
then
	echo "a valid directory"
else
	echo "not a valid directory"
fi

echo "exiting script $0..."
