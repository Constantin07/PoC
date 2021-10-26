terraform {
  required_providers {
    kafka = {
      source  = "Mongey/kafka"
      version = ">= 0.4.1"
    }
  }
}

provider "kafka" {
  bootstrap_servers = ["localhost:19092", "localhost:29092", "localhost:39092"]

  ca_cert         = file("./secrets/ca.pem")
  client_cert     = file("./secrets/terraform.pem")
  client_key      = file("./secrets/terraform.key")
  tls_enabled     = true
  skip_tls_verify = false
}

resource "kafka_topic" "test-topic" {
  name               = "test-topic"
  replication_factor = 2
  partitions         = 3

  config = {
    "cleanup.policy" = "compact,delete"
    "segment.ms"     = "4000"
    "retention.ms"   = "86400000"
  }
}
