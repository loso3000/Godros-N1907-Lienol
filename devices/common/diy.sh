#!/bin/bash
#=================================================
# Description: Build OpenWrt using GitHub Actions 
# Lisence: MIT
# 参考以下资料：
# Frome: https://github.com/garypang13/Actions-OpenWrt
# Frome: https://github.com/P3TERX/Actions-OpenWrt
# Frome: https://github.com/Lienol/openwrt-actions
# Frome: https://github.com/svenstaro/upload-release-action
# By LEDE 2020 https://ledewrt.com
# https://github.com/ledewrt
#=================================================
#添加固件版本描述。
rm -Rf package/lean/luci-app-ssr-plus
rm -Rf package/diy/OpenAppFilter
rm -Rf package/diy/luci-app-adguardhome
# 修改登陆地址
sed -i 's/192.168.1.1/192.168.168.1/g' package/base-files/files/bin/config_generate
# 关闭禁止解析IPv6 DNS 记录
sed -i '/option filter_aaaa 1/d' package/network/services/dnsmasq/files/dhcp.conf

#修改网络连接数
#sed -i 's/net.netfilter.nf_conntrack_max=65535/net.netfilter.nf_conntrack_max=105535/g' package/kernel/linux/files/sysctl-nf-conntrack.conf
#添加自定义插件1。
git clone https://github.com/vernesong/OpenClash.git package/diy/luci-app-openclash
git clone https://github.com/garypang13/openwrt-adguardhome.git package/diy/openwrt-adguardhome
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git  package/diy/luci-app-adguardhome
sed -i '/resolvfile=/d' package/diy/luci-app-adguardhome/root/etc/init.d/AdGuardHome
sed -i 's/DEPENDS:=/DEPENDS:=+AdGuardHome /g' package/diy/luci-app-adguardhome/Makefile
#argon主题
#git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/diy/luci-theme-argon
git clone https://github.com/sirpdboy/luci-theme-opentopd.git package/luci-theme-opentopd

git clone https://github.com/godros/luci-app-eqos.git package/diy/luci-app-eqos
git clone https://github.com/godros/luci-app-igodproxy.git package/diy/luci-app-godproxy
git clone https://github.com/tty228/luci-app-serverchan.git package/diy/luci-app-serverchan
#git clone https://github.com/destan19/OpenAppFilter.git package/diy/OpenAppFilter
git clone https://github.com/Lienol/openwrt-OpenAppFilter.git package/diy/OpenAppFilter
#git clone https://github.com/fw876/helloworld.git package/diy/luci-app-ssr-plus
#git clone https://github.com/docker/docker-ce.git package/diy/luci-app-docker-ce
git clone https://github.com/jerrykuku/luci-app-jd-dailybonus.git package/diy/luci-app-jd-dailybonus  #京东签到
#git clone https://github.com/tohojo/sqm-scripts.git package/diy/sqm-scripts
git clone https://github.com/siwind/luci-app-ttyd.git package/diy/luci-app-ttyd
git clone https://github.com/awesome-openwrt/luci-app-control-mia package/luci-app-control-mia

git clone https://github.com/garypang13/luci-app-dnsfilter.git package/diy/luci-app-dnsfilter

svn co https://github.com/godros/openwrt-app/trunk/luci-app-uugamebooster package/diy/luci-app-uugamebooster
svn co https://github.com/godros/openwrt-app/trunk/luci-app-ttnode package/diy/luci-app-ttnode

svn export --force https://github.com/godros/openwrt-app/branches/luci19/luci-app-dockerman  package/diy/luci-app-dockerman
svn export --force https://github.com/godros/openwrt-app/branches/luci19/docker-ce  package/diy/
svn export --force https://github.com/godros/openwrt-app/branches/luci19/luci-lib-docker  package/diy/
svn export --force https://github.com/godros/openwrt-app/branches/luci19/luci-compat package/diy/


#cd package克隆passwall
#git clone https://github.com/xiaorouji/openwrt-passwall.git package/diy/
#cd -
./scripts/feeds update -a
./scripts/feeds install -a

# 内核显示增加自己个性名称
date=`date +%d.%m.%Y`
sed -i "s/DISTRIB_DESCRIPTION.*/DISTRIB_DESCRIPTION='GodROS N%C From Lienol OpenWrt %V'/g" package/base-files/files/etc/openwrt_release
sed -i "s/# REVISION:=x/REVISION:= $date/g" include/version.mk
