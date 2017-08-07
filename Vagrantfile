# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'bento/ubuntu-16.04'
  config.vm.network "private_network", ip: "192.168.50.4"
  config.vm.network "private_network", ip: "192.168.50.5"
  config.vm.network "private_network", ip: "192.168.50.6"
  config.vm.network "private_network", ip: "192.168.50.7"
  config.vm.network "private_network", ip: "192.168.50.8"
  config.vm.synced_folder '.', '/var/www'

  config.vm.provision 'shell', path: "bin/provision.sh"

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
    vb.customize ["modifyvm", :id, "--name", "PublicProxy"]
  end
end

