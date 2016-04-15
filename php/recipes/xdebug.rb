#
# Cookbook Name:: php
# Recipe:: xdebug
#
# Copyright 2014, Kayako Support System Pvt. Ltd.
#
# All rights reserved - Do Not Redistribute
#

# bash 'install xdebug' do
# code 'pecl install xdebug'
# end

directory '/usr/lib64/php/modules' do
  owner 'nobody'
  group 'nobody'
  mode '0777'
  action :create
  recursive true
end

template '/usr/lib64/php/modules/xdebug.ini' do
  source 'xdebug.ini.erb'
  owner node['php']['user']
  group node['php']['group']
  mode '0644'
end
