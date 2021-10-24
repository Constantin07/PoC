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

  # ca_cert         = file("../secrets/ca.crt")
  # client_cert     = file("../secrets/terraform-cert.pem")
  # client_key      = file("../secrets/terraform.pem")
  tls_enabled     = false
  skip_tls_verify = true
}

resource "kafka_topic" "test-topic" {
  name               = "test-topic"
  replication_factor = 2
  partitions         = 3

  config = {
    "cleanup.policy" = "delete"
    "segment.ms"     = "4000"
    "retention.ms"   = "86400000"
  }
}
