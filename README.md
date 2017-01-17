# mineos

Defines resources to install and manages mineos

By default to access the mineos webgui point a browser at https://SERVERNAME:8443

The login will be any valid system account so access should be restricted to this system using a firewall or some other mechanism.

## Supported platforms

* Ubuntu 14.04

## Usage

Add the following to the metadata.rb

```
depends 'mineos'
```

Add the following to a recipe, I would not recommend including the default recipe unless you lock it to a specific version of the cookbook as future versions of the cookbook my try to update with new versions.

```
mineos_package 'mineos' do
  action [:install, :generatessl]
end

pm2_service 'mineos' do
  config(script: 'webui.js', cwd: '/usr/games/minecraft')
  action [:start, :enable]
end
```

## Resources

### mineos_package

Downloads and installs mineos

#### actions

* `:install` - _(default action)_: install and create pm2 configureation for mineos

* `:generatessl` - generate self-signed certificates for mineos

#### parameters

* `name`
* `version`
* `checksum`
* `install_path`

#### examples

```
mineos_package 'mineos' do
  action [:install, :generatessl]
end
```

### pm2_service

Custom resource to handle the management of the mineos webui.  Uses `pm2` to provide service management

#### actions

* `enable`
* `start`
* `stop`
* `restart`
* `reload`
* `graceful_reload`

#### parameters

* `name`
* `user` - _(default: root)_ user that runs pm2 service
* `home` - pm2 home to use if different from the user running pm2
* `config` - configuration values for the pm2 service.  Example: `{ script: 'server.js', cwd: 'path/to/script' }`
* `initsystem` - used to configure automatic startup of pm2 service on boot.  Only needed if pm2 cannot autodetect systems init method.  See `pm2 startup` documentation for more info

#### examples

```
mineos_service 'mineos' do
  action [:enable, :start]
end
```

## Recipes

### default

Provides an example for a basic install and start up mineos
