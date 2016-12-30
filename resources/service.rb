property :user, String, default: 'root'
property :home, String

default_action :enable

# Re-Implemented from pm2 cookbook until they fix issue with startup on latest version of pm2
# https://github.com/Mindera/pm2-cookbook/issues/25
action :enable do
  Chef::Log.info "Start or gracefully reload pm2 application #{new_resource.name}"

  # Set startup based on platform
  cmd = 'pm2 startup'
  # Add the user option if doing it as a different user
  cmd << " -u #{new_resource.user}"
  execute cmd do
    environment pm2_environment
    command cmd
  end

  # Save running processes
  cmd = 'pm2 save'
  execute cmd do
    environment pm2_environment
    command cmd
  end
end

action :start do
  pm2_application new_resource.name do
    action [:start]
  end
end

action :stop do
  pm2_application new_resource.name do
    action [:stop]
  end
end

action :restart do
  pm2_application new_resource.name do
    action [:restart]
  end
end

action :reload do
  pm2_application new_resource.name do
    action [:reload]
  end
end

action :graceful_reload do
  pm2_application new_resource.name do
    action [:graceful_reload]
  end
end

action_class do
  def pm2_home
    if new_resource.home.nil?
      "#{::Dir.home(new_resource.user)}/.pm2"
    elsif %r{/\.pm2/*$} =~ new_resource.home
      new_resource.home
    else
      "#{new_resource.home}/.pm2"
    end
  end

  def pm2_environment
    { 'PM2_HOME' => pm2_home }
  end
end
