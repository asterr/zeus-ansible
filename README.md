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
