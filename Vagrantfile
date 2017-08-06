# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

@script = <<SCRIPT
# Provision script

# Updating packages library
apt-get update

# Installing apt dependencies
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# Add docker's GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Installing Docker
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get update

# Installing Docker CE
apt-get install -y docker-ce

SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'bento/ubuntu-16.04'
  config.vm.network "private_network", ip: "192.168.50.4"
  config.vm.network "private_network", ip: "192.168.50.5"
  config.vm.network "private_network", ip: "192.168.50.6"
  config.vm.network "private_network", ip: "192.168.50.7"
  config.vm.network "private_network", ip: "192.168.50.8"
  config.vm.synced_folder '.', '/var/www'

  config.vm.provision 'shell', inline: @script

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
    vb.customize ["modifyvm", :id, "--name", "PublicProxy"]
  end
end

