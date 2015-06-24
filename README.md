burp Cookbook
=============
Installs and enables [burp (BackUp and Restore Program)](http://burp.grke.org/).

Requirements
------------
This cookbook only supports GNU/Linux systems. It has only been tested on
Ubuntu 14.04.

Recipes
-------
The default recipe installs and configures the burp client:

- Installs burp through the packaging system
- Schedules the burp client to run each day with a cron job

If you want to configure the client and the server together, you should use the
`client` and `server` recipes, which rely on chef roles.

### `burp::install`

Installs the burp package, leaving it with the default configuration.

### `burp::client` and `burp::server`

All nodes that will be burp clients should have the role `burp-client`. The
node that will be the server should have the `burp-server` role. These are only
default values and you can change them through the `[:burp][:role][:client]`
and `[:burp][:role][:server]` attributes.

You can then set the frequency of the backup run with
`[:burp][:client][:time]`, which takes any value that the `time` attribute of
the resource [`cron`](https://docs.chef.io/resource_cron.html) can take .

The recipe will store the client configuration in `/etc/burp/burp.conf` and source two files :

- `/etc/burp/burp.conf.local` : contains the server name and the client name
- `/etc/burp/burp.conf.password` : only contains the password

The password will be stored as an attribute (`[:burp][:client][:password]`) and
thus can be retrieved by the server recipe to generate the client configuration
directory files.

#### Usage

The recipe should behave automagically with just the following on your clients :

```ruby
node[:burp][:role][:client] = 'whatever-your-base-role-is'
```

and setting the `burp-server` role on your burp server node.

Attributes
----------

### default

Attribute                |Default        |Description
-------------------------|---------------|-----------------------------------------
`[:burp][:role][:server]`|`'burp-server'`|Chef role to give to the burp clients for automagic configuration
`[:burp][:role][:client]`|`'burp-client'`|Chef role to give to the burp server for automagic configuration

### client

Attribute                                           |Default            |Description
----------------------------------------------------|-------------------|-----------------------------------------
`[:burp][:client][:run_with_cron]`                  |`true`             |Should a user cron be created to run the burp client ?
`[:burp][:client][:time]`                           |`:daily`           |Frequency of the client runs. See [`cron`](https://docs.chef.io/resource_cron.html) for the possible values
`[:burp][:client][:mailto]`                         |`'root'`           |Recipient of the cron email of the client runs
`[:burp][:client][:binary]`                         |`'/usr/sbin/burp'` |Where is the burp binary ?
`[:burp][:client][:config_dir]`                     |`'/etc/burp'`      |Configuration folder
`[:burp][:client][:config][:mode]`                  |`'client'`         |All the remaining values are configuration directives and will be added to the main configuration file (`burp.conf`). If a directive should be specified multiple times, declare it as an array.
`[:burp][:client][:config][:port]`                  |`'4971'`           |
`[:burp][:client][:config][:pidfile]`               |`'/var/run/burp.client.pid'`|
`[:burp][:client][:config][:syslog]`                |`'1'`|
`[:burp][:client][:config][:stdout]`                |`'1'`|
`[:burp][:client][:config][:user]`                  |`'root'`|
`[:burp][:client][:config][:group]`                 |`'root'`|
`[:burp][:client][:config][:progress_counter]`      |`'1'`|
`[:burp][:client][:config][:server_can_restore]`    |`'1'`|
`[:burp][:client][:config][:cross_filesystem]`      |`'/home'`|
`[:burp][:client][:config][:cross_all_filesystems]` |`'0'`|
`[:burp][:client][:config][:ca_burp_ca]`            |`'/usr/sbin/burp_ca'`|
`[:burp][:client][:config][:ca_csr_dir]`            |`'/etc/burp/CA-client'`|
`[:burp][:client][:config][:ssl_cert_ca]`           |`'/etc/burp/ssl_cert_ca.pem'`|
`[:burp][:client][:config][:ssl_cert]`              |`'/etc/burp/ssl_cert-client.pem'`|
`[:burp][:client][:config][:ssl_key]`               |`'/etc/burp/ssl_cert-client.key'`|
`[:burp][:client][:config][:ssl_key_password]`      |`'password'`|
`[:burp][:client][:config][:ssl_peer_cn]`           |`'burpserver'`|
`[:burp][:client][:config][:exclude_fs]`            |`'sysfs'`|
`[:burp][:client][:config][:exclude_fs]`            |`'tmpfs'`|
`[:burp][:client][:config][:nobackup]`              |`'.nobackup'`|
`[:burp][:client][:config][:exclude_comp]`          |`[ 'bz2','gz']`|

### server

Attribute                                           |Default            |Description
----------------------------------------------------|-------------------|-----------------------------------------
`[:burp][:client][:config_dir]`                     |`'/etc/burp'`      |Configuration folder
`[:burp][:default][:clientconf][:include]`          |`['/etc', '/usr/local']`|Default includes in the client configuration directory
`[:burp][:default][:clientconf][:timer]`            |`['24h','Mon,Tue,Wed,Thu,Fri,Sat,Sun,00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23']`|Default timers in the client configuration directory
`[:burp][:server][:config][:mode]`                  |`'server'`|All the remaining values are configuration directives and will be added to the main configuration file (`burp-server.conf`). If a directive should be specified multiple times, declare it as an array.
`[:burp][:server][:config][:port]`                  |`'4971'`|
`[:burp][:server][:config][:status_port]`           |`'4972'`|
`[:burp][:server][:config][:directory]`             |`'/var/spool/burp'`|
`[:burp][:server][:config][:clientconfdir]`         |`'/etc/burp/clientconfdir'`|
`[:burp][:server][:config][:pidfile]`               |`'/var/run/burp.server.pid'`|
`[:burp][:server][:config][:hardlinked_archive]`    |`'0'`|
`[:burp][:server][:config][:working_dir_recovery_method]` |`'delete'`|
`[:burp][:server][:config][:max_children]`          |`'5'`|
`[:burp][:server][:config][:max_status_children]`   |`'5'`|
`[:burp][:server][:config][:user]`                  |`'root'`|
`[:burp][:server][:config][:group]`                 |`'root'`|
`[:burp][:server][:config][:umask]`                 |`'0022'`|
`[:burp][:server][:config][:syslog]`                |`'1'`|
`[:burp][:server][:config][:stdout]`                |`'0'`|
`[:burp][:server][:config][:client_can_delete]`     |`'1'`|
`[:burp][:server][:config][:client_can_force_backup]` |`'1'`|
`[:burp][:server][:config][:client_can_list]`       |`'1'`|
`[:burp][:server][:config][:client_can_restore]`    |`'1'`|
`[:burp][:server][:config][:client_can_verify]`     |`'1'`|
`[:burp][:server][:config][:version_warn]`          |`'1'`|
`[:burp][:server][:config][:keep]`                  |`'7'`|
`[:burp][:server][:config][:ca_conf]`               |`'/etc/burp/CA.cnf'`|
`[:burp][:server][:config][:ca_name]`               |`'burpCA'`|
`[:burp][:server][:config][:ca_server_name]`        |`'burpserver'`|
`[:burp][:server][:config][:ca_burp_ca]`            |`'/usr/sbin/burp_ca'`|
`[:burp][:server][:config][:ssl_cert_ca]`           |`'/etc/burp/ssl_cert_ca.pem'`|
`[:burp][:server][:config][:ssl_cert]`              |`'/etc/burp/ssl_cert-server.pem'`|
`[:burp][:server][:config][:ssl_key]`               |`'/etc/burp/ssl_cert-server.key'`|
`[:burp][:server][:config][:ssl_key_password]`      |`'password'`|
`[:burp][:server][:config][:ssl_dhfile]`            |`'/etc/burp/dhfile.pem'`|
`[:burp][:server][:config][:timer_script]`          |`'/etc/burp/timer_script'`|
`[:burp][:server][:config][:timer_arg]`             |`['20h','Mon,Tue,Wed,Thu,Fri,00,01,02,03,04,05,19,20,21,22,23','Sat,Sun,00,01,02,03,04,05,06,07,08,17,18,19,20,21,22,23']`|

License & Authors
-----------------
- Author: Albéric de Pertat (<alberic@depertat.net>)
- License : GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007
