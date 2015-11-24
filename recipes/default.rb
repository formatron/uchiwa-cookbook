version = node['formatron_uchiwa']['version']
checksum = node['formatron_uchiwa']['checksum']
host = node['formatron_uchiwa']['host']
port = node['formatron_uchiwa']['port']
sensu_name = node['formatron_uchiwa']['sensu']['name']
sensu_host = node['formatron_uchiwa']['sensu']['host']
sensu_port = node['formatron_uchiwa']['sensu']['port']

cache = Chef::Config[:file_cache_path]
deb = File.join cache, 'uchiwa.deb' 
deb_url = "http://dl.bintray.com/palourde/uchiwa/uchiwa_#{version}_amd64.deb"

remote_file deb do
  source deb_url
  checksum checksum
  notifies :install, 'dpkg_package[uchiwa]', :immediately
end

dpkg_package 'uchiwa' do
  source deb
  action :nothing
  notifies :restart, 'service[uchiwa]', :delayed
end

template '/etc/sensu/uchiwa.json' do
  variables(
    host: host,
    port: port,
    sensu_name: sensu_name,
    sensu_host: sensu_host,
    sensu_port: sensu_port
  )
  notifies :restart, 'service[uchiwa]', :delayed
end

service 'uchiwa' do
  supports status: true, restart: true, reload: false
  action [ :enable, :start ]
end
