# docker-ejabberd

[Ejabberd][ejabberd] server version 14.07. 

This build has SSL, LDAP, and ODBC enabled.

`/etc/ejabberd` is exposed as a volume, so you can mount your config + keys in as a volume.

`/var/lib/ejabberd` and `/var/log/ejabberd` are also both exposed as volumes.

[ejabberd]: http://ejabberd.im

## Usage

### Build

```
$ docker build -t <repo name> .
```

### Run in foreground

```
$ docker run -p 5222 -p 5269 -p 5280 -p 4560 asqar/ejabberd
```

### Run in background

```
$ docker run -d -p 5222:5222 -p 5269:5269 -p 5280:5280 -p 4560:4560 asqar/ejabberd
```

## Versions

* Erlang 16B3-1
* Ejabberd 14.07

## Exposed ports

* 5222
* 5269
* 5280
* 4560

## Exposed volumes

* `/etc/ejabberd`
* `/var/lib/ejabberd`
* `/var/log/ejabberd`
