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
sed -i 's|../../luci.mk|$(TOPDIR)/feeds/luci/luci.mk|g' package/luci-app-msd_lite/Makefile

# ------------------------------------------------------------------
# 4. 回退 PassWall 依赖仓库到 Go 26.x 兼容的版本 (Commit: dbd89ac)
# ------------------------------------------------------------------
if [ -d "package/passwall-packages" ]; then
  echo "==> 正在将 package/passwall-packages 回退至 Sep 8, 2026 (dbd89ac)..."
  cd package/passwall-packages
  git fetch --unshallow 2>/dev/null || git fetch --depth=100 2>/dev/null
  git checkout dbd89ac
  echo "==> passwall-packages 当前版本:"
  git log -1 --oneline
  cd - >/dev/null
fi

if [ -d "package/passwall-luci" ]; then
  echo "==> 正在将 package/passwall-luci 回退至 Sep 8, 2026 (dbd89ac)..."
  cd package/passwall-luci
  git fetch --unshallow 2>/dev/null || git fetch --depth=100 2>/dev/null
  git checkout dbd89ac
  echo "==> passwall-luci 当前版本:"
  git log -1 --oneline
  cd - >/dev/null
fi
