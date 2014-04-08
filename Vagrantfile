# -*- mode: ruby -*-
# vi: set ft=ruby :

## Bootstrap machine with runlist already specified:
## knife bootstrap 192.168.2.10 --sudo -x vagrant -P vagrant -N "sandbox1" -r "recipe[tippfuchs::default]"

Vagrant.configure("2") do |config|
  config.vm.hostname = "tippfuchs-sandbox"
  config.vm.box = "ubuntu1204"
  # config.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04-i386_provisionerless.box"
  
  config.vm.network :private_network, ip: "192.168.2.10"
  config.vm.boot_timeout = 120
end
