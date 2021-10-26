# Terraform certificate

resource "tls_private_key" "terraform" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "local_file" "terraform_key" {
  sensitive_content = tls_private_key.terraform.private_key_pem
  filename          = "${path.module}/terraform.key"
  file_permission   = "0444"
}

resource "tls_cert_request" "terraform" {
  key_algorithm   = tls_private_key.terraform.algorithm
  private_key_pem = tls_private_key.terraform.private_key_pem

  subject {
    common_name  = "Terraform"
    organization = "Test"
  }

}

resource "tls_locally_signed_cert" "terraform" {
  cert_request_pem   = tls_cert_request.terraform.cert_request_pem
  ca_key_algorithm   = tls_private_key.ca.algorithm
  ca_private_key_pem = tls_private_key.ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  is_ca_certificate     = false
  validity_period_hours = 87600
  early_renewal_hours   = 3160

  allowed_uses = [
    "digital_signature",
    "server_auth",
    "client_auth",
    "data_encipherment",
    "key_encipherment",
  ]
}

resource "local_file" "terraform_cert" {
  sensitive_content = tls_locally_signed_cert.terraform.cert_pem
  filename          = "${path.module}/terraform.pem"
  file_permission   = "0444"
}
