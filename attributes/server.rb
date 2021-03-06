default[:burp][:server][:config_dir] = '/etc/burp'
default[:burp][:server][:config] = {
	:mode => 'server',
	:port => '4971',
	:status_port => '4972',
	:directory => '/var/spool/burp',
	:clientconfdir => '/etc/burp/clientconfdir',
	:pidfile => '/var/run/burp.server.pid',
	:hardlinked_archive => '0',
	:working_dir_recovery_method => 'delete',
	:max_children => '5',
	:max_status_children => '5',
	:user => 'root',
	:group => 'root',
	:umask => '0022',
	:syslog => '1',
	:stdout => '0',
	:client_can_delete => '1',
	:client_can_force_backup => '1',
	:client_can_list => '1',
	:client_can_restore => '1',
	:client_can_verify => '1',
	:version_warn => '1',
	:keep => '7',
	:ca_conf => '/etc/burp/CA.cnf',
	:ca_name => 'burpCA',
	:ca_server_name => 'burpserver',
	:ca_burp_ca => '/usr/sbin/burp_ca',
	:ssl_cert_ca => '/etc/burp/ssl_cert_ca.pem',
	:ssl_cert => '/etc/burp/ssl_cert-server.pem',
	:ssl_key => '/etc/burp/ssl_cert-server.key',
	:ssl_key_password => 'password',
	:ssl_dhfile => '/etc/burp/dhfile.pem',
	:timer_script => '/etc/burp/timer_script',
	:timer_arg => [
		'20h',
		'Mon,Tue,Wed,Thu,Fri,00,01,02,03,04,05,19,20,21,22,23',
		'Sat,Sun,00,01,02,03,04,05,06,07,08,17,18,19,20,21,22,23',
	],
}

default[:burp][:default] = {
	:clientconf => {
		:include => ['/etc', '/usr/local'],
		:timer => [
			'24h',
			'Mon,Tue,Wed,Thu,Fri,Sat,Sun,00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23'
		],
	},
}
