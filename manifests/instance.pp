# Definition: hornetq::instance
#
# This define installs an instance of HornetQ.
#
# Parameters:
# - $basedir is the root of the HornetQ installation. This parameter will
#   not affect the HornetQ executable.  It will only impact configuration
#   and data that is instance-specific.
# - $bindingsdir is the location of the "bindings-directory". If the parameter 
#   is not set it will default to ${datadir}/bindings
# - bindir is the directory with the executables
# - $confdir is the location of the configuration directory.  This directory
#   will hold the configuration specific to this instance. Default is 
#   ${basedir}/${instance_name}/conf
# - $connectors contains the connectors defined for the HornetQ. Connectors is
#   a hash map where the key is the connector name and the value is a new hash
#   map with at least the 'factory-class' key and if necessary other key-value
#   pairs to define configuration.
# - $datadir is the location of the data directory.  This data directory
#   will hold all the data subdirectories unless they where configured
#   to reside elsewhere. Default is ${basedir}/${instance_name}/data.
# - group is the OS group that owns the HornetQ instance (default=root).
# - jmsconfig is a hash that defines a jms-config.xml configuration
# - journaldir is the location of the "journal-directory". If the parameter is
#   not set it will default to ${datadir}/journal
# - largemessagesdir is the location of the "large-messages-directory. If the 
#   parameter is not set it will default to ${datadir}/large-messages
# - logdir is the directory to which logs will be written.
# - logdir is the filename to which logs will be written.
# - owner is the OS user that owns the HornetQ instance (default=root).
# - pagingdir is the location of the "paging-directory". If the parameter is
#   not set it will default to ${datadir}/paging
# - templates is a hash in which you can override the used templates currently
#   the following templates can be overwritten:
#      * jms_config.xml (jms-config.xml)
define hornetq::instance (
  $basedir          = $::hornetq::basedir,
  $bindingsdir      = undef,
  $bindir           = undef,
  $confdir          = undef,
  $connectors       = undef,
  $datadir          = undef,
  $ensure           = present,
  $group            = root,
  $jmsconfig        = {},
  $journaldir       = undef,
  $logdir           = undef,
  $logfile          = undef,
  $largemessagesdir = undef,
  $owner            = root,
  $pagingdir        = undef,
  $templates        = {},
  $version          = $::hornetq::version,
) {
  
  $instancename        = $title
  
  if $instancename == "NONAME" {
    $_instancedir = "${basedir}"
  } else {
    $_instancedir = "${basedir}/${instancename}"
  }
  
  if $confdir {
    $_confdir = $confdir
  }else {
    $_confdir = "${_instancedir}/conf"
  }
  
  if $datadir {
    $_datadir = $datadir
  }else {
    $_datadir = "${_instancedir}/data"
  }
  
  if $logdir {
    $_logdir = $logdir
  }else {
    $_logdir = "${_instancedir}/logs"
  }
  
  if $logfile {
    $_logfile = $logfile
  }else {
    $_logfile = "hornetq.log"
  }
  
  if $bindir {
    $_bindir = $bindir
  }else {
    $_bindir = "${_instancedir}/bin"
  }
  
  if $pagingdir {
    $_pagingdir = $pagingdir
  }else {
    $_pagingdir = "${_datadir}/paging"
  }
  
  if $bindingsdir {
    $_bindingsdir = $bindingsdir
  }else {
    $_bindingsdir = "${_datadir}/bindings"
  }
  
  if $journaldir {
    $_journaldir = $journaldir
  }else {
    $_journaldir = "${_datadir}/journal"
  }
  
  if $largemessagesdir {
    $_largemessagesdir = $largemessagesdir
  }else {
    $_largemessagesdir = "${_datadir}/large-messages"
  }
  
  
  
  file { ["$_instancedir","$_confdir", "$_datadir", "$_pagingdir", "$_bindingsdir", "$_journaldir", "$_largemessagesdir", "$_bindir", "$_logdir"]:
     ensure => directory,
     owner => $owner,
     group => $group
  }
  
  if $jmsconfig != {} {
    if has_key($jmsconfig, 'connection_factories') {
      $connection_factories = $jmsconfig['connection_factories']  
    }
    if has_key($jmsconfig, 'queues') {
      $queues = $jmsconfig['queues']  
    }
    if has_key($jmsconfig, 'topics') {
      $topics = $jmsconfig['topics']  
    }
    
    if ! has_key($templates, 'jms_config.xml') {
      $hornetq_jms_xml_content = template('hornetq/hornetq-jms.xml.erb')
    } else {
      $hornetq_jms_xml_content = template($templates['jms_config.xml'])
    }
    
    file { "${_confdir}/hornetq-jms.xml":
      ensure => present,
      owner => $owner,
      group => $group,
      content => "$hornetq_jms_xml_content"
    }
  }
  
  if ! has_key($templates, 'hornetq-configuration.xml') {
    $hornetq_configuration_xml_content = template('hornetq/hornetq-configuration.xml.erb')
  } else {
    $hornetq_configuration_xml_content = template($templates['hornetq-configuration.xml'])
  }

  file { "${_confdir}/hornetq-configuration.xml":
    ensure => present,
    owner => $owner,
    group => $group,
    content => "$hornetq_configuration_xml_content"
  }
  
  if ! has_key($templates, 'logging.properties') {
    $hornetq_logging_properties_content = template('hornetq/logging.properties.erb')
  } else {
    $hornetq_logging_properties_content = template($templates['logging.properties'])
  }
  
  file { "${_confdir}/logging.properties":
    ensure => present,
    owner => $owner,
    group => $group,
    content => "$hornetq_logging_properties_content"
  }
  
  if ! has_key($templates, 'hornetq-beans.xml') {
    $hornetq_beans_xml_content = template('hornetq/hornetq-beans.xml.erb')
  } else {
    $hornetq_beans_xml_content = template($templates['hornetq-beans.xml'])
  }
  
  file { "${_confdir}/hornetq-beans.xml":
    ensure => present,
    owner => $owner,
    group => $group,
    content => "$hornetq_beans_xml_content"
  }
  
  if ! has_key($templates, 'run.sh') {
    $hornetq_run_scrip_content = template('hornetq/run.sh.erb')
  } else {
    $hornetq_run_scrip_content = template($templates['run.sh'])
  }
  
  file { "${_bindir}/run.sh":
    ensure => present,
    owner => $owner,
    group => $group,
    content => "$hornetq_run_scrip_content",
    mode  => 'u+rx'
  }
  
  if ! has_key($templates, 'stop.sh') {
    $hornetq_stop_scrip_content = template('hornetq/stop.sh.erb')
  } else {
    $hornetq_stop_scrip_content = template($templates['stop.sh'])
  }
  
  file { "${_bindir}/stop.sh":
    ensure => present,
    owner => $owner,
    group => $group,
    content => "$hornetq_stop_scrip_content",
    mode  => 'u+rx'
  }
  
  if ! has_key($templates, 'jndi.properties') {
    $hornetq_jndi_properties_content = template('hornetq/jndi.properties.erb')
  } else {
    $hornetq_jndi_properties_content = template($templates['jndi.properties'])
  }
  
  file { "${_confdir}/jndi.properties":
    ensure => present,
    owner => $owner,
    group => $group,
    content => "$hornetq_jndi_properties_content",
    mode  => 'u+r'
  }
  
  if ! has_key($templates, 'hornetq-service-script.sh') {
    $hornetq_service_script_content = template('hornetq/hornetq-service-script.sh.erb')
  } else {
    $hornetq_service_script_content = template($templates['hornetq-service-script.sh'])
  }
  
  file { "/etc/init.d/hornet_${instancename}.sh":
    ensure => present,
    content => "$hornetq_service_script_content",
    mode  => 'u+rx'
  }
}