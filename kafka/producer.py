#!/usr/bin/env python3

# This script sends test messages to Kafaka topic

from kafka import KafkaProducer
import time
import json
import random
from datetime import datetime

kafkaBrokers='localhost:19092,localhost:29092,localhost:39092'
caRootLocation='secrets/ca.pem'
certLocation='secrets/client.pem'
keyLocation='secrets/client.key'
topic='test-topic'
password='changeit'

producer = KafkaProducer(bootstrap_servers=kafkaBrokers,
            security_protocol='SSL',
            ssl_check_hostname=True,
            ssl_cafile=caRootLocation,
            ssl_certfile=certLocation,
            ssl_keyfile=keyLocation,
            ssl_password=password)

number = 0
while True:
    now = datetime.now()
    message = {
	'number': number,
	'id': random.randint(0,65535),
	'datetime': now.strftime("%m/%d/%Y, %H:%M:%S.%f")[:-3]
    }

    producer.send(topic, bytes(json.dumps(message),'utf-8'))
    producer.flush()
    time.sleep(0.2)
    number += 1
