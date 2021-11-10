# JKS keystore for brokers

resource "null_resource" "keystore" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
      set -eu

      rm -f broker.keystore.jks

      openssl pkcs12 -export \
       -in broker.pem \
       -inkey broker.key \
       -chain -CAfile ca.pem \
       -name broker \
       -caname "root" \
       -out broker.p12 \
       -password pass:$PASSWORD

      keytool -importkeystore \
       -noprompt \
       -srcstoretype PKCS12 \
       -srckeystore broker.p12 \
       -srcstorepass $PASSWORD \
       -destkeystore broker.keystore.jks \
       -deststoretype pkcs12 \
       -deststorepass $PASSWORD

      rm -f broker.truststore.jks
      cp $JAVA_HOME/lib/security/cacerts broker.truststore.jks
      keytool -import -noprompt -alias root -file ca.pem -storetype JKS -keystore broker.truststore.jks -storepass $PASSWORD -trustcacerts

    EOT
  }

  triggers = {
    ca_key      = sha256(tls_private_key.ca.private_key_pem)
    ca_cert     = sha256(tls_self_signed_cert.ca.cert_pem)
    broker_key  = sha256(tls_private_key.broker.private_key_pem)
    broker_cert = sha256(tls_locally_signed_cert.broker.cert_pem)
  }
}
