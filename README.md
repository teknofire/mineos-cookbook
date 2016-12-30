# mineos

Defines resources to install and manages mineos

## Supported platforms

* Ubuntu 14.04

## Resources

### mineos_install

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
mineos_install 'mineos' do
  action [:install, :generatessl]
end
```

### mineos_service

Custom resource to handle the management of the mineos webui.  Uses `pm2` to provide service management

#### actions

* `enable`
* `start`
* `stop`
* `restart`
* `reload`
* `graceful_reload`

#### parameters

#### examples

```
mineos_service 'mineos' do
  action [:enable, :start]
end
```

## Recipes

### default

Provides an example for a basic install and start up mineos
