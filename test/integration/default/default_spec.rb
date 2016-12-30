describe directory('/usr/games') do
  it { should exist }
end

describe directory('/usr/games/minecraft') do
  it { should exist }
end
