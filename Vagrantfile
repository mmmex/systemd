# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "server" do |server|

    server.vm.box = 'centos/7'

    server.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end

    server.vm.provision "shell", name: "Init timer service", path: "01init_service.sh"
    server.vm.provision "shell", name: "Init timer service", path: "02init_fcgi.sh"

  end

end
