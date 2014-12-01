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

class profiles::common::users::install {
  # Hiera lookups to grab users and groups to apply to boxes by default
  $users     = hiera('users')
  $groups    = hiera('groups')
  $keys      = hiera('ssh_keys')
  $root_user = hiera('users::root')

  # Create resources for users, groups, and ssh keys
  create_resources(user, $users)
  create_resources(user, $root_user)
  create_resources(group, $groups)
  create_resources(ssh_authorized_key, $keys)
}
