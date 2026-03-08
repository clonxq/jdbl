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

# 1. 创建 uci-defaults 脚本目录（如果不存在）
mkdir -p package/base-files/files/etc/uci-defaults/

# 2. 动态写入无线配置脚本
cat <<EOF > package/base-files/files/etc/uci-defaults/99-custom-wifi
#!/bin/sh

# 设置 2.4G (radio0)
uci set wireless.radio0.disabled='0'
uci set wireless.radio0.country='CN'
uci set wireless.radio0.band='2g'
uci set wireless.radio0.channel='6'
uci set wireless.radio0.htmode='HE20'
# 修改 2.4G 接口配置 (使用索引 [0] 适配不同接口名)
uci set wireless.@wifi-iface[0].ssid='Q30-2G'
uci set wireless.@wifi-iface[0].encryption='psk2+ccmp'
uci set wireless.@wifi-iface[0].key='123456789'

# 设置 5G (radio1)
uci set wireless.radio1.disabled='0'
uci set wireless.radio1.country='CN'
uci set wireless.radio1.band='5g'
uci set wireless.radio1.channel='36'
uci set wireless.radio1.htmode='HE160'
# 修改 5G 接口配置 (使用索引 [1] 适配不同接口名)
uci set wireless.@wifi-iface[1].ssid='Q30-5G'
uci set wireless.@wifi-iface[1].encryption='psk2+ccmp'
uci set wireless.@wifi-iface[1].key='123456789'

uci commit wireless
exit 0
EOF

# 3. 赋予脚本执行权限（非常关键，否则开机不运行）
chmod +x package/base-files/files/etc/uci-defaults/99-custom-wifi
##-----------------Del duplicate packages------------------
rm -rf feeds/packages/net/open-app-filter
rm -rf package/feeds/luci/luci-app-wrtbwmon
rm -rf package/feeds/luci/luci-app-wechatpush
rm -rf package/feeds/packages/wrtbwmon
rm -rf ./feeds/packages/net/adguardhome
rm -rf ./feeds/packages/net/mosdns
# rm -rf ./feeds/packages/net/shadowsocks-libev
# rm -rf ./feeds/packages/net/shadowsocks-rust
# rm -rf ./feeds/packages/net/shadowsocksr-libev
rm -rf ./feeds/luci/applications/luci-app-ssr-plus
rm -rf feeds/packages/net/{xray-core,v2ray-geodata,sing-box,chinadns-ng,dns2socks,hysteria,ipt2socks,microsocks,naiveproxy,shadowsocks-libev,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,trojan-plus,tuic-client,v2ray-plugin,xray-plugin,geoview,shadow-tls}
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 25.x feeds/packages/lang/golang
#修复Rust编译失败
sed -i 's/ci-llvm=true/ci-llvm=false/g' feeds/packages/lang/rust/Makefile
