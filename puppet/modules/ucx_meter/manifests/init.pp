# == Class: ucx_meter
#
# UCX WAC Meter Puppet module.
#
# requires vcsrepo module
#         puppet module install puppetlabs-vcsrepo

class ucx_meter () {
  include ucx_meter::params

  # Import some variables from ucx_meter::params.
  $service                = $ucx_meter::params::service
  $ucx_meter_service_name = $ucx_meter::params::ucx_meter_service_name
  $ucx_meter_location     = $ucx_meter::params::ucx_meter_location
  $ucx_meter_config_file  = $ucx_meter::params::ucx_meter_config_file
  $ucx_meter_user_name    = $ucx_meter::params::ucx_meter_user_name
  $ucx_meter_group_name   = $ucx_meter::params::ucx_meter_group_name
  $ucx_meter_infrastructure_name = $ucx_meter::params::ucx_meter_infrastructure_name
  $ucx_meter_source_location  = $ucx_meter::params::ucx_meter_source_location
  $ucx_org_id             = $ucx_meter::params::ucx_org_id
  $ucx_exchange_location   = $ucx_meter::params::ucx_exchange_location
  $ucx_meter_infrastructure_id = $ucx_meter::params::ucx_meter_infrastructure_id

  case $service {
    true    : { $ensure_service = 'running' }
    false   : { $ensure_service = 'stopped' }
    default : { fail('service must be true or false') }
  }

  $packages = [ "git", "python-pip", "curl", "python-dev" ]
  package { $packages:
    ensure => "present",
    before => File["$ucx_meter_location"]
}

  # create a path for the meter to reside in
  file { "$ucx_meter_location":
    ensure => directory,
  }

  # pull the code from source control
  vcsrepo { $ucx_meter_location:
    ensure   => present,
    provider => git,
    source   => $ucx_meter_source_location,
    require  => File["$ucx_meter_location"],
    revision => 'prod',
  }

  #chmod -R $ucx_meter_user_name:$ucx_meter_group_name $ucx_meter_location
  exec { 'ucx_meter chown':
       command  => "/bin/chown -R $ucx_meter_user_name:$ucx_meter_group_name $ucx_meter_location",
       require  => Vcsrepo[$ucx_meter_location],
  }

  exec { 'ucx_meter_service chmod':
       command  => "/bin/chown -R $ucx_meter_user_name:$ucx_meter_group_name $ucx_meter_location/cfg/$ucx_meter_service_name",
       require  => Vcsrepo[$ucx_meter_location],
  }

  # build config file - may not need this
  file { "${ucx_meter_location}/cfg/${ucx_meter_config_file}":
    ensure  => present,
    path    => "${ucx_meter_location}/cfg/${ucx_meter_config_file}",
    owner   => $ucx_meter_user_name,
    group   => $ucx_meter_group_name,
    mode    => '0644',
    content => template('ucx_meter/sample.conf.info.erb'),
    require => Exec['ucx_meter chown'],
  }

  exec { "prereq python":
    environment => "py_path=$(which python)",
    command => "/bin/bash -c 'curl -o /tmp/ez_setup.py https://bootstrap.pypa.io/ez_setup.py; /usr/bin/python2.7 ez_setup.py;pip2 install psutil; pip2 install netifaces; sudo pip2 install py-cpuinfo'",
    cwd => "/tmp",
    require => File["${ucx_meter_location}/cfg/${ucx_meter_config_file}"],
  }

  # just execute the meter - no service required
  exec { "meter":
    environment => "py_path=$(which python)",
    command => "/bin/bash -c 'pip install -r ${ucx_meter_location}/requirements.txt;${ucx_meter_location}/cfg/${ucx_meter_service_name} start'",
    cwd => "${ucx_meter_location}",
    require => Exec["prereq python"],
  }

  # service management. TODO - needs to be implemented for windows
#  if ($service == true) {
#    # install service - windows
#    if $osfamily == 'windows' {
#      exec { "meter":
#        environment => "py_path=$(which python)",
#        command => "cmd $py_path setup.py",
#        cwd => "${ucx_meter_location}",
#        require => File["${ucx_meter_location}/cfg/${ucx_meter_config_file}"],
#        provider => 'shell',
#      }
#    } else {
#    }
#  }
}