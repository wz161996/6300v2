#!/bin/sh
# Compile:by-lanse  2017-08-28
LOGTIME=$(date "+%m-%d %H:%M:%S")


echo " 检测安装脚本版本 "
if [ ! -f /tmp/hsfq_script_up.sh ]; then
	wget --no-check-certificate https://github.com/wz161996/6300v2/blob/master/hsfq_script.sh -O /tmp/hsfq_script_up.sh;chmod 775 /tmp/hsfq_script_up.sh
	cat /tmp/hsfq_script_up.sh /jffs/configs/dnsmasq.d/hsfq_script.sh | awk '{ print$0}' | sort | uniq -u > /tmp/hsfq_script_up.txt && sleep 2
	if [ ! -s "/tmp/hsfq_script_up.txt" ]; then
		echo -e "\e[1;33m HSFQ 安装脚本已为最新,无需更新.\e[0m\n" && rm -f /tmp/hsfq_script_up.sh && rm -f /tmp/hsfq_script_up.txt
	else
		rm -f /jffs/configs/dnsmasq.d/hsfq_script.sh
		cp -f /tmp/hsfq_script_up.sh /jffs/configs/dnsmasq.d/hsfq_script.sh
		mv -f /tmp/hsfq_script_up.sh /tmp/hsfq_script.sh && rm -f hsfq_script_up.txt
		echo -e "\033[41;37m安装脚本更新完成.开始运行\033[0m\n" && sleep 3
		sh /tmp/hsfq_script.sh
	fi
fi
if [ -x "/jffs/configs/dnsmasq.d/hsfq_update.sh" ]; then
	logger -t "【$LOGTIME】" " 开始运行翻墙去广告更新任务..."
	[ -f /tmp/tmp_fq_up ] && rm -f /tmp/tmp_fq_up
	[ -f /tmp/tmp_hs_up ] && rm -f /tmp/tmp_hs_up
	# 准备翻墙 FQ 文件
	wget --no-check-certificate -t 10 -T 30 https://github.com/wz161996/6300v2/blob/master/tmp_fq_up -qO /tmp/tmp_fq_up && chmod 755 /tmp/tmp_fq_up && . /tmp/tmp_fq_up
	sleep 2
fi
if [ -x "/jffs/configs/dnsmasq.d/hsfq_update.sh" ]; then
	# 准备去广告 HOSTS 文件
	wget --no-check-certificate -t 10 -T 30 https://github.com/wz161996/6300v2/blob/master/tmp_hs_up -qO /tmp/tmp_hs_up && chmod 755 /tmp/tmp_hs_up && . /tmp/tmp_hs_up
	restart_dhcpd && /usr/sbin/dnsmasq restart 2>&1 >/dev/null
fi
sleep 3 && exit 0

