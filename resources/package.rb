property :version, String, default: '1.1.7'
property :checksum, String, default: 'f6fa3d0ebfb028201c109f639ade6a054bc741a639d3f2539e5351177535516a'
property :install_path, String, default: '/usr/games/minecraft'

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

  nodejs_npm 'mineos' do
    path new_resource.install_path
    json true
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
