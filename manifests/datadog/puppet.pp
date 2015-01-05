# == Class: profiles::datadog::puppet
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
class profiles::datadog::puppet {

  # Hiera lookup
  $api_key = hiera('datadog::api_key')

  # Make sure concat directory exists
  include ::profiles::install

  # Install dogapi gem to enable support for Puppet reporting
  package { 'dogapi':
    provider => 'gem',
    ensure   => 'latest',
  }

  class { 'datadog_agent':
    api_key            => $api_key,
    puppet_run_reports => true,
  }

}
