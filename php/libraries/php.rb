#
# Cookbook Name:: php
# Library:: php
#
# Copyright 2014, Kayako Support System Pvt. Ltd.
#
# All rights reserved - Do Not Redistribute
#

class Chef::Recipe::PHP
  def self.get_php_fpm_config(name, type, ram_gb)
    suffix = type + '.erb'
    if ram_gb > 36
      return name + '-extralarge.' + suffix
    elsif ram_gb > 20
      return name + '-large.' + suffix
    elsif ram_gb > 8
      return name + '-medium.' + suffix
    else
      return name + '-small.' + suffix
    end
  end
end
