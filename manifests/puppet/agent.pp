# == Class: profiles::puppet::agent
#
# Profile class for configuring the Puppet agent
#
# === Parameters
#
# This is a profile class and is therefore parameter-less. Gets included.
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
# Copyright 2014 Hortonworks, LLC
#
class profiles::puppet::agent {

  # Hiera lookups
  # Grab a hash of defaults to apply to the agent
  $defaults = hiera(puppet::agent::defaults)

  class { '::puppet':
    version                     => $defaults[version],
    server                      => false,
    server_git_repo             => $defaults[server_git_repo],
    runmode                     => $defaults[runmode],
    pluginsync                  => $defaults[pluginsync],
    show_diff                   => $defaults[show_diff],
    server_reports              => $defaults[server_reports],
    server_storeconfigs_backend => $defaults[server_storeconfigs_backend],
    server_facts                => $defaults[server_facts],
    server_ca                   => false,
    puppetmaster                => $defaults[puppetmaster],
    ca_server                   => $defaults[ca_server],
  }

}
