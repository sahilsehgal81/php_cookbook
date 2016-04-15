require 'serverspec'

set :backend, :exec

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin:/usr/bin:/bin'
  end
end

packages = [
  'wget',
  'bzip2-devel',
  'openldap-devel',
  'gd-devel',
  'gmp-devel',
  'libmcrypt',
  'libmcrypt-devel',
  'libc-client-devel',
  'openssl',
  're2c',
  'libxml2-devel',
  'libXpm-devel',
  'gmp-devel',
  'libicu-devel',
  't1lib-devel',
  'aspell-devel',
  'openssl-devel',
  'bzip2-devel',
  'libjpeg-devel',
  'libvpx-devel',
  'libpng-devel',
  'freetype-devel',
  'readline-devel',
  'libtidy-devel',
  'libxslt-devel']

packages.each do|p|
  describe package(p) do
    it { should be_installed }
  end
end

describe service('php-fpm') do
  it { should be_enabled   }
  it { should be_running   }
end

describe file('/etc/php.ini') do
  it { should be_file }
end

describe file('/etc/php.cli.ini') do
  it { should be_file }
end

describe file('/usr/local/lib/php/extensions/no-debug-non-zts-20131226/memcached.so') do
  it { should be_file }
end

describe file('/usr/local/lib/php/extensions/no-debug-non-zts-20131226/opcache.so') do
  it { should be_file }
end

describe file('/usr/local/lib/php/extensions/no-debug-non-zts-20131226/phpiredis.so') do
  it { should be_file }
end

describe file('/usr/local/lib/php/extensions/no-debug-non-zts-20131226/twig.so') do
  it { should be_file }
end

describe file('/usr/local/lib/php/extensions/no-debug-non-zts-20131226/intl.so') do
  it { should_not be_file }
end

describe file('/etc/php.ini') do
  its(:content) { should match /always_populate_raw_post_data = -1/ }
end
