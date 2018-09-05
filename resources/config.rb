property :https, [TrueClass, FalseClass], default: true
property :host, String, default: '0.0.0.0'
property :port, Integer, default: 8443

property :generate_cert, [TrueClass, FalseClass], default: true

property :install_path, String, default: '/usr/games/minecraft'
property :ssl_key, String, default: '/etc/ssl/certs/mineos.key'
property :ssl_cert, String, default: '/etc/ssl/certs/mineos.crt'
property :ssl_chain, String, default: ''

action :create do
  template new_resource.name do
    source 'mineos.conf.erb'
    cookbook 'mineos'
    variables https: new_resource.https,
              host: new_resource.host,
              port: new_resource.port,
              ssl_key: new_resource.ssl_key,
              ssl_cert: new_resource.ssl_cert,
              ssl_chain: new_resource.ssl_chain
  end

  mineos_generate_ssl new_resource.install_path do
    only_if { new_resource.generate_cert }
    not_if { ::File.exist?(new_resource.ssl_cert) }
  end
end
