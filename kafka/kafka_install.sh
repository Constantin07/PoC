#!/usr/bin/env bash

# Install Kafka

# Set PATH to Kafka binaries in ~/.bash_profile
# PATH=$PATH:$HOME/kafka/bin

set -eu

KAFKA_VERSION="3.0.0"
SCALA_VERSION="2.13"
FILE_NAME="kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz"
URL="https://dlcdn.apache.org/kafka/${KAFKA_VERSION}/${FILE_NAME}"
INSTALL_DIR="$HOME/kafka"

rm -rf "${INSTALL_DIR}"
mkdir -p "${INSTALL_DIR}"

curl -sSfL --retry 3 -o "${FILE_NAME}" "${URL}"
tar -xzf "${FILE_NAME}" -C "${INSTALL_DIR}" --strip-components 1

rm -f "${FILE_NAME}"
