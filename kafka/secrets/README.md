# This terraform plan creates certificates and JSK keystore for Kafka brokers.

## Requirements

The following tools needs to be installed:

* `openssl`
* `terraform` (version > 0.14)
* `Java` (JRE or JDK)
* `bash`

The `JAVA_HOME` environment variable must be defined.

Make sure to set env. variable `PASSWORD` used for JKS keystore.
Create the `keystore_creds` file with the JKS keystore password (same as the above variable) as Kafka container requires it.

## How to generate certificates
In this directory run:

```bash
terraform init -upgrade
terraform apply
```
