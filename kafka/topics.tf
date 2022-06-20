resource "kafka_topic" "test_topic" {
  name               = "test-topic"
  replication_factor = 2
  partitions         = 3

  config = {
    "cleanup.policy" = "delete"
    "segment.ms"     = "4000"
    "retention.ms"   = "86400001"
  }

  lifecycle {
    create_before_destroy = false
  }
}
