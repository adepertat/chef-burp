#
# Cookbook Name:: burp
# Recipe:: ui
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

python_pip 'burp-ui'

service 'burpui' do
	action :nothing
end

template '/etc/burp/burpui.cfg' do
	source 'burpui.cfg.erb'
	variables node[:burp][:server]
	notifies :restart, 'service[burpui]'
end

template '/etc/init/burpui.conf' do
	source 'burpui.conf.erb'
	notifies :restart, 'service[burpui]'
end

