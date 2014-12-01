# == Class: profiles::common::users::shells
#
# Full description of class profiles here.
#
# === Parameters
#
# This is a profile class and has no parameters
#
# === Variables
#
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

class profiles::common::users::shells {
  # Hiera lookups to grab users and groups to apply to boxes by default
  $shells = hiera('shells')

  package { $shells:
    ensure => latest,
  }
}
