# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
#Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  #config.vm.box = "base"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
#end

Master_Node = 1
Worker_Node = 2
IP_Network  = "192.168.50."

Master_IP_Start = 10
Worker_IP_Start = 20
LB_IP_Start = 30

Vagrant.configure("2") do |conf|
  # specify the VM box 
  conf.vm.box = "ubuntu/bionic64"
  conf.vm.box_check_update = false

  # Generate token and join node to master

  #Provision Master node 
  (1..Master_Node).each do |j|
    conf.vm.define "k8sMaster#{j}" do |node|
      node.vm.provider "virtualbox" do |vb|
        vb.name = "k8sMaster#{j}"
        vb.memory = 2048 
        vb.cpus = 2
      end
      
      node.vm.hostname = "k8sMaster#{j}"
      node.vm.network :private_network, ip: IP_Network + "#{Master_IP_Start + j}"
      node.vm.network "forwarded_port", guest: 22, host: "#{2270 + j}"

      node.vm.provision "host-setup", :type => "shell", :path => "ubuntu/host_setup.sh" do |sh|
        sh.args = ["enp0s8"]
      end 

      node.vm.provision "dns-update", type: "shell", :path => "ubuntu/dns_update.sh"

      # install prereq's
      node.vm.provision "install-prereq's", type: "shell", :path => "ubuntu/install_prereq.sh"

      # install kubeadm in master node
      node.vm.provision "install-kubeadm", :type => "shell", :path => "ubuntu/install_kubeadm.sh", privileged: false do |kube|
        kube.args = ["enp0s8"]
      end 

      node.vm.provision :shell, privileged: false do |shell|
        shell.inline = <<-SHELL
          sudo apt-get install jq -y
          Cert_Hash=$(openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //')
          Token=$(sudo kubeadm token list -o json | jq -r '.token' | head -1)
          IP=$(kubectl get nodes -lnode-role.kubernetes.io/master -o json | jq -r '.items[0].status.addresses[] | select(.type=="InternalIP") | .address')
          Port=6443
          echo "sudo kubeadm join $IP:$Port --token=$Token --discovery-token-ca-cert-hash sha256:$Cert_Hash" > /vagrant/join.sh          
        SHELL
      end

    end
  end 


  #Provision Worker node 
  (1..Worker_Node).each do |j|
    conf.vm.define "k8sNode0#{j}" do |node|
      node.vm.provider "virtualbox" do |vb|
        vb.name = "k8sNode0#{j}"
        vb.memory = 2048 
        vb.cpus = 2
      end
      
      node.vm.hostname = "k8sNode0#{j}"
      node.vm.network :private_network, ip: IP_Network + "#{Worker_IP_Start + j}"
      node.vm.network "forwarded_port", guest: 22, host: "#{2280 + j}"

      node.vm.provision "host-setup", :type => "shell", :path => "ubuntu/host_setup.sh" do |sh|
        sh.args = ["enp0s8"]
      end 

      node.vm.provision "dns-update", type: "shell", :path => "ubuntu/dns_update.sh"

      # install prereq's
      node.vm.provision "install-prereq's", type: "shell", :path => "ubuntu/install_prereq.sh"

      # Join the node to Master
      node.vm.provision :shell, privileged: false do |shell|
        shell.inline = <<-SHELL
          sudo chmod +x /vagrant/join.sh
          sudo sh /vagrant/join.sh
        SHELL
      end

    end
  end 

end



