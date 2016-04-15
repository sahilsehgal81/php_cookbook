#
# Cookbook Name:: php
# Recipe:: default
#
# Copyright 2014, Kayako Support System Pvt. Ltd.
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'php::packages'

if File.exist?('/usr/local/bin/php') == false
  node.override['php']['force_compile'] = true
end

Chef::Log.warn("PHP will be force compiled? : #{node['php']['force_compile']}")

# Create cli version directory
directory "#{node['php']['cli_version']}/etc" do
  owner node['php']['user']
  group node['php']['group']
  mode '0755'
  recursive true
end

bash 'remove pre-ext directories' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
    set -e
    rm -rf #{Chef::Config[:file_cache_path]}/libmemcached*
    rm -rf #{Chef::Config[:file_cache_path]}/memcached*
    rm -rf #{Chef::Config[:file_cache_path]}/Twig
    EOF
  only_if { node['php']['force_compile'] == true }
end

# Download all required packages to install
remote_file "#{Chef::Config[:file_cache_path]}/php-#{node['php']['version_php']}.tar.gz"  do
  source "#{node['php']['download_php_link']}/php-#{node['php']['version_php']}.tar.gz"
  mode '0644'
end

remote_file "#{Chef::Config[:file_cache_path]}/libmcrypt-#{node['php']['version_libmcrypt']}.tar.gz"  do
  source "#{node['php']['download_libmcrypt_link']}/libmcrypt-#{node['php']['version_libmcrypt']}.tar.gz"
  mode '0644'
end

remote_file "#{Chef::Config[:file_cache_path]}/memcached-#{node['php']['version_memcache']}.tgz"  do
  source "#{node['php']['download_memcache_link']}/memcached-#{node['php']['version_memcache']}.tgz"
  mode '0644'
end

remote_file "#{Chef::Config[:file_cache_path]}/libmemcached-#{node['php']['version_libmemcached']}.tar.gz" do
  source "#{node['php']['download_libmemcached_link']}/#{node['php']['version_libmemcached']}/+download/libmemcached-#{node['php']['version_libmemcached']}.tar.gz"
  mode '0644'
  not_if { ::File.exist?("#{Chef::Config[:file_cache_path]}/libmemcached-#{node['php']['version_libmemcached']}.tar.gz") }
end

# Creating php.cli.ini
template "#{node['php']['cli_version']}/etc/php.cli.ini" do
  source 'php.cli.ini.erb'
  owner node['php']['user']
  group node['php']['group']
  mode '0644'
end

# Creating php.custom.ini
template '/etc/php.custom.ini' do
  source 'php.custom.ini.erb'
  owner node['php']['user']
  group node['php']['group']
  mode '0644'
end

# Creating php.ini
if node['php7']['enable_phpfpm'] == false
  template "#{node['php']['www_version']}php.ini" do
    source 'php.ini.erb'
    owner node['php']['user']
    group node['php']['group']
    mode '0644'
    notifies :reload, 'service[php-fpm]', :delayed
  end
end

remote_file "#{Chef::Config[:file_cache_path]}/icu.tgz"  do
  source 'http://downloads.sourceforge.net/project/icu/ICU4C/55.1/icu4c-55_1-src.tgz'
  mode '0644'
  not_if { ::File.exist?("#{Chef::Config[:file_cache_path]}/icu.tgz") }
end

bash 'install icu from source' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
            tar xzf icu.tgz
            mkdir -p #{node['php']['intl_dir']}
            cd icu/source
            ./configure --prefix=#{node['php']['intl_dir']} && make && make install
        EOF
  only_if { (node['php']['force_compile'] == true) && (node['php']['is_intl'] == true) }
end

# Compile and install PHP
configure_options = node['php']['configure_options'].join(' ')
Chef::Log.info(configure_options)

bash 'build and install php' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
    set -e
    tar -zxf php-#{node['php']['version_php']}.tar.gz
    (cd php-#{node['php']['version_php']} && ./configure #{configure_options})
    (cd php-#{node['php']['version_php']} && make clean && make && make install)
    rm -f /usr/bin/php
    ln -sf /usr/local/bin/php /usr/bin/php
    mkdir -p #{node['php']['cli_version']}/bin
    ln -sf /usr/local/bin/php #{node['php']['cli_version']}/bin/php
    rm -rf php-#{node['php']['version_php']}
    EOF
  only_if { node['php']['force_compile'] == true }
end

# http://php.net/manual/en/mcrypt.installation.php
bash 'install libmcrypt' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
    set -e
    tar -zxf "libmcrypt-#{node['php']['version_libmcrypt']}.tar.gz"
    cd "libmcrypt-#{node['php']['version_libmcrypt']}"
    ./configure  --disable-posix-threads
    make && make install
    EOF
  only_if { node['php']['force_compile'] == true }
end

bash 'install libmemcached' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
    set -e
    tar -zxf libmemcached-#{node['php']['version_libmemcached']}.tar.gz
    cd libmemcached-#{node['php']['version_libmemcached']}
    (hash gcc44 2>/dev/null && hash g++44 2>/dev/null && export CC="gcc44" && export CXX="g++44" && ./configure --prefix=/usr/local && make && make install 2>&1) || (./configure --prefix=/usr/local && make && make install 2>&1)
    EOF
  only_if { node['php']['force_compile'] == true }
end

bash 'install memcached' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
    set -e
    tar -zxf memcached-#{node['php']['version_memcache']}.tgz
    cd memcached-#{node['php']['version_memcache']}
    #{node['php']['bin']}/phpize && ./configure --prefix=/usr/local --with-php-config=/usr/local/bin/php-config && make && make install
    EOF
  only_if { node['php']['force_compile'] == true }
end

git "#{Chef::Config[:file_cache_path]}/Twig" do
  repository 'https://github.com/twigphp/Twig.git'
  reference '1.x'
  action :checkout
  notifies :run, 'execute[install twig]', :immediately
end

execute 'install twig' do
  cwd Chef::Config[:file_cache_path]
  command <<-EOF
    set -e
    # rm -rf Twig
    # git clone https://github.com/twigphp/Twig.git
    cd Twig/
    git checkout 4cf7464 # <- 1.18.0 Get stable version and commit id from https://packagist.org/packages/twig/twig
    cd ext/twig
    #{node['php']['bin']}/phpize && ./configure --prefix=/usr/local --with-php-config=/usr/local/bin/php-config && make && make install
    EOF
  action :nothing
end

bash 'remove intl' do
  code <<-EOF
      set -e
      #{node['php']['bin']}/pecl uninstall intl
    EOF
  only_if { (node['php']['force_compile'] == true) && (node['php']['is_intl'] == true) }
end

git "#{Chef::Config[:file_cache_path]}/hiredis" do
  repository 'https://github.com/redis/hiredis'
  action :checkout
  notifies :run, 'execute[install hiredis]', :immediately
end

execute 'install hiredis' do
  cwd "#{Chef::Config[:file_cache_path]}/hiredis"
  command <<-EOF
      set -e
      make && make install
    EOF
  action :nothing
end

git "#{Chef::Config[:file_cache_path]}/phpiredis" do
  repository 'https://github.com/nrk/phpiredis.git'
  action :checkout
  notifies :run, 'execute[install phpiredis]', :immediately
end

execute 'install phpiredis' do
  cwd "#{Chef::Config[:file_cache_path]}/phpiredis"
  command <<-EOF
      set -e
      EXTRA_LDFLAGS=/usr/local/lib #{node['php']['bin']}/phpize && ./configure --enable-phpiredis --prefix=/usr/local --with-php-config=/usr/local/bin/php-config
      make && make install
    EOF
  action :nothing
end

file '/etc/php.cli.ini' do
  action :delete
  not_if { File.symlink?('/etc/php.cli.ini') }
end

link '/etc/php.cli.ini' do
  to "#{node['php']['cli_version']}/etc/php.cli.ini"
end

# Installing PHP-FPM

php_fpm_conf_file = PHP.get_php_fpm_config('php-fpm', 'conf', node['memory']['total'][0..-3].to_f / 1_024_000)

template "#{node['php']['fpm_conf_dir']}/php-fpm.conf" do
  source php_fpm_conf_file
  owner node['php']['user']
  group node['php']['group']
  mode '0644'
  notifies :reload, 'service[php-fpm]', :delayed
end

if node['php7']['enable_phpfpm'] == false
  template "#{node['php']['init_script']}/php-fpm" do
    source 'php-fpm.init.erb'
    owner node['php']['user']
    group node['php']['group']
    mode '0755'
    notifies :reload, 'service[php-fpm]', :delayed
  end
  %w(php php-config phpize pecl pear).each do |pkg|
    link '/usr/bin/' + pkg do
      to '/usr/local/bin/' + pkg
    end
  end

end

include_recipe 'php::logrotate'

service 'php-fpm' do
  action [:start, :enable]
end
