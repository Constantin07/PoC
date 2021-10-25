# CA resources

resource "tls_private_key" "ca" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "local_file" "ca_key" {
  sensitive_content = tls_private_key.ca.private_key_pem
  filename          = "${path.module}/ca.key"
  file_permission   = "0444"
}

resource "tls_self_signed_cert" "ca" {
  key_algorithm   = tls_private_key.ca.algorithm
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name         = "Root CA"
    organization        = "Test"
    organizational_unit = "None"
    province            = "GB"
    country             = "UK"
    street_address      = []
  }

  is_ca_certificate  = true
  set_subject_key_id = true

  validity_period_hours = 87600
  early_renewal_hours   = 2160

  allowed_uses = [
    "cert_signing",
    "crl_signing",
    "key_encipherment",
    "digital_signature",
  ]
}

resource "local_file" "ca_cert" {
  content         = tls_self_signed_cert.ca.cert_pem
  filename        = "${path.module}/ca.pem"
  file_permission = "0444"
}
