#
# Cookbook Name:: php
# Recipe:: phpunit
#
# Copyright 2014, Kayako Support System Pvt. Ltd.
#
# All rights reserved - Do Not Redistribute
#

remote_file '/usr/bin/phpunit'  do
  source 'https://phar.phpunit.de/phpunit.phar'
  mode '0755'
end
