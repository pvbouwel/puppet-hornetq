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
# - $confdir is the location of the configuration directory.  This directory
#   will hold the configuration specific to this instance. Default is 
#   ${basedir}/${instance_name}/conf
# - $datadir is the location of the data directory.  This data directory
#   will hold all the data subdirectories unless they where configured
#   to reside elsewhere. Default is ${basedir}/${instance_name}/data.
# - group is the OS group that owns the HornetQ instance (default=root).
# - jmsconfig is a hash that defines a jms-config.xml configuration
# - journaldir is the location of the "journal-directory". If the parameter is
#   not set it will default to ${datadir}/journal
# - largemessagesdir is the location of the "large-messages-directory. If the 
#   parameter is not set it will default to ${datadir}/large-messages
# - owner is the OS user that owns the HornetQ instance (default=root).
# - pagingdir is the location of the "paging-directory". If the parameter is
#   not set it will default to ${datadir}/paging
# - templates is a hash in which you can override the used templates currently
#   the following templates can be overwritten:
#      * jms_config.xml (jms-config.xml)
define hornetq::instance (
  $basedir          = $::hornetq::basedir,
  $bindingsdir      = undef,
  $confdir          = undef,
  $datadir          = undef,
  $ensure           = present,
  $jmsconfig        = {},
  $journaldir       = undef,
  $group            = root,
  $largemessagesdir = undef,
  $owner            = root,
  $pagingdir        = undef,
  $templates        = {},
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
  
  file { ["$_instancedir","$_confdir", "$_datadir", "$_pagingdir", "$_bindingsdir", "$_journaldir", "$_largemessagesdir"]:
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
  
  
}