# == Class: profiles::redis
#
# Profile class for standalone redis server setup
#
# === Authors
#
# Scott Brimhall <sbrimhall@hortonworks.com>
#
# === Copyright
#
# Copyright 2015 Hortonworks, Inc.
#
class profiles::redis {

  include ::redis

}
