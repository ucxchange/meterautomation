# == Class: ucx_meter
#
# UCX WAC Meter Puppet module.
#
# requires vcsrepo module
#         puppet module install puppetlabs-vcsrepo

class ucx_meter (
  $service        = false,
  $enable         = true) {
  include ucx_meter::params

  # Import some variables from ucx_meter::params.
  $ucx_meter_service_name = $ucx_meter::params::ucx_meter_service_name
  $ucx_meter_location     = $ucx_meter::params::ucx_meter_location
  $ucx_meter_config_file  = $ucx_meter::params::ucx_meter_config_file
  $ucx_meter_user_name    = $ucx_meter::params::ucx_meter_user_name
  $ucx_meter_group_name   = $ucx_meter::params::ucx_meter_group_name
  $ucx_meter_infrastructure_name = $ucx_meter::params::ucx_meter_infrastructure_name

  case $service {
    true    : { $ensure_service = 'running' }
    false   : { $ensure_service = 'stopped' }
    default : { fail('service must be true or false') }
  }

  # create a path for the meter to reside in
  file { "$ucx_meter_location":
    ensure => directory,
  }

  # pull the code from source control
  vcsrepo { $ucx_meter_location:
    ensure   => present,
    provider => git,
    source   => 'https://rtechts.git.cloudforge.com/meter.git',
  }

  # build config file - may not need this
  file { "${ucx_meter_location}/cfg/${ucx_meter_config_file}":
    ensure  => present,
    path    => "${ucx_meter_location}/cfg/${ucx_meter_config_file}",
#    owner   => $ucx_meter_user_name,
#    group   => $ucx_meter_group_name,
#    mode    => '0644',
    content => template('ucx_meter/sample.conf.info.erb'),
    require => Vcsrepo[$ucx_meter_location],
  }

  # just execute the meter - no service required
  exec { "meter":
    environment => "py_path=$(which python)",
    command => "/bin/bash $py_path meter.py",
    cwd => "${ucx_meter_location}",
    require => File["${ucx_meter_location}/cfg/${ucx_meter_config_file}"],
  }

  # service management.
  if ($service == true) {
    # install service - windows
    if $osfamily == 'windows' {
      exec { "meter":
        environment => "py_path=$(which python)",
        command => "cmd $py_path setup.py",
        cwd => "${ucx_meter_location}",
        require => File["${ucx_meter_location}/cfg/${ucx_meter_config_file}"],
      }
    } else {
      # install service - linux - put service file into? init.d?
      # exec { "meter":
      #    environment => "py_path=$(which python)",
      #    command => "/bin/bash $py_path meter.py",
      #    cwd => "${ucx_meter_location}",
      #    require => File["${ucx_meter_location}/cfg/${ucx_meter_config_file}"],
      # }
      # cron the watchdog to ensure the service is running - linux only
      # chkconfig?
      cron { meter:
        command => "${ucx_meter_location}/cfg/watchdog.sh",
        user    => root,
        hour    => 0,
        minute  => 5
      }
    }

    # first check for os - must be linux, not mac, not windows
#    file { '/etc/init.d/ucx_meter-service':
#      ensure => present,
#      source => "${ucx_meter_location}/cfg/${ucx_meter_service_name}",
#      require => Vcsrepo[$ucx_meter_location]
#    }
#
#    service { $ucx_meter_service_name:
#      ensure     => $ensure_service,
#      enable     => $enable,
#      hasrestart => true,
#      hasstatus  => true,
#      require    => File['/etc/init.d/ucx_meter-service'],
#    }
  }
}
# EOF
