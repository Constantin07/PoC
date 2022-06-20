# Testing Kafka with Terraform provider for managing topics and ACLs.

## Prerequisites

### MacOS

Install required packages:

```bash
brew install openjdk@11
brew install kafka
```

### Linux

Run the `kafka_install.sh` script to install Kafka binaries in your HOME directory.

Set path to kafka binaries:

```bash
export PATH="$PATH:/usr/local/opt/kafka/bin"
```

## Generating certificates

See [secrets/README.md](secrets/README.md) for generating TLS certificates.

## Starting Kafka cluster locally

```bash
docker-compose up -d
```

Export list of brokers:

```bash
export BROKERS='localhost:19092,localhost:29092,localhost:39092'
```

## FAQ

List of active Kafka broker IDs in cluster:

```bash
zookeeper-shell localhost:2181 ls /brokers/ids
```

Return details of broker with given ID:

```bash
zookeeper-shell localhost:2181 get /brokers/ids/1
```

Show version of Kafka broker:

```bash
kafka-broker-api-versions --bootstrap-server localhost:19092 --version   (PLAINTEXT)
kafka-broker-api-versions --bootstrap-server localhost:19092 --command-config client.properties --version  (TLS)
```

### Topics

Get the list of topics:

```bash
kafka-topics --bootstrap-server $BROKERS --list
kafka-topics --bootstrap-server $BROKERS --command-config client.properties --list
```

Create topic:

```bash
kafka-topics 
```

Describe topic:

```bash
kafka-topics --bootstrap-server $BROKERS --describe --topic test-topic
kafka-topics --bootstrap-server $BROKERS --command-config client.properties --describe --topic test-topic
```

### Consume messages

Consume messages from topic:

```bash
kafka-console-consumer --bootstrap-server $BROKERS --topic test-topic --from-beginning
```

Consume messages from topic using consumer-group:

```bash
kafka-console-consumer --bootstrap-server $BROKERS --topic test-topic --group test-consumer-group
kafka-console-consumer --bootstrap-server $BROKERS --consumer.config client.properties --topic test-topic --group test-consumer-group
```

### Consumer groups

List consumer-groups:

```bash
kafka-consumer-groups --bootstrap-server $BROKERS --list
kafka-consumer-groups --bootstrap-server $BROKERS --command-config client.properties --list
```

Describe consumer-group:

```bash
kafka-consumer-groups --bootstrap-server $BROKERS --describe --group test-consumer-group
```

### ACLs

Get the list of ACLs:

```bash
kafka-acls --bootstrap-server $BROKERS --command-config client.properties --list
```
