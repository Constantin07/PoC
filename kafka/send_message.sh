#!/usr/bin/env bash

set -eu

source ./brokers

TOPIC="test-topic"

MSG_NUMBER=0
while true; do
    MESSAGE="{\"number\":\"$MSG_NUMBER\",\"id\":\"$RANDOM\",\"date\":\"`date`\"}"
    echo "$MESSAGE" | kafka-console-producer.sh --bootstrap-server "$BROKERS" --topic "$TOPIC"
    sleep 0.3
    ((MSG_NUMBER=MSG_NUMBER+1))
done
