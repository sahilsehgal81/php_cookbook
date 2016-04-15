#
# Cookbook Name:: php
# Recipe:: logrotate
#
# Copyright 2014, Kayako Support System Pvt. Ltd.
#
# All rights reserved - Do Not Redistribute
#

template '/etc/logrotate.d/php-fpm' do
  source 'php-fpm.erb'
  mode '644'
end
