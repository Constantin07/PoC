# JKS keystore

resource "null_resource" "keystore" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
      set -eu
      openssl pkcs12 -export \
       -in broker.pem \
       -inkey broker.key \
       -CAfile ca.pem \
       -name broker \
       -out broker.p12 \
       -password pass:$PASSWORD

       keytool -importkeystore \
       -noprompt \
       -srcstoretype PKCS12 \
       -srckeystore broker.p12 \
       -srcstorepass $PASSWORD \
       -destkeystore kafka.broker.jks \
       -deststorepass $PASSWORD
    EOT
  }

  triggers = {
    ca_key      = sha256(tls_private_key.ca.private_key_pem)
    ca_cert     = sha256(tls_self_signed_cert.ca.cert_pem)
    broker_key  = sha256(tls_private_key.broker.private_key_pem)
    broker_cert = sha256(tls_locally_signed_cert.broker.cert_pem)
  }
}