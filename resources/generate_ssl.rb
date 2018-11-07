resource_name :mineos_generate_ssl

property :install_path, String, name_property: true

action :create do
  file ::File.join(new_resource.install_path, 'generate-sslcert.sh') do
    mode '0754'
  end

  execute 'generate self signed certs' do
    command './generate-sslcert.sh'
    cwd new_resource.install_path
  end
end
