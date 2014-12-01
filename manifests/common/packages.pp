# == Class: profiles::common::packages
#
# This class ensures that the default/common packages
# that we want on every box are installed. These packages
# are agnostic to any particular service or application that
# should be running. Things like rsync, bc, wget, strace, etc.
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

class profiles::common::packages {
  # Hiera lookup to get a list of packages to install by default
  # These will all be things that won't hurt by being the latest
  $packages = hiera("${::operatingsystem}::${::operatingsystemmajrelease}::packages")

  package { $packages:
    ensure => latest,
  }
}
