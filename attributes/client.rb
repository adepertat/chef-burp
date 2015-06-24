default[:burp][:client][:run_with_cron] = true
default[:burp][:client][:time] = :daily
default[:burp][:client][:mailto] = 'root'

default[:burp][:client][:binary] = '/usr/sbin/burp'
default[:burp][:client][:config_dir] = '/etc/burp'
default[:burp][:client][:config] = {
	:mode => 'client',
	:port => '4971',
	:pidfile => '/var/run/burp.client.pid',
	:syslog => '1',
	:stdout => '1',
	:user => 'root',
	:group => 'root',
	:progress_counter => '1',
	:server_can_restore => '1',
	:cross_filesystem => '/home',
	:cross_all_filesystems => '0',
	:ca_burp_ca => '/usr/sbin/burp_ca',
	:ca_csr_dir => '/etc/burp/CA-client',
	:ssl_cert_ca => '/etc/burp/ssl_cert_ca.pem',
	:ssl_cert => '/etc/burp/ssl_cert-client.pem',
	:ssl_key => '/etc/burp/ssl_cert-client.key',
	:ssl_key_password => 'password',
	:ssl_peer_cn => 'burpserver',
	:exclude_fs => 'sysfs',
	:exclude_fs => 'tmpfs',
	:nobackup => '.nobackup',
	:exclude_comp => [
		'bz2',
		'gz',
	],
}
