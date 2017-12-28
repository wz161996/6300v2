#!/bin/sh
# Compile:by-lanse	2017-08-30
route_vlan=`/sbin/ifconfig br0 |grep "inet addr"| cut -f 2 -d ":"|cut -f 1 -d " " `
username=`nvram get http_username`
echo -e -n "\033[41;37m......\033[0m\n"
sleep 3
if [ ! -d "/jffs/configs/dnsmasq.d" ]; 
then
	mkdir -p -m 755 /jffs/configs/dnsmasq.d
	echo -e "\e[1;36m ���� dnsmasq ����ű��ļ��� \e[0m\n"
	cp -f /tmp/hsfq_script.sh /jffs/configs/dnsmasq.d/hsfq_script.sh
	cp -f /etc/resolv.conf /jffs/configs/dnsmasq.d/resolv_bak
fi

if [ ! -f "/jffs/configs/dnsmasq.d/userlist" ]; 
then
	echo -e "\e[1;36m �����Զ��巭ǽ���� \e[0m\n"
	cat > "/jffs/configs/dnsmasq.d/userlist" <<EOF
# ����dns�Ż�
address=/email.163.com/223.6.6.6
#address=/mail.qq.com/114.114.114.114
EOF
fi
chmod 644 /jffs/configs/dnsmasq.d/userlist

if [ -d "/jffs/configs/dnsmasq.d" ]; then
	echo -e "\e[1;33m �������½ű� \e[0m\n"
	wget --no-check-certificate -t 30 -T 60 https://github.com/wz161996/6300v2/blob/master/tmp_hsfq_update.sh -qO /tmp/tmp_hsfq_update.sh
	mv -f /tmp/tmp_hsfq_update.sh /jffs/configs/dnsmasq.d/hsfq_update.sh && sleep 3
	chmod 755 /jffs/configs/dnsmasq.d/hsfq_update.sh
fi

echo -e "\e[1;36m ���� DNS �����ļ� \e[0m\n"
if [ ! -f "/jffs/configs/dnsmasq.d/resolv.conf" ]; then
	cat > /jffs/configs/dnsmasq.d/resolv.conf 
<<EOF
## DNS��������������
nameserver 127.0.0.1
## �������绷��ѡ��DNS.���6����ַ��������
nameserver 223.6.6.6
nameserver 176.103.130.131
nameserver 114.114.114.114
nameserver 119.29.29.29
nameserver 8.8.4.4
EOF
fi
chmod 644 /jffs/configs/dnsmasq.d/resolv.conf && chmod 644 /etc/resolv.conf
cp -f /jffs/configs/dnsmasq.d/resolv.conf /tmp/resolv.conf
sed -i "/#/d" /tmp/resolv.conf;mv -f /tmp/resolv.conf /etc/resolv.conf

if [ ! -d "/jffs/configs/dnsmasq.d/conf" ]; then
	echo -e "\e[1;36m ���� 'FQ' �ļ� \e[0m\n"
	mkdir -p /jffs/configs/dnsmasq.d/conf
	echo "address=/localhost/127.0.0.1" > /jffs/configs/dnsmasq.d/conf/hosts_fq.conf && chmod 644 /jffs/configs/dnsmasq.d/conf/hosts_fq.conf
fi

if [ ! -d "/jffs/configs/dnsmasq.d/hosts" ]; then
	echo -e "\e[1;36m ���� 'HOSTS' �ļ� \e[0m\n"
	mkdir -p /jffs/configs/dnsmasq.d/hosts
	echo "127.0.0.1 localhost" > /jffs/configs/dnsmasq.d/hosts/hosts_ad.conf && chmod 644 /jffs/configs/dnsmasq.d/hosts/hosts_ad.conf
fi

echo -e "\e[1;36m �����Զ���������� \e[0m\n"
if [ ! -f "/jffs/configs/dnsmasq.d/blacklist" ]; then
	cat > "/jffs/configs/dnsmasq.d/blacklist" <<EOF
# ����������ӹ�������
# ÿ������Ҫ���ι����ַ����http://����
active.admore.com.cn
g.163.com
mtty-cdn.mtty.com
static-alias-1.360buyimg.com
image.yzmg.com
files.jb51.net/image
common.jb51.net/images
du.ebioweb.com/ebiotrade/web_images
www.37cs.com
fuimg.com
sinaimg.cn
ciimg.com
pic.iidvd.com
cnzz.com
statis.api.3g.youku.com
ad.m.qunar.com
lives.l.aiseet.atianqi.com
# ��Ӫ��ip�ٳ�
120.197.89.239
211.139.178.49
221.179.46.190
221.179.46.193
221.179.46.194
60.19.29.21
60.19.29.24
61.174.50.168
# ���IP�ٳ�
47.89.59.182
106.75.65.90
114.55.123.44
122.225.103.120
123.59.78.229
139.224.26.92
222.186.61.97
222.187.226.96
23.235.156.167
101.201.29.182
EOF
fi
chmod 644 /jffs/configs/dnsmasq.d/blacklist

echo -e "\e[1;36m �����Զ���������� \e[0m\n"
if [ ! -f "/jffs/configs/dnsmasq.d/whitelist" ]; then
	cat > "/jffs/configs/dnsmasq.d/whitelist" <<EOF
# �뽫��ɱ����ַ��ӵ������������
# ÿ��������Ӧ׼ȷ����ַ��ؼ��ʼ���:
m.baidu.com
github.com
raw.githubusercontent.com
my.k2
tv.sohu.com
toutiao.com
jd.com
tejia.taobao.com
temai.taobao.com
ai.m.taobao.com
ai.taobao.com
re.taobao.com
shi.taobao.com
s.click.taobao.com
s.click.tmall.com
ju.taobao.com
dl.360safe.com
down.360safe.com
fd.shouji.360.cn
zhushou.360.cn
shouji.360.cn
hot.m.shouji.360tpcdn.com
EOF
fi
chmod 644 /jffs/configs/dnsmasq.d/whitelist

if [ -f "/jffs/configs/dnsmasq.d/cron/crontabs/$username" ]; then
	echo -e "\e[1;33m ��Ӷ�ʱ�ƻ��������� \e[0m\n"
	sed -i '/hsfq_update.sh/d' /jffs/configs/dnsmasq.d/cron/crontabs/$username
	sed -i '$a 30 5 * * * sh /jffs/configs/dnsmasq.d/hsfq_update.sh &' /jffs/configs/dnsmasq.d/cron/crontabs/$username
	sleep 2 && killall crond;/usr/sbin/crond
fi

echo -e "\e[1;36m ����Զ��� hosts ����·�� \e[0m\n"
[ -f /var/log/dnsmasq.log ] && rm /var/log/dnsmasq.log
[ -f /tmp/tmp_dnsmasq ] && rm /tmp/tmp_dnsmasq
if [ ! -f "/jffs/configs/dnsmasq.d/dnsmasq/dnsmasq.conf" ]; then
	wget --no-check-certificate -t 20 -T 50 https://github.com/wz161996/6300v2/blob/master/tmp_dnsmasq -qO /tmp/tmp_dnsmasq
	chmod 777 /tmp/tmp_dnsmasq && sh /tmp/tmp_dnsmasq
else
	grep "conf-dir" /jffs/configs/dnsmasq.d/dnsmasq/dnsmasq.conf
	if [ $? -eq 0 ]; then
		sed -i '/127.0.0.1/d' /jffs/configs/dnsmasq.d/dnsmasq/dnsmasq.conf
		sed -i '/log/d' /jffs/configs/dnsmasq.d/dnsmasq/dnsmasq.conf
		sed -i '/1800/d' /jffs/configs/dnsmasq.d/dnsmasq/dnsmasq.conf
		sed -i '/conf-dir/d' /jffs/configs/dnsmasq.d/dnsmasq/dnsmasq.conf
	else
		echo -e "\033[41;37m ��ʼд���������� \e[0m\n"
		echo "listen-address=${route_vlan},127.0.0.1
# ��Ӽ�����ַ
# ������־ѡ��
log-queries
log-facility=/var/log/dnsmasq.log
# �첽log,����������������ܡ�Ĭ��Ϊ5�����Ϊ100
log-async=50
# �����ʱ��
#min-cache-ttl=1800
# ָ��������'����''��ַ'�ļ���
conf-dir=/jffs/configs/dnsmasq.d/conf
# conf-file=/jffs/configs/dnsmasq.d/conf/hosts_fq.conf" >> /tmp/tmp_dnsmasq.conf
		cat /tmp/tmp_dnsmasq.conf | sed -E -e "/#/d" >> /jffs/configs/dnsmasq.d/dnsmasq/dnsmasq.conf;sleep 3
		rm /tmp/tmp_dnsmasq.conf
	fi
fi

if [ -f "/jffs/configs/dnsmasq.d/post_iptables_script.sh" ]; then
	echo -e "\e[1;36m ��ӷ���ǽ�˿�ת������ \e[0m\n"
	sed -i '/DNAT/d' /jffs/configs/dnsmasq.d/post_iptables_script.sh
	sed -i '/iptables-save/d' /jffs/configs/dnsmasq.d/post_iptables_script.sh
	sed -i '$a /bin/iptables-save' /jffs/configs/dnsmasq.d/post_iptables_script.sh
fi
echo "/bin/iptables -t nat -A PREROUTING -p tcp --dport 53 -j DNAT --to $route_vlan" >> /jffs/configs/dnsmasq.d/post_iptables_script.sh
echo "/bin/iptables -t nat -A PREROUTING -p udp --dport 53 -j DNAT --to $route_vlan" >> /jffs/configs/dnsmasq.d/post_iptables_script.sh
if [ -f "/jffs/configs/dnsmasq.d/post_iptables_script.sh" ]; then
	sed -i '/resolv.conf/d' /jffs/configs/dnsmasq.d/post_iptables_script.sh
	sed -i '/restart_dhcpd/d' /jffs/configs/dnsmasq.d/post_iptables_script.sh
	sed -i '$a cp -f /jffs/configs/dnsmasq.d/resolv.conf /tmp/resolv.conf' /jffs/configs/dnsmasq.d/post_iptables_script.sh
	sed -i '$a sed -i "/#/d" /tmp/resolv.conf;mv -f /tmp/resolv.conf /etc/resolv.conf' /jffs/configs/dnsmasq.d/post_iptables_script.sh
	sed -i '$a restart_dhcpd' /jffs/configs/dnsmasq.d/post_iptables_script.sh
fi

if [ -f "/jffs/configs/dnsmasq.d/hsfq_update.sh" ]; then
	echo -e -n "\033[41;37m ��ʼ���ط�ǽ�ű��ļ�......\033[0m\n"
	sh /jffs/configs/dnsmasq.d/hsfq_update.sh
fi

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+                 installation is complete                 +"
echo "+                                                          +"
echo "+                     Time:`date +'%Y-%m-%d'`                      +"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
sleep 3
rm -rf /tmp/hsfq_script.sh
[ ! -f "/tmp/hsfq_install" ] && exit 0
sh /tmp/hsfq_install
