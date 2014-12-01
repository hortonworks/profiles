# == Class: profiles::rabbitmq::server
#
# Profile class for rabbitmq server setup
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
# Copyright 2014 Hortonworks, LLC
#
class profiles::rabbitmq::server {

  # Hiera lookups to grab rabbitmq defaults
  $defaults = hiera(rabbitmq::defaults)

  class { '::rabbitmq':
    stomp_ensure          => $defaults[stomp_ensure],
    default_user          => $defaults[default_user],
    delete_guest_user     => $defaults[delete_guest_user],
    node_ip_address       => $defaults[node_ip_address],
    service_manage        => $defaults[service_manage],
    port                  => $defaults[port],
    environment_variables => {
      'RABBITMQ_NODENAME'    => $defaults[RABBITMQ_NODENAME],
      'RABBITMQ_SERVICENAME' => $defaults[RABBITMQ_SERVICENAME]
    },
    ssl                   => $defaults[ssl],
    ssl_cacert            => $defaults[ssl_cacert],
    ssl_cert              => $defaults[ssl_cert],
    ssl_key               => $defaults[ssl_key]
  }

}
