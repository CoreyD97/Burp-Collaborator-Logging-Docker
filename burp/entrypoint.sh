#!/bin/sh
cd /opt/burp
exec java -jar /opt/burp/pkg/CollaboratorLogProxy.jar /opt/burp/conf/LogProxy.properties &
exec java -jar /opt/burp/pkg/burp.jar --collaborator-server --collaborator-config=/opt/burp/conf/burp.config
