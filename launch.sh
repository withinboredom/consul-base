#!/bin/bash

set -eo pipefail
echo "Starting consul agent -- master: $MASTER"

if [ -z "$MASTER" ]
then
	next="-bootstrap"
else
	next="-join=$MASTER"
fi

consul agent -config-dir=/config "$next" "$@"
