require 'sinatra'
require 'userdata'

CONFIG_PATH = "#{FAKE_CLOUD_HOME}/conf/config.yml"

def load_config
  puts "Loading config file #{CONFIG_PATH}"
  cfg = OpenStruct.new(YAML.load_file(CONFIG_PATH))
  cfg.hosts ||= {}
  cfg.auth_keys ||= []
  cfg.mtime = File.mtime(CONFIG_PATH)
  puts cfg.to_h
  return cfg
end

trap 'HUP' do
  config = load_config()
end

config = load_config()

before do
  if config.mtime != File.mtime(CONFIG_PATH)
    config = load_config()
  end
  node_id = "node#{request.ip.split('.').last}"
  @host = OpenStruct.new(config.hosts[node_id])
  @host.id = node_id
  @host.name ||= node_id
end

get '/' do
  '2009-04-04'
end

get '/2009-04-04/' do
  ['meta-data/', 'user-data'].join("\n")
end

get '/2009-04-04/meta-data/' do
  opts = ['local-hostname', 'instance-id', 'public-keys', 'local-ipv4']
  if @host.enable_eth1
    opts.push('network-interfaces')
  end
  opts.join("\n")
end

get '/2009-04-04/meta-data/instance-id' do
  "iid-#{@host.id}"
end

get '/2009-04-04/meta-data/local-hostname' do
  @host.name
end

get '/2009-04-04/meta-data/local-ipv4' do
  request.ip
end

get '/2009-04-04/meta-data/public-ipv4' do
  request.ip
end

get '/2009-04-04/meta-data/public-keys' do
  config.auth_keys.join("\n")
end

get '/2009-04-04/meta-data/network-interfaces' do
  if @host.enable_eth1
    'iface eth1 inet dhcp'
  end
end

get '/2009-04-04/user-data' do
  UserData.new(@host.id, config.default_password, request.ip).generate
end
