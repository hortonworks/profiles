# == Class: profiles::openstack::horizon
#
# Profile class for setting up Horizon 
#
# === Authors
#
# Scott Brimhall <sbrimhall@hortonworks.com>
#
# === Copyright
#
# Copyright 2014 Hortonworks, Inc.
#
class profiles::openstack::horizon {

  # Hiera lookups
  $settings         = hiera('horizon::settings')
  $password         = $settings[password]

  # Setup memcache
  class { '::memcached':
    listen_ip => '127.0.0.1',
    tcp_port  => '11211',
    udp_port  => '11211',
  }

  # Setup Horizon
  class { '::horizon':
    cache_server_ip => '127.0.0.1',
    cache_server_port => '11211',
    secret_key        => $password,
    swift             => false,
    django_debug      => false,
    api_result_limit  => '2000',
  }

}
