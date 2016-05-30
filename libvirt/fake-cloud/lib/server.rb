require 'sinatra'
require_relative 'userdata.rb'

get '/' do
  '2009-04-04'
end

get '/2009-04-04/' do
  ['meta-data/', 'user-data'].join("\n")
end

get '/2009-04-04/meta-data/' do
  ['local-hostname', 'instance-id', 'public-keys', 'local-ipv4', 'network-interfaces'].join("\n")
end

get '/2009-04-04/meta-data/instance-id' do
  instance_id
end

get '/2009-04-04/meta-data/local-hostname' do
  hostname
end

get '/2009-04-04/meta-data/local-ipv4' do
  request.ip
end

get '/2009-04-04/meta-data/public-ipv4' do
  request.ip
end

get '/2009-04-04/meta-data/public-keys' do
  IO.read("#{FAKE_CLOUD_HOME}/conf/key.pem")
end

get '/2009-04-04/meta-data/network-interfaces' do
  'iface eth1 inet dhcp'
end

get '/2009-04-04/user-data' do
  UserData.new(node_id, node_id, request.ip).generate
end

def node_id
  "node#{request.ip.split('.').last}"
end

def instance_id
  "iid-#{node_id}"
end

def hostname
  hostnames = YAML.load_file("#{FAKE_CLOUD_HOME}/conf/hostnames.yml")
  if hostnames[node_id]
    return hostnames[node_id]
  else
    return node_id
  end
end
