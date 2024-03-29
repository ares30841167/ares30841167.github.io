---
title: 【隨手筆記】Shell中的特殊變數
categories:
  - 隨手筆記
tags:
  - 隨手筆記
  - Linux
  - Shell
  - Shell Script
  - 特殊變數
date: 2022-02-06 21:08:10
---
在看網路上的教學文章時，有時會看到一些看起來很酷的Shell Script寫法，其中常常包含一些$當作prefix的特殊變數，這篇就記錄一下Shell Script中的特殊變數以及其代表意義。

| 變數 | 含意                                                                                          |
|:----:|-----------------------------------------------------------------------------------------------|
| $0   | 當前腳本的文件名                                                                              |
| $n   | 傳遞給腳本或函數的參數。 n 是一個數字，表示第幾個參數。例如，第一個參數是$1，第二個參數是$2。 |
| $#   | 傳遞給腳本或函數的參數個數。                                                                  |
| $@   | 傳遞給腳本或函數的所有參數。                                                                  |
| $?   | 上個命令的退出狀態，或函數的返回值。                                                          |
| $$   | 當前Shell進程ID。                                                                             |