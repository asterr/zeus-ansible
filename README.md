# zeus-ansible

Ref: https://www.howtoforge.com/ansible-guide-create-ansible-playbook-for-lemp-stack/


Cron Job:

as asterr:

```
*/15 * * * * if ! out=`ansible-playbook /home/asterr/zeus-ansible/site.yml`; then echo $out; fi
```

## Ubuntu 25.10+ / sudo-rs

Ubuntu 25.10 and later ship `sudo-rs` as the default `sudo`. It wraps the
password prompt (`[sudo: <prompt>] Password:`), so Ansible never detects it
and times out waiting for become. `ansible.cfg` sets `become_exe = sudo.ws`
to use the classic sudo binary, which must remain installed
(`ls /usr/bin/sudo.ws`).

## Ansible PPA signing key

The signing key for the `ppa:ansible/ansible` repository is vendored at
`roles/common/files/ansible-ppa.asc` (fingerprint
`6125E2A8C77F2818FB7BD15B93C4A3FD7BB9C367`, no expiry) and installed with
`copy`. Fetching it from keyserver.ubuntu.com at runtime is not idempotent:
the keyserver ignores `If-Modified-Since` and its armor headers vary between
backends, so `get_url` rewrote the file and reported `changed` on every run.

### Checking for a new upstream key

Compare the key the PPA currently signs with against the vendored copy:

```sh
curl -s https://api.launchpad.net/1.0/~ansible/+archive/ubuntu/ansible \
  | python3 -c 'import json,sys; print(json.load(sys.stdin)["signing_key_fingerprint"])'

gpg --show-keys roles/common/files/ansible-ppa.asc
```

A rotated key also shows up on the host as `apt update` failing for the PPA
with `NO_PUBKEY <id>`, usually failing the "Install ansible" task with it.

### Updating the key

If the fingerprints differ, fetch the new key, strip the empty hostname
header (it has trailing whitespace), and verify it:

```sh
FPR=<new fingerprint>
curl -s "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x$FPR" \
  | sed '/^Comment: Hostname: *$/d' > roles/common/files/ansible-ppa.asc
gpg --show-keys roles/common/files/ansible-ppa.asc   # confirm fingerprint + uid
```

Update the fingerprint in the comment above the "Install ansible PPA signing
key" task in `roles/common/tasks/main.yml` and in this section, then commit on
a feature branch.
