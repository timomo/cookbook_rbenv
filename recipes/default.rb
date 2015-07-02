#
# Cookbook Name:: rbenv
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
group "rbenv" do
  action :create
end

git "/opt/rbenv" do
  repository "https://github.com/sstephenson/rbenv.git"
  revision "master"
  user "root"
  group "rbenv"
  action :sync
end

directory "/opt/rbenv/plugins" do
  action :create
end

git "/opt/rbenv/plugins/ruby-build" do
  repository "https://github.com/sstephenson/ruby-build.git"
  revision "master"
  user "root"
  group "rbenv"
  action :sync
end

template "/etc/profile.d/rbenv.sh" do
  source "profile.d/rbenv.sh.erb"
  owner "root"
  group "root"
  mode "0644"
end

# install dependencies package
yum_package "openssl-devel.x86_64" do
  action :upgrade
end

# install ruby 2.1.6
bash "install ruby" do
  code <<-_EOH_
    source /etc/profile.d/rbenv.sh
    rbenv install 2.1.6
    rbenv global 2.1.6
  _EOH_
  not_if { File.exist?("/opt/rbenv/shims/ruby") }
end