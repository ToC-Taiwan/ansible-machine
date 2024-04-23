# INIT MAIL

## dkim

```sh
cat /root/ansible-data/dms/config/opendkim/keys/tocraw.com/mail.txt
```

```sh
v=DKIM1; h=sha256; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxpZ/JkXdd6ExSxGndMnU8ON/YOJuEQ4Wp+hDt2/idiCypyKDsn2IzecHXjnzcCdX7lYQf7vrCIX7Kh0ua6fo95shSGANd3ZMPbwD4AEznblxllhodRkKmlxVVzYzo86T3GgERGtMDv9tz3k8ci2hXi8F6r3GL+Qiqysd2DlrABahviGCRHkgBH11XQSv5Y6w+VB1zp76zoopoZNYCFE5PRkECx1s8L9/AOYmsPW3x+QFGW5lbCvNhNHc09uegk7wSr7/HzTF6eicxyxhEFUlPt7YYjA7tqk/DHiVfo3FR4H/lXDbTA9XmQJn9LtCrrkbknovNN/skt/HQRZ4XSubqwIDAQAB
```

## dmrc

```sh
_dmarc.tocraw.com. IN TXT "v=DMARC1; p=none; rua=mailto:maochindada@gmail.com; ruf=mailto:maochindada@gmail.com; sp=none; ri=86400"
```
