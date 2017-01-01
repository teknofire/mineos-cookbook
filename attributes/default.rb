if node['platform_family'] == 'debian'
  if node['platform_version'].to_i == 16
    default['nodejs']['packages'] = ['nodejs', 'nodejs-legacy', 'npm']
  end
end
