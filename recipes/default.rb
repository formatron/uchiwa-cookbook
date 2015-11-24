version = node['formatron_uchiwa']['version']
checksum = node['formatron_uchiwa']['checksum']

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

service 'uchiwa' do
  supports status: true, restart: true, reload: false
  action [ :enable, :start ]
end
