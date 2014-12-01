# == Class: profiles::common::users
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

class profiles::common::users {

  include ::profiles::common::users::shells
  include ::profiles::common::users::install

  Class['::profiles::common::users::shells'] -> Class['::profiles::common::users::install']
}
