httpd for the Axeda Platform
============================
Install and configure httpd for the Axeda Platform.

Variables
--------
The following variables can be set in the inventory file, `instance_name/group_vars/instance/instance_settings.yml`.

### Required
The following variables must be set with the correct IP addresses. The `jboss_bind_addresses` variable can contain 1 or more hosts. Note that addresses specified in jboss_bind_addresses here are also used as connect addresses, so for now binding on the ipv4 wildcard is not supported.
```
httpd_bind_address: 192.168.3.5

jboss_bind_addresses:
    jboss-hc1: 192.168.3.2
    jboss-hc2: 192.168.3.3
```

### Optional
The following optional variables are shown with thier defaults as defined in the role.
```
jboss_port_offset: 0
httpd_http_port: 80
httpd_https_port: 443
httpd_max_clients: 40
modjk_connect_timeout: 10000
modjk_ping_interval: 300
```
File Dependencies
-----------------

### ModJK Binary
Becuase ModJK is not installed with Apache it must be installed after the fact. It should be placed in `{{ software_repo }}/modjk/{{ modjk_version }}/mod_jk.tar.gz`. The archive `mod_jk.tar.gz` should contain one file, `mod_jk.so`.

The version of mod_jk that is currently supported is: 1.2.33

### SSL Certificates
Since each instance will potentially have a different SSL certificate and they require a manual process they must be created and placed in a specific directory before running the httpd role. The directory for a specific instance would be: `{{ instance_repo }}/{{ instance_name }}/ssl`. Inside the ssl directory there should be three files: `intermediate.crt`, `server.crt`, and `server.key`.

Role Dependencies
-----------------
- install_package
- ipv4_binder