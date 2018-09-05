property :install_path, String, default: '/usr/games/minecraft'

action :create do
  systemd_unit platform_service_name do
    content lazy { ::File.read(::File.join(new_resource.install_path, 'init/systemd_conf')) }
    action [:create, :enable]
  end

  service platform_service_name do
    supports reload: true, restart: true, start: true, stop: true
    action :nothing
  end
end

action :start do
  log 'start mineos service' do
    notifies :start, mineos_service_obj, :immediately
  end
end

action :stop do
  log 'stop mineos service' do
    notifies :stop, mineos_service_obj, :immediately
  end
end

action :reload do
  log 'reload mineos service' do
    notifies :reload, mineos_service_obj, :immediately
  end
end

action :restart do
  log 'restart mineos service' do
    notifies :restart, mineos_service_obj, :immediately
  end
end

action_class do
  include MineosCookbook::Helpers
end
