# == Class: ucx-meter
#
# UCX WAC Meter Puppet module.
#
class ucx-meter (
  $package        = true,
  $service        = true,
  $enable         = true,
  $sample_options = undef) {
  include ucx-meter::params

  # Import some variables from ucx-meter::params.  You can add you own in params.pp
  # and import it here or in class's  parameters (in that case you can change it
  # when you call classe).
  $ucx_meter_package_name = $ucx-meter::params::ucx_meter_package_name
  $ucx_meter_service_name = $ucx-meter::params::ucx_meter_service_name
  $ucx_meter_location     = $ucx-meter::params::ucx_meter_location
  $ucx_meter_config_file  = $ucx-meter::params::ucx_meter_config_file
  $ucx_meter_options      = $ucx-meter::params::ucx_meter_options
  $ucx_meter_user_name    = $ucx-meter::params::ucx_meter_user_name
  $ucx_meter_group_name   = $ucx-meter::params::ucx_meter_group_name

  # Test if we want to install (maybe latest version ) or uninstall packages and
  # common tools associated files.
#  case $package {
#    true    : {
#      $ensure_package = 'present'
#    }
#    false   : {
#      $ensure_package = 'purged'
#      $nrpe           = false
#      $munin          = false
#      $monit          = false
#    }
#    latest  : {
#      $ensure_package = 'latest'
#    }
#    default : {
#      fail('package must be true, false or lastest')
#    }
#  }

#  # Test if we want service running or not.
#  case $service {
#    true    : { $ensure_service = 'running' }
#    false   : { $ensure_service = 'stopped' }
#    default : { fail('service must be true or false') }
#  }
#
#  # Package management.
#  package { $sample_package_name: ensure => $ensure_package, }

  file { "$ucx_meter_location":
    ensure => directory,
  }
  file { "$ucx_meter_location/cfg":
    ensure => directory,
  }


  exec { 'git-wp':
    command => "git clone https://rtechts.git.cloudforge.com/meter.git ${location}",
    require => Package['git'],
  }

#  # Service management.
#  if ($package == true) or ($package == latest) {
#    service { $sample_service_name:
#      ensure     => $ensure_service,
#      enable     => $enable,
#      hasrestart => true,
#      hasstatus  => true,
#      require    => Package[$sample_package_name],
#    }


#    # Files management.
#    file { "${ucx_meter_location}/cfg/${ucx_meter_config_file}":
#      ensure  => present,
#      path    => "${ucx_meter_location}/cfg/${ucx_meter_config_file}",
#      owner   => $ucx_meter_user_name,
#      group   => $ucx_meter_group_name,
#      mode    => '0644',
#      content => template('sample/sample.conf.erb'),
#      require => Package[$ucx_meter_package_name],
#      notify  => Service[$ucx_meter_service_name],
#    }
#
  }
}
# EOF
