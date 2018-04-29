#!/bin/sh
# Curtesy of https://kubecloud.io/f8b3b85bc2d1

INSTALLATION_SQUENCE_NUMBER="xx"

echo "### $INSTALLATION_SQUENCE_NUMBER.1 - Installing Docker"
echo "## $INSTALLATION_SQUENCE_NUMBER.1.1 - Installing Docker from bootstrap script"
curl -sSL get.docker.com | sh
echo "## $INSTALLATION_SQUENCE_NUMBER.1.2 - Adding pi user to docker group"
sudo usermod pi -aG docker

echo "### $INSTALLATION_SQUENCE_NUMBER.2 - Disabling swap"
echo "## $INSTALLATION_SQUENCE_NUMBER.2.1 - Disabling swap and removing swap support"
sudo dphys-swapfile swapoff && \
  sudo dphys-swapfile uninstall && \
  sudo update-rc.d dphys-swapfile remove
echo "## $INSTALLATION_SQUENCE_NUMBER.2.2 Adding \" cgroup_enable=cpuset cgroup_enable=memory\" to /boot/cmdline.txt"
sudo cp /boot/cmdline.txt /boot/cmdline_backup.txt
# if you encounter problems, try changing cgroup_memory=1 to cgroup_enable=memory.
orig="$(head -n1 /boot/cmdline.txt) cgroup_enable=cpuset cgroup_memory=1"
echo $orig | sudo tee /boot/cmdline.txt

echo "### $INSTALLATION_SQUENCE_NUMBER.3 - Adding K8s repo and installing kubeadm"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
  echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
  sudo apt-get update -q && \
  sudo apt-get install -qy kubeadm
