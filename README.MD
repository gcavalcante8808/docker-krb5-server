Krb5 Server
-----------

This is a gcavalcante8808/krb5-server image with MIT Kerberos v5 installed.

Simple Usage
------------

If you just want to create a Krb5 Server from scratch, just clone the repository and use docker-compose to bring it up quickly:

```
    cd tmp
    git clone https://github.com/gcavalcante8808/docker-krb5-server.git
    cd docker-krb5-server
    docker-compose up -d
```

Usage
-----

You need to supply the following environment variables:

 * KRB5_REALM (MANDATORY): Your KRB5 REALM name in Upper Case and DNS format, like EXAMPLE.COM;
 * KRB5_KDC (MANDATORY): Your KRB5 KDC Address. It's recommended that you use a TXT Dns entry, but you can use localhost for a simple installation (if you use localhost you can't setup the KDC slaves later ...);
 * KRB5_ADMINSERVER(OPTIONAL): If not provided will be the same value that was provided for KRB5_KDC;
 * KRB5_PASS: KDB and **admin** password for the database. If you don't provide this value, one will be created and printed in the first time that container is started; **write down this password, it is necessary to login with kadmin and unblock the kdb files**.

With all this information, you can now run the container:

```
    docker run -d --name krb5-server -e KRB5_REALM=EXAMPLE.COM -e KRB5_KDC=localhost -e KRB5_PASS=mypass -p 88:88 -p 464:464 -p 749:749 gcavalcante8808/krb5-server
```

If you haven't provided the password, find him at the logs:

```
    docker logs krb5-server
```

To acquire a ticket from your new domain, create a krb5.conf on "/etc" with the following config:

```
[libdefaults]
 dns_lookup_realm = false
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true
 rdns = false
 default_realm = YOURREALM.FQDN
 
[realms]
 YOURREALM.FQDN = {
    kdc = localhost
    admin_server = localhost
 }

```

By Default just the user admin/admin@REALM is created; to test the setup, try to acquire the ticket with the following commands:

```
    kinit admin/admin@YOURREALM.FQDN # Will prompt for the password provided or the generated.
    klist
```

**The Default Kadmin policy allows all members inside /admin policy to do anything in your kerberos database(default to * perm); if you need a more simple user, you can create users with /service policy (which defaults to aci perm)**.

Note About Low Entropy and Kerberos Database Creation
-----------------------------------------------------

If your container won't start properly and show a message like "Loading random data" for a couple minutes, it indicates that the system don't have enough entropy available to provide a secure cryptographic loop to the program.

In this case you can use rngd (will be necessary to restart the container after this):

```
    /sbin/rngd
```

You can use havaged as well, as we can see in the digitalOcean tutorial:

https://www.digitalocean.com/community/tutorials/how-to-setup-additional-entropy-for-cloud-servers-using-haveged

After this, you just need to restart your container and it is g-n-go.

Other Information
-----------------

This container uses the Krb5-Server provided by the Alpine Team. Take a look at the alpine site to verify the available versions of the package.

For more information on how to configure the clients or even the server take a loot at the MIT Krb5 Documentation.

Check the issues page at github if you want to contribute or profile a bug/request/enhancement.

Running Tests
-------------

There are a set of tests (written in python) available on the tests directory. 

You can the tests by running `make run-tests-on-docker` command.

Note: By Default, it requires docker/docker-compose and make installed and working.
