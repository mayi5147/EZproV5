#!/bin/bash
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
# DIY扩展二合一了，在此处可以增加插件
# 自行拉取插件之前请SSH连接进入固件配置里面确认过没有你要的插件再单独拉取你需要的插件
# 不要一下就拉取别人一个插件包N多插件的，多了没用，增加编译错误，自己需要的才好
# 修改IP项的EOF于EOF之间请不要插入其他扩展代码，可以删除或注释里面原本的代码
# 如果你的OP是当主路由的话，网关、DNS、广播都不需要，代码前面加 # 注释掉，只保留后台地址和子网掩码就可以
# 如果你有编译ipv6的话，‘去掉LAN口使用内置的 IPv6 管理’代码前面也加 # 注释掉



cat >$NETIP <<-EOF
uci set network.lan.ipaddr='192.168.101.1'                                    # IPv4 地址(openwrt后台地址)
uci set network.lan.netmask='255.255.255.0'                                 # IPv4 子网掩码
uci set network.lan.delegate='0'                                            # 去掉LAN口使用内置的 IPv6 管理
uci set dhcp.@dnsmasq[0].filter_aaaa='1'                                # 禁止解析 IPv6 DNS记录(若用IPV6请把'1'改'0')
uci set system.@system[0].hostname='EZproV5'                            # 修改主机名称为OpenWrt-123
EOF


# 把bootstrap替换成argon为源码必选主题（可自行修改您要的,主题名称必须对,比如下面代码的[argon],源码内必须有该主题,要不然编译失败）
sed -i "s/bootstrap/argon/ig" feeds/luci/collections/luci/Makefile


# 增加个性名字 ${Author} 默认为你的github帐号
sed -i "s/OpenWrt /EZProV5 by OpenWrt /g" "$ZZZ_PATH"      


# 删除默认防火墙
sed -i '/to-ports 53/d' "$ZZZ_PATH"


# 取消路由器每天跑分任务
sed -i "/exit 0/i\sed -i '/coremark/d' /etc/crontabs/root" "$FIN_PATH"


# 修改默认内核（所有机型都适用，只要您编译的机型源码附带了其他内核，请至编译说明的第12条查看）
#sed -i 's/PATCHVER:=5.15/PATCHVER:=5.10/g' target/linux/x86/Makefile


# 修改插件名字
sed -i 's/"实时流量监测"/"流量"/g' `grep "实时流量监测" -rl ./`
sed -i 's/"KMS 服务器"/"KMS激活"/g' `grep "KMS 服务器" -rl ./`


# 整理固件包时候,删除您不想要的固件或者文件,让它不需要上传到Actions空间
cat >${GITHUB_WORKSPACE}/Clear <<-EOF
rm -rf config.buildinfo
rm -rf feeds.buildinfo
rm -rf openwrt-x86-64-generic-kernel.bin
rm -rf openwrt-x86-64-generic.manifest
rm -rf openwrt-x86-64-generic-squashfs-rootfs.img.gz
rm -rf sha256sums
rm -rf version.buildinfo
EOF
