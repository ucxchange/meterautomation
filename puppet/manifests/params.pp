# == Class: sample::params
#
# This is a container class holding default parameters for sample module.
#
class ucx-meter::params {
  # Defaults values.
  $package = true
  $service = true
  $enable  = true

  $ucx_meter_package_name = 'ucx-meter'
  $ucx_meter_service_name = 'ucx-meter'
  $ucx_meter_location   = '/etc/ucx-meter'
  $ucx_meter_config_file  = 'config.info'
  $ucx_meter_options      = '-i infrastructure_sample_name'
  $ucx_meter_user_name    = 'root'
  $ucx_meter_group_name   = 'root'

}
# EOF
