# Burp Collaborator Server docker container with LetsEncrypt certificate and usage logging

This repository is an extension of the awesome work by [@morisson](https://github.com/morisson) in the original project [@integrity-sa/burpcollaborator-docker](https://github.com/integrity-sa/burpcollaborator-docker)

This repository includes a set of scripts to install a Burp Collaborator Server in a docker environment, using a LetsEncrypt wildcard certificate. To enable server-owners to monitor usage of their Burp Collaborator server, these scripts also setup [CollaboratorLogProxy](https://github.com/coreyd97/collaboratorlogproxy) with rolling-logs stored in `./burp/logs`.

The objective is to simplify as much as possible the process of setting up and maintaining the server.

## Setup your domain

Delegate a subdomain to your soon to be burp collaborator server IP address. At the minimum you'll need a NS record for the subdomain to be used (e.g. burp.example.com) pointing to your new server's A record:

```burp.example.com IN NS burpserver.example.com```

```burpserver.example.com IN A 1.2.3.4```

Check https://portswigger.net/burp/documentation/collaborator/deploying#dns-configuration for further info.

## Requirements

* Internet accessible server
* bash
* docker
* bc
* openssl
* Burp Suite Professional

## Setup the environment

* Clone or download the repository to the server (tested on ubuntu 16.04) to a directory of your choice.
* Put the Burp Suite JAR file in ```./burp/pkg/burp.jar``` (make sure the name is exactly ```burp.jar```, and it is the actual file **not a link**)
* Put the [CollaboratorLogProxy](https://github.com/CoreyD97/CollaboratorLogProxy/releases/latest) JAR file in ```./burp/pkg/CollaboratorLogProxy.jar```
* Run init.sh with your subdomain and server public IP address as argument:

```./init.sh burp.example.com 1.2.3.4```

This will start the environment for the subdomain ```burp.example.com```, creating a wildcard certificate as ```*.burp.example.com```.

I'm using an ugly hack on the certbot-dns-cloudflare plugin from certbot, where it just runs a local dnsmasq with the required records, and makes
all of this automagically happen.

If everything is OK, burp will start with the following message:

> Burp is now running with the letsencrypt certificate for domain *.burp.example.com

You can check by running ```docker ps```, and going to burp, and pointing the collaborator configuration to your new server.  
~~Keep it mind that this configuration configures the *polling server on port 9443*.~~ (Not applicable when using this version)

The init.sh script will be renamed and disabled, so no accidents may happen.

## Accessing Logs

At the moment, only polling requests which return interactions are logged to prevent logs being spammed.

Logs can be viewed directly using ```docker logs burp```, or by viewing the log files created at ```./burp/logs/```.

## Certificate renewal

* There's a renewal script in ```./certbot/certificaterenewal.sh```. When run, it renews the certificate if it expires in 30 days or less;
* Optionally, edit the RENEWDAYS variable if you wish to. By default it will renew the certificate every 60 days. *If you want to force the renewal to check if everything is working, just set it to 89 days, and run it manually. Remember to set it back to 60 afterwards.*;
* Set your crontab to run this script once a day.

## Updating Burp Suite

* Download it and make sure you put it in ```./burp/pkg/burp.jar```
* Restart the container with ```docker restart burp```

## Updating CollaboratorLogProxy

* Download it and make sure you put it in ```./burp/pkg/CollaboratorLogProxy.jar```
* Restart the container with ```docker restart burp```

---
**Original Author:** [Bruno Morisson](https://twitter.com/morisson)
**Logging Functionality:** [Corey Arthur](https://twitter.com/CoreyD97)

Thanks to [Fábio Pires](https://twitter.com/fabiopirespt) (check his burp collaborator w/letsencrypt [tutorial](https://blog.fabiopires.pt/running-your-instance-of-burp-collaborator-server/)) and [Herman Duarte](https://twitter.com/hdontwit) (for betatesting and fixes)


