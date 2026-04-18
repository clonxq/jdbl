#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
sed -i 's/192\.168\.[0-9]*\.1/192.168.5.1/g' package/base-files/files/bin/config_generate
##-----------------Del duplicate packages------------------
rm -rf feeds/packages/net/open-app-filter
rm -rf package/diy/passwall-packages/shadowsocks*
rm -rf feeds/packages/net/shadowsocks*
rm -rf ./feeds/packages/net/adguardhome
rm -rf ./feeds/packages/net/mosdns
rm -rf feeds/luci/applications/luci-app-ssr-plus
rm -rf feeds/luci/applications/luci-app-wechatpush
rm -rf feeds/luci/applications/luci-app-vssr
rm -rf feeds/luci/applications/luci-app-ddns-go
##-----------------Manually set CPU frequency for MT7986A-----------------
rm -rf feeds/packages/net/{xray-core,v2ray-geodata,sing-box,chinadns-ng,dns2socks,hysteria,ipt2socks,microsocks,naiveproxy,shadowsocks-libev,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,trojan-plus,tuic-client,v2ray-plugin,xray-plugin,geoview,shadow-tls}
rm -rf feeds/luci/applications/luci-app-passwall

rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 26.x feeds/packages/lang/golang
