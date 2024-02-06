# INIT MAIL

## dkim

```sh
cat /root/ansible-data/dms/config/opendkim/keys/tocraw.com/mail.txt
```

```sh
v=DKIM1; h=sha256; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA3QX9jZwtKyfFqcCfo1dVzf7xVp8OP7M41Hq3DID5EXmWplF0UiOkRbBTGS2xdr1rqR/GneP+iDPxJhLNU3cnumrdLgY2IPF8ST1QNj7382Ea6Lb6tQU6sf/Vn9/9LXX9gV2KEp0HowWtSq7p5TNjSx3YULOwGks7MtikIO6oHSSiKC3xu0tqQkK/MAmA3A/TUb8qC2BAqY+4IqE2HOiv3U2QxpS2ENB1g2m1U5Pn3jeOjv4Ora9Tyzy+bLhQMVqM75w8ePshuqb/gvTzOr4xrzApsei/sV+/gN/ClfGCz9rtl6bKsnjW/IJMM7iM84u8G6auqRvDY5HIWdTCWReVLQIDAQAB
```

## dmrc

```sh
_dmarc.tocraw.com. IN TXT "v=DMARC1; p=none; rua=mailto:maochindada@gmail.com; ruf=mailto:maochindada@gmail.com; sp=none; ri=86400"
```
