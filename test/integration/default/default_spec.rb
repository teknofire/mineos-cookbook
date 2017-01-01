describe command('npm') do
  it { should exist }
  its('stdout') { should cmp /Usage: npm \<command\>/ }
end

describe directory('/usr/games') do
  it { should exist }
end

describe directory('/usr/games/minecraft') do
  it { should exist }
end

describe file('/etc/ssl/certs/mineos.crt') do
  it { should exist }
end

describe file('/etc/ssl/certs/mineos.key') do
  it { should exist }
end

describe file('/etc/ssl/certs/mineos.pem') do
  it { should exist }
end

describe file('/usr/games/minecraft/generate-sslcert.sh') do
  it { should exist }
  its('mode') { should cmp '0754' }
end

describe file('/etc/pm2/conf.d/mineos.json') do
  it { should exist }
  its('content') { should match /webui\.js/ }
end

describe service('pm2') do
  it { should be_enabled }
  it { should be_running }
end

describe port(8443) do
  it { should be_listening }
end
