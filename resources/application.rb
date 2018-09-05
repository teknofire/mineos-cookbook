property :install_path, String, name_property: true

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
    notifies :install, 'npm_package[mineos]', :immediately
  end

  npm_package 'mineos' do
    path new_resource.install_path
    json true
    options ['--unsafe-perm=true', '--allow-root']
    action :nothing
  end
end
