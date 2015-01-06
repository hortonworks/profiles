# == Class: profiles::datadog::agent
#
# Profile class to setup the Datadog agent
#
# === Authors
#
# Scott Brimhall <sbrimhall@hortonworks.com>
#
# === Copyright
#
# Copyright 2014 Hortonworks, Inc unless otherwise noted.
#
class profiles::datadog::agent {

  # Hiera lookups
  $api_key = hiera('datadog::api_key')

  class { 'datadog_agent':
    api_key => $api_key,
  }

}
