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
    docker run -d --name krb5-server -e KRB5_REALM=EXAMPLE.COM -e KRB5_KDC=localhost -e KRB5_PASS=mypass gcavalcante8808/krb5-server
```

Other Information
-----------------

This container uses the Krb5-Server provided by the Alpine Team. Take a look at the alpine site to verify available versions of the package.

For more information on how to configure the clients or even the server take a loot at the MIT Krb5 Documentation.

Check the issues page at github if want to contribute or profile a bug/request/enhancement.
