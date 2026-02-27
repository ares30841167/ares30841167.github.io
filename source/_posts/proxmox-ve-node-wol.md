---
title: 【隨手筆記】Proxmox VE 9 WoL 關機失效問題
categories:
  - 隨手筆記
tags:
  - 隨手筆記
  - Proxmox VE
  - WoL
hidden: false
date: 2026-02-27 22:23:13
---
# 前言
嗯，距離上次發文已經是2024年9月的事情了，荒廢了一年多之久...(笑

咳咳!回到正題，會有這篇筆記的出現，主要也是要繼續來補【Kubernetes學習筆記】系列了，從2022年挖坑，到今年2026年我都讀完碩班開始第二份工作了，坑都還沒繼續填，居然可以拖四年阿!

這次為了繼續當年的【Kubernetes學習筆記】系列，我重新架設了筆記上所開出的Kubernetes群集架構。架構上與當年寫下的基本一致，唯獨這次沒有再重新架設以兩套HA Proxy做高可用版本的LB於Master Node前，只起了一顆HA Proxy擔任Control Plane的LB，並且CNI這次選用了Calico。

其餘部分還是留到筆記系列的續篇正文再繼續說明吧，主要是這次選擇使用Proxmox VE環境當作底層的Bare-metal Hypervisor解決方案來開VM架設集群，而主機架設在遠端，我需要透過WoL的方式來喚醒它。

該電腦本身就已經啟用過WoL的相關設定，且透過Windows啟動並關機後，是可以正常WoL的。但是這次遇到了Proxmox VE關機後，NIC會被完全切斷電源，與Router於實體物理的層面上斷線。

本篇就是要來解決上面所述問題，在Proxmox VE Node的設定上需要做一些調整~

<!-- more -->
# 正文
接下來就實際紀錄解決步驟

主要的原因在於OS層級網卡上的WoL功能沒有啟用，為d (Disabled)這狀態，詳細的資訊可以透過`ethtool <nic-name>`來查看。
![ethtool-details](/proxmox-ve-node-wol/ethtool-details.png)

可以看到列出的詳細資訊內，有欄Wake-on狀態，上圖示已經調整過後的截圖，原先是顯示d，表示停用，所以我們需要將它改成啟用的狀態g (MagicPacket)。

該欄會出現的狀態指示根據ethtool的[使用手冊](https://man7.org/linux/man-pages/man8/ethtool.8.html)說明，有下列可能，供大家參考:
```bash
wol p|u|m|b|a|g|s|d...
          Set Wake-on-LAN options.  Not all  devices  support  this.   The
          argument  to  this  option  is a string of characters specifying
          which options to enable.
          p  Wake on phy activity
          u  Wake on unicast messages
          m  Wake on multicast messages
          b  Wake on broadcast messages
          a  Wake on ARP
          g  Wake on MagicPacket(tm)
          s  Enable SecureOn(tm) password for MagicPacket(tm)
          d  Disable (wake on nothing).  This option clears  all  previous
             options.
```

在網卡可寫入並儲存設定的情況下，只需要下`ethtool -s <nic-name> wol g`便可將其啟用狀態更改為g。

但經過測試後發現，我的網卡調整過後，第一次關機能夠維持WoL功能，但待下次重新啟動系統後，WoL便會回復原始的停用狀態，無法持久化設定。

所以我透過新增system daemon的方式來在每次系統啟動時，自動套用`ethtool -s <nic-name> wol g`指令，使得每次系統關機前，WoL都是維持在運作的g狀態。

1. 透過`nano /etc/systemd/system/enable-wol.service`創建名為enable-wol.service的system daemon設定檔
檔案內容如下，<nic-name>請替換為你的網卡名稱
```bash
[Unit]
Description=Wake-on-LAN for <nic-name>          
Requires=network.target
After=network.target

[Service]
ExecStart=/usr/sbin/ethtool -s <nic-name> wol g
ExecStop=/usr/sbin/ethtool -s <nic-name> wol g

[Install]
WantedBy=multi-user.target
```

2. 使服務開機自動啟動執行
```bash
systemctl enable enable-wol.service
systemctl daemon-reload
```

透過上述方法，便可確保每次系統重啟後，都能正確於OS層級啟用網卡WoL功能，解決無法正常WoL的問題。
