# Source: https://gist.github.com/wdullaer/f1af16bd7e970389bad3
# Ask for the user password
# Script only works if sudo caches the password for a few minutes
sudo true

# Install kernel extra's to enable docker aufs support
# sudo apt-get -y install linux-image-extra-$(uname -r)

# Add Docker PPA and install latest version
# sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
# sudo sh -c "echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
# sudo apt-get update
# sudo apt-get install lxc-docker -y

echo "Install docker and docker-compose..."

# Alternatively you can use the official docker install script
wget -qO- https://get.docker.com/ | sh
docker --version

# Install docker-compose
COMPOSE_VERSION="$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep '\"tag_name\":' | sed -E 's/.*\"([^\"]+)\".*/\1/')"
sudo curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

# Install docker-cleanup command
cd /tmp
git clone https://gist.github.com/76b450a0c986e576e98b.git
cd 76b450a0c986e576e98b
sudo mv docker-cleanup /usr/local/bin/docker-cleanup
sudo chmod +x /usr/local/bin/docker-cleanup

docker --version
