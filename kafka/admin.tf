# Administrator access

variable "admin_principal" {
  description = "Administrator principal"
  type        = string
  default     = "User:CN=Terraform,O=Test"
}

variable "broker_principal" {
  description = "Broker principal"
  type        = string
  default     = "User:CN=localhost,O=Test"
}

# Admin cluster operations
resource "kafka_acl" "admin_cluster" {
  resource_name       = "kafka-cluster"
  resource_type       = "Cluster"
  acl_principal       = var.admin_principal
  acl_operation       = "All"
  acl_permission_type = "Allow"
  acl_host            = "*"
}

resource "kafka_acl" "broker_cluster" {
  resource_name       = "kafka-cluster"
  resource_type       = "Cluster"
  acl_principal       = var.broker_principal
  acl_operation       = "All"
  acl_permission_type = "Allow"
  acl_host            = "*"

  # Make sure we don't lock Admin pricncipal if cluster permission is added first
  depends_on = [kafka_acl.admin_cluster]
}

# Admin topic access
resource "kafka_acl" "admin_topic" {
  resource_name       = "*"
  resource_type       = "Topic"
  acl_principal       = var.admin_principal
  acl_operation       = "All"
  acl_permission_type = "Allow"
  acl_host            = "*"
}

# Admin group operations
resource "kafka_acl" "admin_group" {
  resource_name       = "*"
  resource_type       = "Group"
  acl_principal       = var.admin_principal
  acl_operation       = "All"
  acl_permission_type = "Allow"
  acl_host            = "*"
}

# Admin transactional operations
resource "kafka_acl" "admin_transactional" {
  resource_name       = "*"
  resource_type       = "TransactionalID"
  acl_principal       = var.admin_principal
  acl_operation       = "All"
  acl_permission_type = "Allow"
  acl_host            = "*"
}

