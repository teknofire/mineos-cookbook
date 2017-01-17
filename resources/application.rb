property :version, String, default: '1.1.7'
property :checksum, String, default: 'f6fa3d0ebfb028201c109f639ade6a054bc741a639d3f2539e5351177535516a'
property :install_path, String, default: '/usr/games/minecraft'

property :games_path, String, default: '/var/games/minecraft'
property :host, String, default: '0.0.0.0'
property :port, Integer, default: 8443

property :ssl_key, String, default: '/etc/ssl/certs/mineos.key'
property :ssl_cert, String, default: '/etc/ssl/certs/mineos.crt'
property :ssl_chain, String, default: ''


default_action :install

action :install do
  include_recipe 'build-essential::default'
  include_recipe 'nodejs'

  node.default['java']['jdk_version'] = '8'

  include_recipe 'java'

  package %w( screen rdiff-backup )

  nodejs_npm 'pm2'

  directory new_resource.install_path do
    recursive true
  end

  mineos_source = "https://github.com/hexparrot/mineos-node/archive/v#{version}.tar.gz"

  remote_file mineos_package_file do
    source mineos_source
    checksum new_resource.checksum
    notifies :run, 'execute[extract_mineos]', :immediately
  end

  execute 'extract_mineos' do
    cwd new_resource.install_path
    command "tar --strip-components=1 -xz -f #{mineos_package_file}"
    action :nothing
  end

  nodejs_npm new_resource.name do
    path new_resource.install_path
    json true
    # not_if { ::File.exist? ::File.join(new_resource.install_path, 'mineos.conf') }
  end

  template '/usr/local/etc/mineos.conf' do
    source 'mineos.conf.erb'
    variables host: new_resource.host,
              port: new_resource.port,
              ssl_key: new_resource.ssl_key,
              ssl_cert: new_resource.ssl_cert,
              ssl_chain: new_resource.ssl_chain
    notifies :reload, "pm2_service[#{new_resource.name}]"
  end

  pm2_service new_resource.name do
    config(name: new_resource.name, script: 'webui.js', cwd: new_resource.install_path)
    action [:start, :enable]
  end
end

action :generatessl do
  file ::File.join(new_resource.install_path, 'generate-sslcert.sh') do
    mode '0754'
  end

  execute 'generate self signed certs' do
    command './generate-sslcert.sh'
    cwd new_resource.install_path
    not_if { ::FileTest.exists? '/etc/ssl/certs/mineos.crt' }
  end
end

action_class do
  def mineos_package_file
    ::File.join(Chef::Config[:file_cache_path], 'mineos_installer.tar.gz')
  end
end
