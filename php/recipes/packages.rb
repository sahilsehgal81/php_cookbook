#
# Cookbook Name:: php
# Recipe:: packages
#
# Copyright 2014, Kayako Support System Pvt. Ltd.
#
# All rights reserved - Do Not Redistribute
#

%w(git
   wget
   bzip2-devel
   openldap-devel
   gd-devel
   gmp-devel
   libmcrypt
   libmcrypt-devel
   libc-client-devel
   openssl
   re2c
   libxml2-devel
   libXpm-devel
   gmp-devel
   libicu-devel
   t1lib-devel
   aspell-devel
   openssl-devel
   bzip2-devel
   libjpeg-devel
   libvpx-devel
   libpng-devel
   freetype-devel
   readline-devel
   libtidy-devel
   libxslt-devel).each do |pkg|
  package pkg do
    action :install
  end
end

if node['platform_version'] == '5.10'
  %w(curl-devel).each do |pkg|
    package pkg do
      action :install
    end
  end
else
  %w(libcurl-devel).each do |pkg|
    package pkg do
      action :install
    end
  end
end
