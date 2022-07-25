# Certificates for Brokers

resource "tls_private_key" "broker" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "local_sensitive_file" "broker_key" {
  content         = tls_private_key.broker.private_key_pem
  filename        = "${path.module}/broker.key"
  file_permission = "0444"
}

resource "tls_cert_request" "broker" {
  private_key_pem = tls_private_key.broker.private_key_pem

  subject {
    common_name  = "localhost"
    organization = "Test"
  }

  dns_names = [
    "broker1",
    "broker2",
    "broker3",
    "localhost",
  ]

  ip_addresses = [
    "127.0.0.1",
  ]
}

resource "tls_locally_signed_cert" "broker" {
  cert_request_pem   = tls_cert_request.broker.cert_request_pem
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

resource "local_sensitive_file" "broker_cert" {
  content         = tls_locally_signed_cert.broker.cert_pem
  filename        = "${path.module}/broker.pem"
  file_permission = "0444"
}
