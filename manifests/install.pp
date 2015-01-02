class hornetq::install (
  $install_from_source = $::hornetq::install_from_source,
  $package_name = "hornetq",
  $release   = "1",
  $version   = $::hornetq::version,
) {
  if $install_from_source {
    validate_bool($install_from_source)
  }
  
  if ! $install_from_source {
    if $version == latest or $version == absent {
      $package_ensure = $version  
    } else {
      $package_ensure = "${version}-${release}"
    }
    
    package { $package_name:
      ensure => $package_ensure,
    }
  }
}