#!/bin/bash
#=================================================
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#=================================================

# 单独拉取软件包
git clone -b default-19.07-Development https://github.com/yuos-bit/other package/default-settings
git clone -b main-19.07 https://github.com/yuos-bit/other package/yuos

# nft-fullcone（可选，建议先保留，编译失败再注释）
git clone -b main --single-branch https://github.com/fullcone-nat-nftables/nftables-1.0.5-with-fullcone package/nftables
git clone -b master --single-branch https://github.com/fullcone-nat-nftables/libnftnl-1.2.4-with-fullcone package/libnftnl

# 测试编译时间
YUOS_DATE="$(date +%Y.%m.%d)(Development)"
BUILD_STRING=${BUILD_STRING:-$YUOS_DATE}
echo -e '\nyuos Build @ '${BUILD_STRING}'\n'  >> package/base-files/files/etc/banner
sed -i '/DISTRIB_REVISION/d' package/base-files/files/etc/openwrt_release
echo "DISTRIB_REVISION=''" >> package/base-files/files/etc/openwrt_release
sed -i '/DISTRIB_DESCRIPTION/d' package/base-files/files/etc/openwrt_release
echo "DISTRIB_DESCRIPTION='yuos Build @ ${BUILD_STRING}'" >> package/base-files/files/etc/openwrt_release

# 修改 luci version.lua
sed -i '/luciversion/d' feeds/luci/modules/luci-base/luasrc/version.lua
echo "luciversion = '${BUILD_STRING}'" >> feeds/luci/modules/luci-base/luasrc/version.lua

# ==================== 以下两段暂时注释，优先保证编译成功 ====================
#升级cmake
#find . -type d -name "cmake" -exec rm -r {} +
#mkdir -p tools/cmake/
#cp -rf $GITHUB_WORKSPACE/patchs/4.14/tools/cmake/* tools/cmake/

#升级golang（19.07 不建议升级，容易失败）
#find . -type d -name "golang" -exec rm -r {} +
#rm -rf feeds/packages/lang/golang
#git clone https://github.com/sbwml/packages_lang_golang -b 20.x feeds/packages/lang/golang
# =======================================================================
