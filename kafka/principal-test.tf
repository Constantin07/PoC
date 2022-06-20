# Administrator access

variable "test_principal" {
  description = "Test principal"
  type        = string
  default     = "User:CN=Terraform,OU=Some Org Here,O=Test Org,L=London,C=GB"
}

# Test topic access
resource "kafka_acl" "test_topic" {
  resource_name       = "test-topic"
  resource_type       = "Topic"
  acl_principal       = var.test_principal
  acl_operation       = "All"
  acl_permission_type = "Allow"
  acl_host            = "*"

  depends_on = [
    kafka_acl.admin_cluster,
    kafka_topic.test_topic
  ]
}
