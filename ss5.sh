#/bin/bash
##############################################################
#                                                            #
#                                                            #
# Author：Siemenstutorials                                   #
#                                                            #
# Youtube channel:https://www.youtube.com/c/siemenstutorials #
#                                                            #
#                                                            #
##############################################################
#check system
if [[ -f /etc/redhat-release ]]; then
  release="centos"
elif cat /etc/issue | grep -Eqi "debian"; then
  release="debian"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
  release="ubuntu"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
  release="centos"
elif cat /proc/version | grep -Eqi "debian"; then
  release="debian"
elif cat /proc/version | grep -Eqi "ubuntu"; then
  release="ubuntu"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
  release="centos"
else
  echo -e "${red}未检测到系统版本，请联系脚本作者！${plain}\n" && exit 1
fi
if [ "$release" == "centos" ]; then
yum -y install wget curl 
else
apt-get -y install wget curl 
fi

#install socks5 basic
yum install -y gcc openldap-devel pam-devel openssl-devel

#download socks5
wget http://jaist.dl.sourceforge.net/project/ss5/ss5/3.8.9-8/ss5-3.8.9-8.tar.gz && tar -vzx -f ss5-3.8.9-8.tar.gz && cd ss5-3.8.9 && ./configure
make
make install
chmod a+x /etc/init.d/ss5

#user config
echo -e "\033[32m------------------SOCKS5设置------------------\033[0m"
read -p "请输入用户名(默认用户名：siemenstutorials)：" username
[ -z "${username}" ] && username=siemenstutorials
echo
echo "-----------------------------------------------------"
echo "username = ${username}"
echo "-----------------------------------------------------"
echo
read -p "请输入密码(默认密码:123456)：" mykey
[ -z "${mykey}" ] && mykey=123456
echo
echo "-----------------------------------------------------"
echo "mykey = ${mykey}"
echo "-----------------------------------------------------"
echo
read -p "请输入SOCKS5端口(Default Key:1080)：" port_1
[ -z "${port_1}" ] && port_1=1080
echo
echo "-----------------------------------------------------"
echo "port_1 = ${port_1}"
echo "-----------------------------------------------------"
echo

#开启用户密码登陆
confFile=/etc/opt/ss5/ss5.conf
userFile=/etc/opt/ss5/ss5.passwd
echo -e ${username} ${mykey} >> $userFile
sed -i '87c auth    0.0.0.0/0               -               u' $confFile
sed -i '203c permit u	0.0.0.0/0	-	0.0.0.0/0	-	-	-	-	-' $confFile

#port
portfile=/etc/init.d/ss5 
sed -i '6c export SS5_SOCKS_PORT=1080' $portfile
sed -i '7c SS5_SOCKS_USER=root' $portfile
sed -i "s|1080|${port_1}|" $portfile
clear
#设置开机启动
echo 'mkdir /var/run/ss5/' >> /etc/rc.d/rc.local ;
chmod +x /etc/rc.d/rc.local ;
/sbin/chkconfig ss5 on 
service ss5 start && service ss5 status
echo
echo "Socks5安装完成"
echo
echo -e "SOCKS5帐号登陆信息如下："
echo -e "用户名：${username}"
echo -e "服务器端口：${port_1}"
echo -e "密码：${mykey}"
