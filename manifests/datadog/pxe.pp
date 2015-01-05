# == Class: profiles::datadog::pxe
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
class profiles::datadog::pxe {

  include ::datadog_agent

}
