#!/bin/bash
echo Starting burp... && \
chown 999:999 $PWD/burp/keys/privkey.pem && \
chown 999:999 $PWD/burp/logs && \
docker run -d --restart=always --name burp --hostname burp -p 53:8053 -p 53:8053/udp -p 80:8080 -p 443:8443 -p 25:8025 -p 587:8587 -p 465:8465 -v $PWD/burp/logs:/opt/burp/logs:rw -v $PWD/burp/keys:/opt/burp/keys:ro  -v $PWD/burp/conf:/opt/burp/conf:ro -v $PWD/burp/pkg:/opt/burp/pkg:ro burp  && \
echo Done.
