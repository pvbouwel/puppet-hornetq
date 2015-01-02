define hornetq::jms_config (
  $location             = undef,
  $connection_factories = {},
  $queues               = {},
  $templates            = undef,
  $topics               = {}
) {
  if ! $templates['jms_config.xml'] {
    $servicescript_content = template('hornetq/hornetq-jms.xml.erb')
  } else {
    $servicescript_content = template($templates['jms_config.xml'])
  }
}