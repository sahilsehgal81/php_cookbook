#
# Cookbook Name:: php
# Recipe:: php7
#
# Copyright 2014, Kayako Support System Pvt. Ltd.
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'php::packages'

remote_file "#{Chef::Config[:file_cache_path]}/php-#{node['php7']['version_php']}.tar.gz"  do
  source "#{node['php7']['download_php_link']}/php-#{node['php7']['version_php']}.tar.gz"
  mode '0644'
  checksum 'f6cdac2fd37da0ac0bbcee0187d74b3719c2f83973dfe883d5cde81c356fe0a8'
end

# Compile and install PHP

if File.exist?('/usr/local/phpcluster/php7/bin/php') == false
  node.override['php7']['force_compile'] = true
end

Chef::Log.warn("PHP will be force compiled? : #{node['php7']['force_compile']}")

configure_options = node['php7']['configure_options'].join(' ')
configure_options += ' --enable-debug ' if node['php7']['is_debug'] == true
Chef::Log.info(configure_options)

remote_file "#{Chef::Config[:file_cache_path]}/icu.tgz"  do
  source 'http://downloads.sourceforge.net/project/icu/ICU4C/55.1/icu4c-55_1-src.tgz'
  mode '0644'
  not_if { ::File.exist?("#{Chef::Config[:file_cache_path]}/icu.tgz") }
end

bash 'install icu from source' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
            tar xzf icu.tgz
            mkdir -p #{node['php7']['intl_dir']}
            cd icu/source
            ./configure --prefix=#{node['php7']['intl_dir']} && make && make install
        EOF
  only_if { (node['php7']['force_compile'] == true) && (node['php7']['is_intl'] == true) }
end

bash 'build and install php7' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
    set -e
    tar -zxf php-#{node['php7']['version_php']}.tar.gz
    (cd php-#{node['php7']['version_php']} && ./configure #{configure_options})
    (cd php-#{node['php7']['version_php']} && make clean && make && make install)
    EOF
  only_if { node['php7']['force_compile'] == true }
end

if node['php7']['enable_phpfpm'] == true
  %w(php php-config phpize pecl pear).each do |pkg|
    link '/usr/bin/' + pkg do
      to '/usr/local/phpcluster/php7/bin/' + pkg
    end
  end
  template "#{node['php']['init_script']}/php-fpm" do
    source 'php7-fpm.init.erb'
    owner node['php']['user']
    group node['php']['group']
    mode '0755'
    notifies :reload, 'service[php-fpm]', :delayed
  end
  # Creating php.ini
  template "#{node['php7']['www_version']}php.ini" do
    source 'php7.ini.erb'
    owner node['php7']['user']
    group node['php7']['group']
    mode '0644'
    notifies :reload, 'service[php-fpm]', :delayed
  end
end

template '/etc/php7.cli.ini' do
  source 'php7.cli.ini.erb'
  owner node['php']['user']
  group node['php']['group']
  mode '0644'
end
