#
# Cookbook:: mytomcat
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

#execute "sudo yum install java-1.7.0-openjdk-devel"
package 'java-1.7.0-openjdk-devel'

#execute 'sudo groupadd tomcat'
group 'tomcat'

user 'tomcat' do
  manage_home false
  shell '/bin/nologin'
  group 'tomcat'
  home '/opt/tomcat'
end

#wget "http://apache.mirrors.ionfish.org/tomcat/tomcat-8/v8.0.45/bin/apache-tomcat-8.0.45.tar.gz"
remote_file "apache-tomcat-8.0.45.tar.gz" do
  source "http://apache.mirrors.ionfish.org/tomcat/tomcat-8/v8.0.45/bin/apache-tomcat-8.0.45.tar.gz"
end

directory '/opt/tomcat/' do
  owner 'tomcat'
  group 'tomcat'
  mode '0755'
  recursive true
end

# TODO: not desired state
execute 'tar xvf apache-tomcat-8.0.45.tar.gz -C /opt/tomcat --strip-components=1'

execute "chown" do
  command "chown -R tomcat:tomcat /opt/tomcat/*"
  only_if 'ls /opt/tomcat/conf', :owner => 'root'
end

execute "chmod" do
  command "chmod -R 0755 /opt/tomcat/*"
  only_if 'ls /opt/tomcat/conf', :owner => 'tomcat'
end

template '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service.erb'
end

execute 'systemctl daemon-reload'

service 'tomcat' do
  action [:start, :enable]
end
