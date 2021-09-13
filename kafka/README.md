# Testing Kafka with Terraform provider for managing topics and ACLs.

## Prerequisites (MacOS)

Install required packages

```bash
brew install openjdk@11
brew install kafka
```

Set path to kafka binaries:
```bash
export PATH="$PATH:/usr/local/opt/kafka/bin"
```

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
kafka-broker-api-versions --bootstrap-server localhost:19092 --version
```

Create topic:
```bash
kafka-topics 
```