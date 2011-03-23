#
# Cookbook Name:: couchdb
# Recipe:: default
#

if ['util', 'solo'].include?(node[:instance_role])
  # customize here
  COUCHDB_VERSION = "0.9.1"
  COUCHDB_PORT    = '5984'
  COUCHDB_SERVER  = '_'
  
  package "dev-db/couchdb" do
    version COUCHDB_VERSION
    action :upgrade
  end
  
  directory "/data/couchdb" do
    owner 'couchdb'
    group 'couchdb'
    mode 0755
    recursive true
    action :create
  end
  
  template "/etc/couchdb/local.ini" do
    owner 'root'
    group 'root'
    mode 0644
    source "couchdb_local.ini.erb"
    variables({
      :version => COUCHDB_VERSION,
      :database_dir => '/data/couchdb',
      :view_index_dir => '/data/couchdb',
      :log_file => '/data/couchdb/couch.log',
      # :pidfile => '/var/run/couchdb/couchdb.pid',
      :port  => COUCHDB_PORT,
      :loglevel => 'notice',
      :os_process_timeout => 5000,
    })
  end

  template "/data/monit.d/couchdb.monitrc" do
    owner 'root'
    group 'root'
    mode 0644
    source "couchdb.monitrc.erb"
    variables({
      :pidfile => '/var/run/couchdb/couchdb.pid',
    })
  end
  
  template '/etc/nginx/servers/couchdb.conf' do
    owner 'root'
    group 'root'
    mode 0644
    source 'nginx_servers_couchdb.conf.erb'
    variables({
      :port => COUCHDB_PORT,
      :server_name => COUCHDB_SERVER,
    })
  end
  
end