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
rm -rf feeds/packages/net/wrtbwmon
rm -rf feeds/packages/net/adguardhome
rm -rf feeds/packages/net/mosdns
# rm -rf ./feeds/packages/net/shadowsocks-libev
# rm -rf ./feeds/packages/net/shadowsocks-rust
# rm -rf ./feeds/packages/net/shadowsocksr-libev
rm -rf feeds/luci/applications/luci-app-ssr-plus
rm -rf feeds/packages/net/{xray-core,v2ray-geodata,sing-box,chinadns-ng,dns2socks,hysteria,ipt2socks,microsocks,naiveproxy,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,v2ray-plugin,xray-plugin,geoview,shadow-tls}
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 26.x feeds/packages/lang/golang
#修复Rust编译失败
sed -i 's/ci-llvm=true/ci-llvm=false/g' feeds/packages/lang/rust/Makefile

# ------------------------------------------------------------------
# 修改 xray-core 的 go.mod，将 Go 版本限制从 1.27 改回 1.26
# ------------------------------------------------------------------
find package/ feeds/ -type f -path "*/xray-core/Makefile" | while read -r makefile; do
  XRAY_SRC_DIR=$(dirname "$makefile")
  # 查找并修改该包下的 go.mod 文件（无论是在源码包还是构建目录）
  find "$XRAY_SRC_DIR" -name "go.mod" -exec sed -i 's/go 1.27/go 1.26/g' {} +
done
