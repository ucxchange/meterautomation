# == Class: sample::params
#
# This is a container class holding default parameters for sample module.
#
class ucx-meter::params {
  # Defaults values.
  $package = true
  $service = true
  $enable  = true

  $sample_package_name = 'sample'
  $sample_service_name = 'sample'
  $sample_user_name    = 'root'
  $sample_group_name   = 'root'
  $sample_config_dir   = '/etc/sample'
  $sample_config_file  = 'sample.conf'
  $sample_sysconfig    = '/etc/sysconfig/sample'
  $sample_logrotate    = '/etc/logrotate.d/sample'
  $sample_options      = '-o sample'
}
# EOF
