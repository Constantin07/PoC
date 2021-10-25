This terraform plan created JSK keystore for Kafka brokers.

Make sure to set env. variable `PASSWORD` used for JKS keystore.
THe `JAVA_HOME` environment variable must be set too.

Kafka container expects the secret to be stored in the `keystore_creds` file.
