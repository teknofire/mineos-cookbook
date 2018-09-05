property :version, String, default: '1.2.0'
property :checksum, String, default: '92345a0b493e4f9d68fb82525f06ef5f7dbd0063507929f1ebb25f020c4fc036'
property :install_path, String, default: '/usr/games/minecraft'
property :user, String, default: 'ubuntu'

property :games_path, String, default: '/var/games/minecraft'
property :https, [TrueClass, FalseClass], default: true
property :host, String, default: '0.0.0.0'
property :port, Integer, default: 8443

property :ssl_key, String, default: '/etc/ssl/certs/mineos.key'
property :ssl_cert, String, default: '/etc/ssl/certs/mineos.crt'
property :ssl_chain, String, default: ''


default_action :install

action :install do
  build_essential

  node.default['nodejs']['repo'] = 'https://deb.nodesource.com/node_8.x'
  node.default['nodejs']['version'] = '8.9.0'
  include_recipe 'nodejs'

  node.default['java']['jdk_version'] = '8'

  include_recipe 'java'

  package %w( screen rdiff-backup )

  directory new_resource.install_path do
    recursive true
  end

  git new_resource.install_path do
    repository 'https://github.com/hexparrot/mineos-node'
  end

  npm_package new_resource.name do
    path new_resource.install_path
    json true
    # user new_resource.user
    options ['--unsafe-perm=true', '--allow-root']
    # not_if { ::File.exist? ::File.join(new_resource.install_path, 'mineos.conf') }
  end

  template '/etc/mineos.conf' do
    source 'mineos.conf.erb'
    cookbook 'mineos'
    variables https: new_resource.https,
              host: new_resource.host,
              port: new_resource.port,
              ssl_key: new_resource.ssl_key,
              ssl_cert: new_resource.ssl_cert,
              ssl_chain: new_resource.ssl_chain
    notifies :restart, "systemd_unit[#{new_resource.name}.service]", :delayed
  end

  file ::File.join(new_resource.install_path, 'generate-sslcert.sh') do
    mode '0754'
  end

  execute 'generate self signed certs' do
    command './generate-sslcert.sh'
    cwd new_resource.install_path
    not_if { ::FileTest.exists? '/etc/ssl/certs/mineos.crt' }
  end

  systemd_unit "#{new_resource.name}.service" do
    content lazy { ::File.read(::File.join(new_resource.install_path, 'init/systemd_conf')) }

    action [:create, :enable]
  end
end

action :reload do
  ruby_block do
    notifies :reload, "systemd_unit[#{new_resource.name}.service]"
  end
end

action_class do
  def mineos_package_file
    ::File.join(Chef::Config[:file_cache_path], 'mineos_installer.tar.gz')
  end
end
