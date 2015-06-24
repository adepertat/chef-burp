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
client_query = "role:#{node[:burp][:role][:client]}"
results = search(:node, "#{client_query} AND chef_environment:#{node.chef_environment}")
passwords = results.map { |n|
	[ 
		n[:fqdn],
		n[:burp].fetch(:client, {}).fetch(:password, ''),
		n[:burp].fetch(:clientconf, {:include => [], :timer => []}) 
	]
}

passwords.each do |fqdn, password, clientconf|
	template "#{node[:burp][:server][:config_dir]}/clientconfdir/#{fqdn}" do
		source 'clientconf.erb'
		variables({
			:password => password,
			:include => node[:burp][:default][:clientconf].fetch(:include, []) + clientconf.fetch(:include, []),
			:timer => node[:burp][:default][:clientconf].fetch(:timer, []) + clientconf.fetch(:timer, [])
		})
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
