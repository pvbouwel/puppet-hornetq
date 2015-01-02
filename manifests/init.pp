# Class: hornetq
#
# This module manages hornetq
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class hornetq (
  $basedir = '/opt',
  $install_from_source = false,
  $instances = hiera_hash('hornetq::instances', undef),
  $version   = "2.4.0"
) {
  include hornetq::install
  
  if $instances {
    create_resources('hornetq::instance', $instances)
  }
}
