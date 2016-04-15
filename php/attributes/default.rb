default['php']['bin'] = '/usr/local/bin'
default['php']['force_compile'] = false

default['php']['version_php'] = '5.6.13'
default['php']['version_libmcrypt'] = '2.5.8'
default['php']['version_memcache'] = '2.1.0'
default['php']['version_libmemcached'] = '1.0.18'

default['php']['download_php_link'] = 'http://php.net/distributions'
default['php']['download_libmcrypt_link'] = 'https://vps.googlecode.com/files'
# Incase above provide goes off - http://softlayer-sng.dl.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz
default['php']['download_memcache_link'] = 'https://s3.amazonaws.com/kayakodev.chef'
default['php']['download_libmemcached_link'] = 'https://launchpad.net/libmemcached/1.0'

default['php']['cli_version'] = '/usr/local/phpcluster'
default['php']['fpm_conf_dir'] = '/usr/local/etc'
default['php']['www_version']  = '/etc/'

default['php']['user'] = 'root'
default['php']['group'] = 'root'
default['php']['intl_dir'] = '/opt/icu4c'
default['php']['is_intl'] = true
default['php']['is_twig'] = true
default['php']['is_opcache'] = true

default['php']['display_errors'] = 'Off'
default['php']['ini_memory_limit'] = '256M'
default['php']['ini_max_file_uploads'] = '20'
default['php']['default_socket_timeout'] = '600'

default['php']['init_script'] = '/etc/init.d'

default['php']['configure_options'] = %W(
  --with-libdir=lib64
  --with-config-file-path=/etc/
  --with-config-file-scan-dir=/usr/lib64/php/modules
  --with-pear
  --enable-cli
  --enable-intl
  --with-icu-dir=#{php['intl_dir']}
  --enable-bcmath
  --disable-cgi
  --enable-fpm
  --with-zlib
  --with-openssl
  --with-kerberos
  --with-bz2
  --with-curl
  --enable-ftp
  --enable-zip
  --enable-exif
  --with-gd
  --with-jpeg-dir=/usr/lib64
  --with-freetype-dir=/usr/lib64
  --enable-gd-native-ttf
  --with-gettext
  --with-gmp
  --with-mhash
  --with-iconv
  --with-imap
  --with-mysql
  --with-imap-ssl
  --enable-sockets
  --enable-soap
  --with-xmlrpc
  --with-mcrypt
  --enable-mbstring
  --with-t1lib
  --enable-embedded-mysqli
  --with-mysqli=mysqlnd
  --with-mysql-sock
  --with-sqlite3
  --with-pdo-mysql
  --with-pdo-mysql=mysqlnd
  --with-pdo-sqlite
  --enable-phar
  --with-ldap
  --enable-pcntl)

#######
default['php7']['bin'] = '/usr/local/phpcluster/php7/bin'
default['php7']['force_compile'] = false

default['php7']['version_php'] = '7.0.4'
default['php7']['version_libmcrypt'] = '2.5.8'
default['php7']['version_memcache'] = '2.1.0'
default['php7']['version_libmemcached'] = '1.0.18'

default['php7']['download_php_link'] = 'http://php.net/distributions'
default['php7']['download_libmcrypt_link'] = 'https://vps.googlecode.com/files'
# Incase above provide goes off - http://softlayer-sng.dl.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz
default['php7']['download_memcache_link'] = 'https://s3.amazonaws.com/kayakodev.chef'
default['php7']['download_libmemcached_link'] = 'https://launchpad.net/libmemcached/1.0'

default['php7']['cli_version'] = '/usr/local/phpcluster'
default['php7']['fpm_conf_dir'] = '/usr/local/etc'
default['php7']['www_version']  = '/etc/'

default['php7']['user'] = 'root'
default['php7']['group'] = 'root'
default['php7']['intl_dir'] = '/opt/icu4c'
default['php7']['is_intl'] = true
default['php7']['is_twig'] = false
default['php7']['is_opcache'] = true
default['php7']['is_debug'] = false
default['php7']['enable_phpfpm'] = false

default['php7']['display_errors'] = 'Off'
default['php7']['ini_memory_limit'] = '256M'
default['php7']['ini_max_file_uploads'] = '20'
default['php7']['default_socket_timeout'] = '600'

default['php7']['init_script'] = '/etc/init.d'

default['php7']['configure_options'] = %W(
  --disable-cgi
  --enable-bcmath
  --enable-cli
  --enable-embedded-mysqli
  --enable-exif
  --enable-fpm
  --enable-ftp
  --enable-gd-native-ttf
  --enable-intl
  --enable-mbstring
  --enable-opcache
  --enable-pcntl
  --enable-phar
  --enable-soap
  --enable-sockets
  --enable-zip
  --prefix=#{php['cli_version']}/php7
  --with-bz2
  --with-config-file-path=/etc/
  --with-config-file-scan-dir=/usr/lib64/php/modules
  --with-curl
  --with-freetype-dir=/usr/lib64
  --with-freetype-dir=/usr/local/include/freetype2
  --with-gd
  --with-gettext
  --with-gmp
  --with-iconv
  --with-intl
  --with-icu-dir=#{php['intl_dir']}
  --with-imap
  --with-imap-ssl
  --with-jpeg-dir
  --with-jpeg-dir=/usr/lib64
  --with-kerberos
  --with-ldap
  --with-libdir=lib64
  --with-mcrypt
  --with-mhash
  --with-mysql-sock
  --with-mysqli=mysqlnd
  --with-openssl
  --with-pdo-mysql
  --with-pdo-mysql=mysqlnd
  --with-pdo-sqlite
  --with-pear
  --with-sqlite3
  --with-tidy
  --with-xmlrpc
  --with-zlib)
