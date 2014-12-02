# == Class: profiles::nova
#
# Profile class for setting up nova
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'profiles':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Scott Brimhall <sbrimhall@hortonworks.com>
#
# === Copyright
#
# Copyright 2014 Hortonworks, Inc.
#
class profiles::nova {

  # Hiera lookups
  $settings = hiera('nova::settings')
  
  # Setup rabbit user for nova
  rabbitmq_user { 'nova':
    ensure   => present,
    password => $settings[password],
    admin    => true,
  }

  rabbitmq_vhost { $settings[rabbit_vhost]:
    ensure => present,
  }

  class { '::nova':
    database_connection => "mysql://nova:$settings[password]@127.0.0.1/nova?charset=utf8",
    rabbit_userid       => $settings[rabbit_userid],
    rabbit_password     => $settings[password],
    rabbit_host         => $settings[rabbit_host],
    image_service       => $settings[image_service],
    glance_api_servers  => $settings[glance_api_servers],
    verbose             => $settings[verbose],
  }

}
