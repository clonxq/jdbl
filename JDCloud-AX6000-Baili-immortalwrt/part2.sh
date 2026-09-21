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
#修改默认IP地址
sed -i 's/192\.168\.[0-9]*\.1/192.168.5.1/g' package/base-files/files/bin/config_generate

##-----------------Del duplicate packages------------------
rm -rf feeds/luci/applications/open-app-filter
rm -rf feeds/luci/applications/luci-app-wrtbwmon
rm -rf feeds/luci/applications/luci-app-wechatpush
rm -rf feeds/luci/applications/luci-app-openclash
rm -rf feeds/luci/applications/luci-app-ssr-plus
rm -rf feeds/packages/net/wrtbwmon
rm -rf feeds/packages/net/adguardhome
rm -rf feeds/packages/net/mosdns
# rm -rf ./feeds/packages/net/shadowsocks-libev
# rm -rf ./feeds/packages/net/shadowsocks-rust
# rm -rf ./feeds/packages/net/shadowsocksr-libev
rm -rf feeds/packages/net/{xray-core,v2ray-geodata,sing-box,chinadns-ng,dns2socks,hysteria,ipt2socks,microsocks,naiveproxy,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,v2ray-plugin,xray-plugin,geoview,shadow-tls}
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 27.x feeds/packages/lang/golang
#修复Rust编译失败
sed -i 's/ci-llvm=true/ci-llvm=false/g' feeds/packages/lang/rust/Makefile

# 1. 删除 feeds 中自带的旧版 argon 主题与配置插件
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/applications/luci-app-argon-config

# 2. 清理 package 或 feeds 目录下可能存在的其他同名残留
find package/ feeds/ -maxdepth 5 -type d -name "luci-theme-argon" | xargs rm -rf
find package/ feeds/ -maxdepth 5 -type d -name "luci-app-argon-config" | xargs rm -rf

# 3. 克隆 JerryKuku 官方最新 18.06 分支到 package 目录
git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config
