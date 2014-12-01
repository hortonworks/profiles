# == Class: profiles
#
# Class to install any dependencies to make anything crazy in profiles work
# Things like concat directories and whatnot that might be shared between
# profiles
#
# === Authors
#
# Scott Brimhall <sbrimhall@hortonworks.com>
#
# === Copyright
#
# Copyright 2014 Hortonworks, LLC
#
class profiles::install {

  $concat_dirs = ['/var/lib/puppet/concat', '/var/lib/puppet/concat/fragments']

  # Make sure concat directory exists so profiles can use the concat module
  file { $concat_dirs:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

}
