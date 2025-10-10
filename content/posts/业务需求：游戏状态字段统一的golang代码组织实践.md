---
title: "业务需求：游戏状态字段统一的golang代码组织实践"
author: ""
authorAvatarPath: ""
date: "2025-10-09"
summary: "n-n状态转换" # 用于列表页展示文章简介
description: "" # 与summary 貌似作用相同，可忽略
toc: true
readTime: false
autonumber: false
math: true
tags: ["blog", "note"]
showTags: false
hideBackToTop: false
fediverse: "liangliang.too@gmail.com"
draft: false  # 是否草稿
---





## 需求内容与背景

当前公司有三个后台（app, sdk, developer），每个后台有各自的游戏表对游戏数据进行管理。

但当前每个平台的状态字段定义不一，且每个状态字段控制的内容似有重复冗余。所以当前需求，希望通过**统一游戏状态**，来管理游戏在APP/SDK中的显示引导与下载能力。

### 三个平台的游戏关系描述：

* **app后台**

  * 同时管理android, ios 端游戏

    * 如果是ios端游戏，只在本平台进行管理

  * sdk后台创建游戏后，会同步到app后台，反之不然

    * 如果

  * 对dev后台游戏配置数据进行审核

  * 在本后台修改游戏，会同步到其余两个平台

    

* **sdk后台**，管理android 游戏

  * 创建，修改，会同步到其余两个后台

    

* **developer开发者后台（第三方管理）**，游戏来源是 sdk 中创建游戏后，同步到本后台

  * 只涉及android端游戏
  * 与sdk 后台游戏有强关联



#### 当前主要状态字段列举：

* **app-game**

  | 字段名           | 类型     | 说明                                             | 可选值 / 含义                                                |
  | ---------------- | -------- | ------------------------------------------------ | ------------------------------------------------------------ |
  | `DownloadStatus` | `string` | 下载状态，用于控制客户端或管理端的下载功能状态。 | - `on`：开启下载- `off`：关闭下载- `reservation`：预约中- `demo_download`：试玩下载- `decommission`：预停运 |
  | `TestType`       | `string` | 测试类型，用于标识游戏/应用当前测试阶段。        | - `public_beta`：公测- `not_delete_private_beta`：不删档内测- `delete_private_beta`：删档内测 |
  | `SdkStatus`      | `string` | SDK 状态，用于描述接入或上架进度。               | - `接入中`：正在集成- `已上架`：SDK 已上线- `已下架`：SDK 已下线- `已关服`：服务已关闭- `已作废`：不再使用- `异常`：状态异常 |
  | `Status`         | string   | 游戏状态                                         | - on: 显示， off: 隐藏                                       |

* **sdk-game** 

  | 字段名     | 类型     | 说明                                      | 可选值 / 含义                                                |
  | ---------- | -------- | ----------------------------------------- | ------------------------------------------------------------ |
  | `TestType` | `string` | 测试类型，用于标识游戏/应用当前测试阶段。 | - `public_beta`：公测- `not_delete_private_beta`：不删档内测- `delete_private_beta`：删档内测 |
  | `Status`   | `string` | SDK 状态                                  | - `接入中`：正在集成- `已上架`：SDK 已上线- `已下架`：SDK 已下线- `已关服`：服务已关闭- `已作废`：不再使用- `异常`：状态异常 |

* **cp-game** 

  | 字段名     | 类型     | 说明                                      | 可选值 / 含义                                                |
  | ---------- | -------- | ----------------------------------------- | ------------------------------------------------------------ |
  | `TestType` | `string` | 测试类型，用于标识游戏/应用当前测试阶段。 | - `public_beta`：公测- `not_delete_private_beta`：不删档内测- `delete_private_beta`：删档内测 |
  | `Status`   | `string` | SDK 状态，用于描述接入或上架进度。        | - `接入中`：正在集成- `已上架`：SDK 已上线- `已下架`：SDK 已下线- `已关服`：服务已关闭- `已作废`：不再使用- `异常`：状态异常 |







## 技术选型





## 执行

### 统一字段定义

~~~go
type GameStatus string

const (
	GameStatusNone        GameStatus = ""             // 无状态
	GameStatusPending     GameStatus = "pending"      // 待上架
	GameStatusReserved    GameStatus = "reserved"     // 预约
	GameStatusPreDownload GameStatus = "pre_download" // 预下载
	GameStatusOnline      GameStatus = "online"       // 上架
	//GameStatusPreview      GameStatus = "preview"       // 开测
	GameStatusBeta        GameStatus = "beta"          // 内测
	GameStatusBetaEnd     GameStatus = "beta_end"      // 内测结束
	GameStatusStopNewUser GameStatus = "stop_new_user" // 停新增
	GameStatusPreShutdown GameStatus = "pre_shutdown"  // 预停运
	GameStatusOffline     GameStatus = "offline"       // 下架
	GameStatusShutdown    GameStatus = "shutdown"      // 停运
	GameStatusMaintenance GameStatus = "maintenance"   // 维护
	GameStatusDisabled    GameStatus = "disabled"      // 禁用
	GameStatusAbnormal    GameStatus = "abnormal"      // 游戏异常
)
~~~



