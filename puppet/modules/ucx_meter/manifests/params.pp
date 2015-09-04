# == Class: sample::params
#
# This is a container class holding default parameters for sample module.
#
class ucx_meter::params {
  # Defaults values.
  $package = true
  $service = true
  $enable  = true

  $ucx_meter_package_name = 'ucx_meter'
  $ucx_meter_service_name = 'ucx_meter_service'
  $ucx_meter_location   = '/Users/Andy/ucx_meter'
  $ucx_meter_config_file  = 'config.info'
  $ucx_meter_user_name    = 'root'
  $ucx_meter_group_name   = 'root'
  $ucx_meter_infrastructure_name = 'new infra puppet 01'
}
# EOF