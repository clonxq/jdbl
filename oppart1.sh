#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
function extract_pkg() {
    local repo_url="$1"
    local repo_path="$2"
    local local_path="$3"
    local branch="$4"
    local tmp_dir="tmp_extract_$(date +%s%N)"

    # --- 自动检测默认分支逻辑 ---
    if [ -z "$branch" ]; then
        echo ">>> 正在自动检测远程默认分支..."
        # 获取远程 HEAD 指向的分支名，例如：ref: refs/heads/main  HEAD
        branch=$(git ls-remote --symref "$repo_url" HEAD | awk '/^ref:/ {sub(/.*\/heads\//, "", $2); print $2}')
        # 如果获取失败（极少数情况），回退到 main
        branch="${branch:-main}"
    fi
    # --------------------------

    echo ">>> 正在提取: $repo_path (分支: $branch)"
    
    # 使用 --filter=blob:none 和 --sparse 极速克隆
    git clone --depth 1 --filter=blob:none --sparse -b "$branch" "$repo_url" "$tmp_dir"
    
    if [ $? -eq 0 ]; then
        pushd "$tmp_dir" > /dev/null
        git sparse-checkout set "$repo_path"
        popd > /dev/null
        
        mkdir -p "$(dirname "$local_path")"
        [ -d "$local_path" ] && rm -rf "$local_path"
        
        if [ -d "$tmp_dir/$repo_path" ]; then
            cp -r "$tmp_dir/$repo_path" "$local_path"
            echo ">>> 成功保存至: $local_path"
        else
            echo ">>> [错误] 未在仓库中找到路径: $repo_path"
        fi
    else
        echo ">>> [错误] Git 克隆失败: $repo_url"
    fi
    
    rm -rf "$tmp_dir"
}

# --- 使用示例 ---
# 移植 immortalwrt 25.12 分支的插件
# extract_pkg "https://github.com/immortalwrt/luci" "applications/luci-app-eqos" "package/luci-app-eqos" "openwrt-25.12"

git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git package/passwall-packages
git clone https://github.com/Openwrt-Passwall/openwrt-passwall.git package/passwall-luci
git clone https://github.com/nikkinikki-org/OpenWrt-nikki.git package/OpenWrt-nikki
git clone https://github.com/tty228/luci-app-wechatpush.git package/luci-app-wechatpush
git clone  https://github.com/gdy666/luci-app-lucky.git package/lucky
git clone https://github.com/sirpdboy/luci-app-advanced.git package/luci-app-advanced
find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
find ./ | grep Makefile | grep mosdns | xargs rm -f
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
git clone https://github.com/sirpdboy/luci-app-adguardhome package/luci-app-adguardhome
extract_pkg "https://github.com/kenzok8/openwrt-packages" "adguardhome" "package/adguardhome"
extract_pkg "https://github.com/vernesong/OpenClash" "luci-app-openclash" "package/luci-app-openclash"
extract_pkg "https://github.com/timsaya/luci-app-bandix" "luci-app-bandix" "package/luci-app-bandix"
extract_pkg "https://github.com/timsaya/openwrt-bandix" "openwrt-bandix" "package/openwrt-bandix"
extract_pkg "https://github.com/immortalwrt/luci" "applications/luci-app-msd_lite" "package/luci-app-msd_lite" "openwrt-25.12"
extract_pkg "https://github.com/immortalwrt/packages" "net/msd_lite" "package/msd_lite" "openwrt-25.12"
