# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  config.vm.define :web do |web_config|
    server_name = "pincrowd.local"
    web_config.vm.network :hostonly, "10.0.0.10"
    web_config.vm.box = "pincrowd64"
    web_config.vm.box_url = "http://ibpvagrant.s3.amazonaws.com/pincrowd64.box"
    web_config.vm.share_folder "v-data",
                               "/export/sites/#{server_name}/shared", "/tmp/"
    web_config.vm.share_folder "v-data",
                               "/export/sites/#{server_name}/releases/local", "./"
    web_config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = ".chef/cookbooks"
      chef.roles_path = ".chef/roles"
      chef.data_bags_path = ".chef/data_bags"
      chef.add_role("pincrowd")
    end
  end
end
