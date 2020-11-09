#/bin/bash
rpm -q curl || yum install -y curl
rpm -q wget || yum install -y wget
suijishu=`cat /proc/sys/kernel/random/uuid`
mkdir /tmp/$suijishu
cd /tmp/$suijishu
wget https://raw.githubusercontent.com/siemenstutorials/sspanelv2ray/master/docker-compose.yml
read -p "Please input continer Name：" dockername
read -p "Please input URL：" dockerurl
read -p "Please input KEY：" dockerkey
read -p "Please input NodeID：" dockerid
read -p "Please input Container Port：" dockerport
#安装docker
curl -sSL https://get.docker.com | bash
service docker start
systemctl enable docker
curl -L https://github.com/docker/compose/releases/download/1.17.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
curl -L https://raw.githubusercontent.com/docker/compose/1.8.0/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose
clear
#配置文件
sed -i "s|SMT|$dockername|" docker-compose.yml
sed -i "s|sspankey|$dockerkey|" docker-compose.yml
sed -i "s|68|$dockerid|" docker-compose.yml
sed -i "s|5109|$dockerport|" docker-compose.yml
sed -i "s|https://www.freecloud.pw|$dockerurl|" docker-compose.yml
docker-compose up -d
docker ps
echo $suijishu
