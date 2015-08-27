# == Class: ucx-meter
#
# UCX WAC Meter Puppet module.
#
class ucx-meter (
  $package        = true,
  $service        = true,
  $enable         = true,
  $sample_options = undef) {
  # Include default parameters for sample module.
  include ucx-meter::params

  # Import some variables from sample::params.  You can add you own in params.pp
  # and import it here or in class's  parameters (in that case you can change it
  # when you call classe).
  $sample_package_name = $ucx-meter::params::sample_package_name
  $sample_service_name = $ucx-meter::params::sample_service_name
  $sample_user_name    = $ucx-meter::params::sample_user_name
  $sample_group_name   = $ucx-meter::params::sample_group_name
  $sample_config_dir   = $ucx-meter::params::sample_config_dir
  $sample_config_file  = $ucx-meter::params::sample_config_file
  $sample_sysconfig    = $ucx-meter::params::sample_sysconfig
  $sample_logrotate    = $ucx-meter::params::sample_logrotate

  # Test if we want to install (maybe latest version ) or uninstall packages and
  # common tools associated files.
  case $package {
    true    : {
      $ensure_package = 'present'
    }
    false   : {
      $ensure_package = 'purged'
      $nrpe           = false
      $munin          = false
      $monit          = false
    }
    latest  : {
      $ensure_package = 'latest'
    }
    default : {
      fail('package must be true, false or lastest')
    }
  }

  # Test if we want service running or not.
  case $service {
    true    : { $ensure_service = 'running' }
    false   : { $ensure_service = 'stopped' }
    default : { fail('service must be true or false') }
  }

  # Package management.
  package { $sample_package_name: ensure => $ensure_package, }

  # Service management.
  if ($package == true) or ($package == latest) {
    service { $sample_service_name:
      ensure     => $ensure_service,
      enable     => $enable,
      hasrestart => true,
      hasstatus  => true,
      require    => Package[$sample_package_name],
    }

    # Files management.
    file { "${sample_config_dir}/${sample_config_file}":
      ensure  => present,
      path    => "${sample_config_dir}/${sample_config_file}",
      owner   => $sample_user_name,
      group   => $sample_group_name,
      mode    => '0644',
      content => template('sample/sample.conf.erb'),
      require => Package[$sample_package_name],
      notify  => Service[$sample_service_name],
    }

    file { $sample_sysconfig:
      ensure  => present,
      path    => $sample_sysconfig,
      owner   => $sample_user_name,
      group   => $sample_group_name,
      mode    => '0644',
      content => template("sample/sysconfig.${::operatingsystem}.erb"),
      require => Package[$sample_package_name],
      notify  => Service[$sample_service_name],
    }
  }
}
# EOF
