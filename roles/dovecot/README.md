# dovecot

Installs Dovecot (IMAP) and local mail utilities.

Configuration targets Dovecot 2.4 (Ubuntu 26.04+). Local settings live in
`/etc/dovecot/conf.d/99-local.conf` (from `files/99-local.conf`); the stock
`conf.d` files are left untouched:

- `ssl = required`, using the certificates in `files/certs/`
- IMAPS on port 993; plain IMAP disabled

## Upgrading from 2.3

Earlier versions of this role modified `10-master.conf` and `10-ssl.conf` in
place, so the 2.4 package upgrade leaves the new stock files as
`*.ucf-dist`. The role restores those (backing up the old files) and runs
`doveconf -n` to validate the config before starting the service.

## License

BSD
