# mineos

Defines custom resources to install and manages mineos

By default to access the mineos webgui point a browser at https://SERVERNAME:8443

The login will be any valid system account so access should be restricted to this system using a firewall or some other mechanism.

## Requirements

* Supported platforms: Ubuntu 16.04
* Chef-Client: >= 14

## Usage

Add the following to the metadata.rb

```
depends 'mineos'
```

## Resources

### mineos_application

Downloads and installs mineos from git

#### actions

* `:install` - _(default action)_: installs mineos and configures systemd service with a self signed certificate

#### parameters

* `install_path` - This should be the path to install the mineos application, can be set with the name property

#### examples

```
mineos_application '/usr/games/minecraft'
```

### mineos_config

#### actions

* `create` - create the necessary configs

#### parameters

* `https` - bool
* `host` - host/ip to bind to, default: '0.0.0.0'
* `port` - port to listen on, default: 8443

* `generate_cert` - generate a self signed certificate, default: true
* `install_path` - install path for mineos, default: '/usr/games/minecraft'
* `ssl_key` - SSL certificate key path, default: '/etc/ssl/certs/mineos.key'
* `ssl_cert` - SSL certificate path, default: '/etc/ssl/certs/mineos.crt'
* `ssl_chain` - SSL chain path, default: ''

#### examples

```
mineos_config '/etc/mineos.conf' do
  install_path '/usr/games/minecraft'
  notifies :reload, 'mineos_service[mineos.service]', :immediately
end
```

### mineos_service

Handles setting up and managing mineos service.  Currently limited to setting up systemd services

#### actions

* `create` - install the unit files for the service
* `start` - start the service
* `stop` - stop the service
* `restart` - restart the service
* `reload` - reload the service

#### parameters

* `install_path` - path to the location where mineos was installed

#### examples

```
mineos_service 'mineos.service' do
  install_path '/usr/games/minecraft'
  action [:create, :start]
end
```

## Recipes

### default

Provides an example for a basic install and start up mineos
