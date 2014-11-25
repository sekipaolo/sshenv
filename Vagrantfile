# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.require_version ">= 1.5.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.hostname = "sshenv-berkshelf"

  config.omnibus.chef_version = :latest

  config.vm.box = "debian-1.0.10"

  config.vm.network :private_network, ip: "33.33.33.40"

  config.berkshelf.enabled = true

  config.vm.provision :chef_solo do |chef|

    chef.json = {

    }

    chef.run_list = [
      
        "recipe[sshenv::_test_create]"
    ]

    chef.log_level = :error
  end
end
