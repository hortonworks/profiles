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

  include ::datadog_agent
  include ::datadog_agent::integrations::system

}
