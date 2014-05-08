#
# Cookbook Name:: defset
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
log "Hello World"

execute "aptitude-dist-upgrade" do
	command "sudo aptitude dist-upgrade -y"
	action :nothing
end

execute "aptitude-update" do
	command "sudo aptitude update -y"
	notifies :run, "execute[aptitude-dist-upgrade]", :immediately
end

template ".bashrc" do
	path "/home/vagrant/.bashrc"
	source ".bashrc.erb"
	mode 0644
end

template ".bash_aliases" do
	path "/home/vagrant/.bash_aliases"
	source ".bash_aliases.erb"
	mode 0644
end

execute "update-alternatives-editor" do
	command "update-alternatives --set editor /usr/bin/vim.nox"
	action :nothing
end

package "vim-nox" do
	action :install
	notifies :run, "execute[update-alternatives-editor]", :immediately
end

package "etckeeper" do
	action :install
end

package "tig" do
	action :install
end

package "git" do
	action :install
end

package "ntp" do
	action :install
end

template "sshd_config" do
	path "/etc/ssh/sshd_config"
	source "sshd_config.erb"
	mode 0644
end

execute "ufw-allow-openssh" do
	command 'ufw insert 1 allow from 192.168.33.0/24 to any app OpenSSH'
	action :nothing
end

execute "ufw-limit-openssh" do
	command 'ufw limit OpenSSH'
	action :nothing
	notifies :run, "execute[ufw-allow-openssh]", :immediately
end

execute "ufw-enable" do
	command 'printf y | ufw enable'
	notifies :run, "execute[ufw-limit-openssh]", :immediately
end

