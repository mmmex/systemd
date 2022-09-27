# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "server" do |server|

    server.vm.box = 'centos/7'

    server.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end

    server.vm.provision "shell", name: "Init watchlog.timer service", path: "01init_service.sh"
    server.vm.provision "shell", name: "Make spawn-fcgi as unit systemd", path: "02init_fcgi.sh"
    server.vm.provision "shell", name: "Init httpd@first and httpd@second service", path: "03change_httpd.sh"

  end

end
