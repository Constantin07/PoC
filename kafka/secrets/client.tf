# Client certificate

resource "tls_private_key" "client" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "local_sensitive_file" "client_key" {
  content         = tls_private_key.client.private_key_pem
  filename        = "${path.module}/client.key"
  file_permission = "0444"
}

resource "tls_cert_request" "client" {
  private_key_pem = tls_private_key.client.private_key_pem

  subject {
    common_name  = "client"
    organization = "Test"
  }
}

resource "tls_locally_signed_cert" "client" {
  cert_request_pem   = tls_cert_request.client.cert_request_pem
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

resource "local_sensitive_file" "client_cert" {
  content         = tls_locally_signed_cert.client.cert_pem
  filename        = "${path.module}/client.pem"
  file_permission = "0444"
}

resource "null_resource" "client" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
      set -eu

      rm -f client.p12

      openssl pkcs12 -export \
       -in client.pem \
       -inkey client.key \
       -chain -CAfile ca.pem \
       -name client \
       -caname "root" \
       -out client.p12 \
       -password pass:$PASSWORD
    EOT
  }

  triggers = {
    ca_key      = sha256(tls_private_key.ca.private_key_pem)
    ca_cert     = sha256(tls_self_signed_cert.ca.cert_pem)
    client_key  = sha256(tls_private_key.client.private_key_pem)
    client_cert = sha256(tls_locally_signed_cert.client.cert_pem)
  }
}
