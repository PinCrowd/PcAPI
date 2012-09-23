#
# Cookbook Name:: pincrowd
# Recipe:: default
#
# Copyright 2012, Ifbyphone, Inc.
#
# All rights reserved - Do Not Redistribute

execute "config-pear" do
  command <<-EOF
    pear config-set auto_discover 1
    pear config-set preferred_state beta
    pear update-channels
  EOF
end

execute "install-mongo" do
  command <<-EOF
      pecl install --force --onlyreqdeps mongo
      echo 'extension=mongo.so' > /etc/php5/conf.d/mongo.ini
  EOF
end

#execute "install-pecl-lua" do
#  command <<-EOF
#      pecl install --force --onlyreqdeps lua
#      echo 'extension=lua.so' > /etc/php5/conf.d/lua.ini
#  EOF
#end


execute "install-pecl-weakref" do
  command <<-EOF
      pecl install --force --onlyreqdeps weakref
      echo 'extension=weakref.so' > /etc/php5/conf.d/weakref.ini
  EOF
end

execute "pear-install" do
  command <<-EOF
  if pear shell-test pear.phpunit.de/PHPUnit != 3.6.12; then
    pear install --force --onlyreqdeps pear.phpunit.de/PHPUnit-3.6.12
  fi
  if pear shell-test pear.phpunit.de/PHP_CodeCoverage != 1.1.3; then
      pear install --force --onlyreqdeps pear.phpunit.de/PHP_CodeCoverage-1.1.3
  fi
  if ! pear shell-test pear.pdepend.org/PHP_Depend; then
      pear install --force --onlyreqdeps pear.pdepend.org/PHP_Depend
  fi
  if ! pear shell-test pear.pdepend.org/PHP_CodeSniffer_Standards_PDepend2; then
      pear install --force --onlyreqdeps pear.pdepend.org/PHP_CodeSniffer_Standards_PDepend2
  fi
  if ! pear shell-test bartlett.laurent-laville.org/PHP_CompatInfo; then
      pear install --force --onlyreqdeps bartlett.laurent-laville.org/PHP_CompatInfo
  fi
  if pear shell-test pear.phpunit.de/phpcpd != 1.3.5; then
      pear install --force --onlyreqdeps pear.phpunit.de/phpcpd-1.3.5
  fi
  if pear shell-test pear.phpunit.de/phploc != 1.6.4; then
      pear install --force --onlyreqdeps pear.phpunit.de/phploc-1.6.4
  fi
  if ! pear shell-test pear.phpdoc.org/PHPDocumentor-alpha; then
      pear install --force --onlyreqdeps pear.phpdoc.org/PHPDocumentor-alpha
  fi
  if ! pear shell-test pear/PHP_CodeSniffer; then
      pear install --force --onlyreqdeps pear/PHP_CodeSniffer
  fi
  if pear shell-test pear.phpunit.de/PHP_CodeBrowser != 3.6.12; then
      pear install --force --onlyreqdeps pear.phpunit.de/PHP_CodeBrowser
  fi
  EOF
end

package "curl" do
  action [:install, :upgrade]
end

cookbook_file "/etc/profile.d/php-composer.sh" do
  source "etc/profile.d/php-composer.sh"
  mode "0755"
  owner "root"
  group "root"
end

execute "install-composer" do
  command <<-EOF
  curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin
  . /etc/profile.d/php-composer.sh
  composer self-update -q -n
  EOF
end


execute "clear-pear-cache" do
  command <<-EOF
      pear clear-cache
  EOF
end

package "openjdk-7-jdk" do
  action :install
end

package "ant" do
  action :install
end

