#
# Cookbook Name:: burp
# Recipe:: server
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
include_recipe 'burp::install'

# CONFIGURATION
# =============
template "#{node[:burp][:server][:config_dir]}/burp-server.conf" do
	source 'burp-server.conf.erb'
	owner 'root'
	group node[:burp][:server][:config][:group]
	mode '0640'
	notifies :restart, 'service[burp]'
	variables({:settings => node[:burp][:server][:config]})
end

# CLIENT CONFIGURATIONS
# =====================
# Iterate over all nodes with a burp password (node[:burp][:client][:password])
# and create their client configuration in the burp clientconfdir.
client_query = "burp_client_password:*"

results = search(:node, "#{client_query} AND chef_environment:#{node.chef_environment}")
clients = results.map { |n|
	[ 
		n[:fqdn],
		n[:burp].fetch(:client, {}).fetch(:password, ''),
		n[:burp].fetch(:clientconf, {:include => [], :timer => []}) 
	]
}

default_includes = node[:burp][:default][:clientconf].fetch(:include, [])
default_timer = node[:burp][:default][:clientconf].fetch(:timer, [])
clients.each do |fqdn, password, clientconf|
	if fqdn
		includes = default_includes
		timer = default_timer
		if clientconf
			includes += clientconf[:include]
			timer += clientconf[:timer]
		end
		template "#{node[:burp][:server][:config_dir]}/clientconfdir/#{fqdn}" do
			source 'clientconf.erb'
			variables({
				:password => password,
				:include => includes,
				:timer => timer,
			})
		end
	end
end

# SERVICE
# =======
template '/etc/default/burp' do
	source 'default_burp.erb'
	variables({:config_dir => node[:burp][:server][:config_dir]})
	owner 'root'
	group node[:burp][:server][:config][:group]
	mode '0640'
end

service 'burp' do
	action [ :enable, :start ]
end
