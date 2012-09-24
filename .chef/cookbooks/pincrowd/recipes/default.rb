#
# Cookbook Name:: pincrowd
# Recipe:: default
#
# Copyright 2012, pincrowd, Inc.
#
# All rights reserved - Do Not Redistribute

cookbook_file "/home/vagrant/.ssh/authorized_keys" do
  source "home/vagrant/.ssh/authorized_keys"
  mode "0600"
  owner "vagrant"
  group "vagrant"
  action :nothing
end

cookbook_file "/etc/ssh/sshd_config" do
  source "etc/ssh/sshd_config"
  mode "644"
  owner "root"
  group "root"
end

service "ssh" do
  action [:enable, :restart]
end

execute "setup-environment-for-apache" do
  command <<-EOF
if [ ! -le /export/sites/#{node[:pincrowd][:apache2][:vhost][:server_name]}/current ]; then
    ln -nsf /export/sites/#{node[:pincrowd][:apache2][:vhost][:server_name]}/releases/local\
 /export/sites/#{node[:pincrowd][:apache2][:vhost][:server_name]}/current
fi

    if ! grep -q #{node[:hostname]} /etc/hosts; then
        echo "127.0.0.1       #{node[:hostname]}" >> /etc/hosts
        echo "fe80::1%lo0     #{node[:hostname]}" >> /etc/hosts
        echo "::1             #{node[:hostname]}" >> /etc/hosts
    fi

    if ! grep -q "#{node[:pincrowd][:apache2][:vhost][:server_name]}" /etc/hosts; then
        echo "127.0.0.1       #{node[:pincrowd][:apache2][:vhost][:server_name]}" >> /etc/hosts
        echo "fe80::1%lo0     #{node[:pincrowd][:apache2][:vhost][:server_name]}" >> /etc/hosts
        echo "::1             #{node[:pincrowd][:apache2][:vhost][:server_name]}" >> /etc/hosts
    fi
  EOF
end

execute "add-vagrant-mysql" do
  command <<-EOF
  export DEBIAN_FRONTEND=noninteractive
  apt-get -y install mysql-server-5.5
  mysql -u root -e "CREATE USER '#{node[:pincrowd][:mysql][:username]}'@'localhost'
    IDENTIFIED BY '#{node[:pincrowd][:mysql][:password]}';"
  mysql -u root -e "GRANT ALL ON *.* TO '#{node[:pincrowd][:mysql][:username]}'@'localhost';"
  mysql -u root -e "FLUSH PRIVILEGES;"
  EOF
end


execute "install-apache-server" do
  command <<-EOD
  apt-get -yq update
  apt-get -yq install apache2 libapache2-mod-php5 php5-uuid php5 php5-cli \
    php5-curl php5-xsl php5-xdebug git-core nfs-common build-essential \
    autoconf php-pear liblua5.1-dev liblua5.1 lua5.1 lua5.1-dev libpcre3-dev \
    php5-mysql php5-mcrypt php5-pgsql php5-gmp
  EOD
end

execute "install-mongodb-10gen" do
  command <<-EOF
    apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
    echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' > /etc/apt/sources.list.d/10gen.list
    apt-get -yq update
    apt-get -yq install mongodb-10gen
  EOF
end

source_root = "/export/sites/"
execute "symlink-source-code" do
  command <<-EOF
  ln -nsf #{source_root}#{node[:pincrowd][:apache2][:vhost][:server_name]}/releases/local \
    #{source_root}#{node[:pincrowd][:apache2][:vhost][:server_name]}/current
  EOF
end

cookbook_file "/etc/apache2/sites-available/#{node[:pincrowd][:apache2][:vhost][:server_name]}" do
  source "etc/apache2/sites-available/#{node[:pincrowd][:apache2][:vhost][:server_name]}"
  user "root"
  group "root"
  mode 0644
end

execute "a2ensite" do
  command "a2ensite #{node[:pincrowd][:apache2][:vhost][:server_name]}"
end

execute "a2enmod" do
  command "a2enmod rewrite"
end

service "apache2" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :reload ]
end
