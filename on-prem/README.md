# K8s-Master-Slave

Setup K8s Master slave setup in Laptop using Kubeadm.
Create kubeadm cluster using vagrant file

### install virtual box ###
brew cask install virtualbox 

### install vagrant
brew cask install vagrant

Vagrant-Manager helps you manage all your virtual machines in one place directly from the menubar. (Not mandatory)
$ brew cask install vagrant-manager

### clone github repo which contains vagrant file and shell scripts 
 git clone https://github.com/Nagendran2807/k8s-master-slave-kubeadm.git

![image](../../master/images/install_master_slave_setup.png)

## Go to the repo path 
cd k8s-master-slave-kubeadm/on-prem 

### Check the status & run vagrant
vagrant status

vagrant up 

### Once machine provisioning done, you can login the machine's through ssh
vagrant ssh k8sMaster1 (For example)

#### Useful Vagrant commands ###
If you want to connect using your own SSH client then just execute this command
vagrant ssh-config

ssh vagrant@127.0.0.1 -p2222 -i /Users/nmuthu036/vagrant-tutorial/.vagrant/machines/k8sMaster1/virtualbox/private_key


#### vagrant commands ####
https://futuredevops.blogspot.com/2021/01/vagrant.html
