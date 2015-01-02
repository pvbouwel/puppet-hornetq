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
  $install_from_source = false,
  $instances = hiera_hash('hornetq::instances', undef),
  $basedir = '/opt'
) {
  include hornetq::install
  
  if $instances {
    create_resources('hornetq::instance', $instances)
  }
}
