# == Class: sample::params
#
# This is a container class holding default parameters for sample module.
#
class ucx_meter::params {
  # Defaults values.
  $service = false
  $ucx_meter_service_name = 'ucx-meter-service'
  $ucx_meter_location   = '/var/ucx_meter'
  $ucx_meter_config_file  = 'config.info'
  $ucx_meter_user_name    = 'ubuntu'
  $ucx_meter_group_name   = 'ubuntu'
  $ucx_meter_infrastructure_id = 'none'
  $ucx_org_id             = ''
  # must input org id or authorization for api will not work
  $ucx_exchange_location = ''
  # must input 'UCX' or 'ICI' depending on exchange you are using
  $ucx_meter_infrastructure_name = ''
  # must change the infrastructure name before running automation
  $ucx_meter_source_location = 'https://github.com/ucxchange/ucxmeter.git'
}


