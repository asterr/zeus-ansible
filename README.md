# zeus-ansible

Ref: https://www.howtoforge.com/ansible-guide-create-ansible-playbook-for-lemp-stack/


Cron Job:

as asterr:

```
*/15 * * * * if ! out=`ansible-playbook /home/asterr/zeus-ansible/site.yml`; then echo $out; fi
```
