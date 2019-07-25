#Add CentOS Repository
#---------------------
#
sudo yum -y install epel-release
#
#Install Xfce (optional)
#-----------------------
#
## yum -y groupinstall "Xfce" "X Window system"
## yum -y install xorg-x11-fonts-Type1 xorg-x11-fonts-misc
## yum -y install faience-icon-theme
## yum install xfce4-terminal
#
#Add 3rd Party Repository
#------------------------
#
sudo yum-config-manager --add-repo https://dev.jmawireless.com/repos/engineering/xran-engineering.repo
sudo yum-config-manager --add-repo https://dev.jmawireless.com/repos/third_party/xran-3rdparty.repo
#sudo yum-config-manager --add-repo https://dev.jmawireless.com/repos/release/xran-release.repo
sudo yum-config-manager --add-repo http://dl.fedoraproject.org/pub/epel/7/x86_64/ #needed for pugixml
#
#Add utilities
#-------------
sudo yum -y install wget curl
#
#Add development tools
#---------------------
#
#$ sudo yum install -y git
sudo yum install -y centos-release-scl
sudo yum install -y devtools-6
sudo yum install -y automake autoconf autoconf-archive libtool make rpm-build valgrind systemd-devel lksctp-tools-devel openssl-devel
sudo yum install -y jre1.8
sudo yum install -y sqlite-devel
sudo yum install -y cpputest
#
#Add this line to .bashrc
#```
echo "source scl_source enable devtoolset-6" >> $HOME/.bashrc
echo "export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig" >> $HOME/.bashrc
#```
#
sudo yum install -y devtoolset-6-odb
sudo yum install -y devtoolset-6-libcutl
sudo yum install -y devtoolset-6-libodb
sudo yum install -y devtoolset-6-libodb-boost
sudo yum install -y devtoolset-6-libodb-boost-devel
sudo yum install -y devtoolset-6-libodb-devel
sudo yum install -y devtoolset-6-libodb-sqlite
sudo yum install -y devtoolset-6-libodb-sqlite-devel
sudo yum install -y dbus-devel
sudo yum install -y libenbcfg-devel
sudo yum install -y libpwquality
sudo yum install -y libpwquality-devel
sudo yum install -y boost
sudo yum install -y boost-devel
sudo yum install -y pugixml-devel --nogpgcheck
sudo yum install -y trx_teko_rec-devel
#
#Add link for odb:
#
sudo mkdir /opt/rh/devtoolset-6/root/usr/lib/gcc/x86_64-redhat-linux/6.3.1/plugin/
sudo ln -s /opt/rh/devtoolset-6/root/usr/lib/gcc/x86_64-redhat-linux/6.2.1/plugin/odb.so /opt/rh/devtoolset-6/root/usr/lib/gcc/x86_64-redhat-linux/6.3.1/plugin/
#
#Install emacs (optional)
#------------------------
#
#$ sudo yum -y install libXpm-devel libjpeg-turbo-devel openjpeg-devel openjpeg2-devel turbojpeg-devel giflib-devel libtiff-devel gnutls-devel libxml2-devel GConf2-devel dbus-devel wxGTK-devel gtk3-devel
#$ wget http://git.savannah.gnu.org/cgit/emacs.git/snapshot/emacs-25.1.tar.gz
#$ tar zxvf emacs-25.1.tar.gz
#$ cd emacs-25.1
#$ ./autogen
#$ ./configure --without-makeinfo # incase makeinfo is not available on your system: Example Centos 7 else `./configure` would do
#$ sudo make install
#
#Create a new SSH key pair
#-------------------------
#
#Paste the text below, substituting in your GitHub email address.
#
## ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
#
#This creates a new ssh key, using the provided email as a label.
#When you're prompted to "Enter a file in which to save the key," press Enter. This accepts the default file location.
#
#Enter a file in which to save the key (/home/you/.ssh/id_rsa): [Press enter]
#
#At the prompt, type a secure passphrase. For more information, see "Working with SSH key passphrases".
#
#Enter passphrase (empty for no passphrase): [Type a passphrase]
#Enter same passphrase again: [Type passphrase again]
#
#Setup user
#----------
#$ groupadd --system xran
#$ useradd -r -g xran \
#      --create-home \
#      --comment 'XRAN Application account' xran
#$ usermod --groups tekodrv xran
#
#Setup folders
#-------------
#$ sudo mkdir /var/spv
#$ sudo chown root:root /var/spv
#$ sudo chmod 775 /var/spv
#
#$ sudo mkdir /var/spv/enbs
#$ sudo chown root:xran /var/spv/enbs
#$ sudo chmod 775 /var/spv/enbs
#
#Repeat for:
#* /var/spv/enbs-import
#* /var/spv/db
#* /var/spv/mapping
#* /var/log/spv
#* /var/log/spv/mapping
#
#$ sudo chown xran:xran /var/spv/db/*
#
#$ sudo mkdir /etc/spv
#$ sudo chown root:xran /etc/spv
#$ sudo chmod 775 /etc/spv
#$ sudo ln -s <project root>/src/spv-dbus.conf /etc/spv/spv-dbus.conf
#$ sudo mkdir /etc/spv/spv-session.d
#
#Install node.js
#---------------
#$ yum install node
#
#Home dir must be accessible
#---------------------------
#Needed in order to read files:
#
#sudo chmod 775 /home/$USER
#
#File points to develop:
#
#sudo mkdir /usr/share/spv
#
#To launch spv-web
#-----------------
#$ sudo /bin/dbus-daemon --config-file=/etc/spv/spv-dbus.conf --nofork --nopidfile --systemd-activation
#$ cd <project root>
#$ sudo ./src/spv-init -k
#$ sudo ./src/spv-init -c
#$ sudo /etc/spv/ssl/create-self-signed-certificate.sh
#
