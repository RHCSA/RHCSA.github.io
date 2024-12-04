## 08- Preserve system journals:

For the **RHCSA (Red Hat Certified System Administrator) exam**, the topic of **preserving system journals** refers to managing the system logs that are stored by the **`systemd` journal**, which is a central component responsible for logging system activities and events on a Red Hat-based Linux system (like RHEL or CentOS).


by default, the audit logs are temporary and are not being saved:

```bash
[root@centos-host bob]$ journalctl | grep "/log"
Mar 29 15:49:13 centos-host systemd-journald[318]: Runtime journal (/run/log/journal/2e407637679b477eb3e2a25b8ad9611d) is 820.0K, max 6.4M, 5.6M free.
```

#### Edit the configuration file for the systemd journal to make them persistent: `/etc/systemd/journald.conf`

```bash
[root@centos-host bob]$ vim /etc/systemd/journald.conf
```

#### Change `#Storage=auto` to `Storage=persistent`


#### Restart `systemd-journald`

```bash
[root@centos-host bob]$ systemctl restart systemd-journald.service

[root@centos-host bob]$ journalctl --flush
```

#### Now, we can see that they are saved in this path `/var/log/journal/`
```bash
[root@centos-host bob]$ journalctl | grep "/log"

Mar 29 16:53:39 centos-host systemd-journald[1727]: System journal (/var/log/journal/2e407637679b477eb3e2a25b8ad9611d) is 8.0M, max 4.0G, 3.9G free.
```
