# 快捷键

`Mod` 就是 Super（Win 键）。本页以 [binds.kdl](../dotfiles/.config/niri/binds.kdl) 为准，改了快捷键请同步更新本页。在桌面里按 **`Mod+Shift+/`** 可以打开可搜索的速查表。

带 ★ 的键和 dwm 的习惯一致：两个桌面用同一套肌肉记忆。

> niri 的布局：每个工作区里，窗口排成**左右滚动的列**，一列里可以上下叠多个窗口；工作区**上下排列**，每块屏幕各有一组。

## 聚焦与移动窗口

| 按键 | 作用 |
|---|---|
| ★ `Mod+H` / `Mod+L`，`Mod+←` / `Mod+→` | 聚焦左边 / 右边的列；已经在最边上时切到另一块屏 |
| ★ `Mod+J` / `Mod+K` | 聚焦同一列里下面 / 上面的窗口；到头了就切到下 / 上一个工作区 |
| ★ `Mod+Shift+H` / `J` / `K` / `L`，`Mod+Shift+←` / `→` | 平铺时：和这个方向相邻的窗口交换位置。浮动时：H / L 贴左 / 右半屏，K 铺满，J 缩回 2/3 大小并居中 |
| ★ `Mod+Ctrl+←` / `→` / `↑` / `↓` | 移动窗口：平铺时调换位置，到边就移到另一块屏 / 相邻工作区；浮动时平移 |
| ★ `Mod+Tab` | 回到上一个用过的窗口 |
| `Mod+Shift+Tab` | 搜索窗口并跳转（fuzzel） |
| `Alt+Tab` / `Alt+Shift+Tab` | 带缩略图的窗口切换（当前工作区） |
| ``Alt+` `` / ``Alt+Shift+` `` | 在同一个应用的多个窗口间切换 |
| `Mod+Home` / `Mod+End` | 聚焦第一列 / 最后一列 |
| `Mod+Ctrl+Home` / `Mod+Ctrl+End` | 把当前列移到最前 / 最后 |
| ★ `Mod+Shift+Return` | 把当前列移到最前（dwm 的 zoom） |
| `Mod+MouseForward` / `Mod+MouseBack` | 鼠标侧键：聚焦上面 / 下面的窗口 |
| `Mod+左键拖动` / `Mod+右键拖动` | 移动窗口 / 调整窗口大小（niri 内置） |

## 列与窗口大小

| 按键 | 作用 |
|---|---|
| ★ `Mod+Alt+←` / `Mod+Alt+→` | 列宽 −5% / +5% |
| ★ `Mod+Alt+↑` / `Mod+Alt+↓` | 窗口高度 −5% / +5% |
| ★ `Mod+,` / `Mod+.` | 列宽 −5% / +5%（dwm 的 setmfact） |
| `Mod+Ctrl+R` | 列宽在预设值之间切换 |
| `Mod+Ctrl+Shift+R` | 窗口高度在预设值之间切换 |
| `Mod+Ctrl+F` | 列宽扩展到占满剩余空间 |
| `Mod+Ctrl+C` | 当前列居中 |
| `Mod+O` | 最大化当前列 |
| ★ `Mod+F` | 全屏 |
| ★ `Mod+E` | 把窗口并入左边的列，再按一次踢出 |
| `Mod+[` / `Mod+]` | 把窗口移进 / 移出左边 / 右边的列 |
| `Mod+Space` | 当前列切换为标签页模式（多个窗口叠成标签） |

## 窗口状态

| 按键 | 作用 |
|---|---|
| ★ `Mod+Q` | 关闭窗口 |
| `Mod+MouseMiddle` | 关闭鼠标下的窗口 |
| `Mod+Ctrl+Q`，`Alt+F4` | 强制结束窗口（kill -9） |
| `Alt+Shift+F4` | 强制结束窗口及其子进程 |
| ★ `Mod+T` | 切换浮动 / 平铺；变成浮动时总是居中、占工作区 2/3 |
| ★ `Mod+=` | 焦点在浮动层和平铺层之间切换 |
| `Mod+I` / `Mod+Shift+I` | 隐藏（最小化）窗口 / 取消隐藏 |
| `Mod+Alt+F` | 窗口内全屏：应用以为自己全屏了，窗口仍只占自己那一列 |
| `Mod+U` | 临时取消窗口规则里的透明度 |

## 工作区与显示器

| 按键 | 作用 |
|---|---|
| ★ `Mod+1` … `Mod+8` | 切到第 1–8 个工作区 |
| ★ `Mod+Shift+1` … `Mod+Shift+8` | 把当前列移到第 1–8 个工作区 |
| ★ `Mod+↑` / `Mod+↓`，`Mod+PageUp` / `Mod+PageDown` | 上一个 / 下一个工作区 |
| ★ `Mod+Shift+↑` / `Mod+Shift+↓`，`Mod+Ctrl+PageUp` / `Mod+Ctrl+PageDown` | 把当前列移到上一个 / 下一个工作区 |
| ★ ``Mod+` `` | 回到上一个工作区 |
| ★ `Mod+滚轮` | 切换工作区 |
| `Mod+Ctrl+滚轮` | 把当前列移到上 / 下一个工作区 |
| `Mod+Shift+滚轮` | 左右切换聚焦的列 |
| `Mod+Ctrl+Shift+滚轮` | 左右移动当前列 |
| ★ `Mod+B` | 聚焦另一块显示器 |
| ★ `Mod+Shift+B` | 把当前列移到另一块显示器 |
| ★ `Mod+Shift+Alt+B` | 把整个工作区移到另一块显示器 |
| `Mod+Alt+N` | 给当前工作区起名（直接回车取消名字）；起了名的工作区空了也会保留 |
| `Mod+Ctrl+Shift+↑` / `↓`，`Mod+Ctrl+Shift+K` / `J` | 把当前工作区上移 / 下移 |
| `Mod+Ctrl+G` | 开关"跟随模式"：切换工作区时把当前窗口一起带过去 |

## 总览与放大镜

| 按键 | 作用 |
|---|---|
| ★ `Mod+A` | 窗口网格总览（作者 niri 分支的功能）。单按 `Mod` 不做任何事 |
| ★ `Mod+Z` | 工作区总览 |
| `Mod+Shift+Z` | 开关放大镜 |
| `Mod+Alt+滚轮` | 放大镜放大 / 缩小 |

## 启动程序

| 按键 | 作用 |
|---|---|
| ★ `Mod+Return` | 终端（kitty） |
| ★ `Mod+S` | 呼出 / 收回 scratchpad 浮动终端 |
| `Mod+-` | 浮动快捷终端 |
| ★ `Mod+D` | 应用启动器（fuzzel） |
| `Mod+Shift+D` | 运行命令（列出 PATH 里的程序） |
| ★ `Mod+R` | 打开 / 关闭文件管理器（pcmanfm） |
| `Mod+Alt+E` | 文件管理器 nautilus |

应用键（仿 dwm 的应用 tag，由 `~/.config/niri/scripts/niri-tag` 实现）：

- 应用开着：跳到它所在的工作区和窗口（被 `Mod+I` 隐藏了会取消隐藏）；已经聚焦在它上面时，有多个窗口就轮流切换。
- 应用没开：跳到当前屏幕最下面的空工作区再启动，不挤进当前工作区。Chrome 和 VS Code 会在外接屏 `HDMI-A-1` 上启动（没接外接屏时用当前屏）。

| 按键 | 应用 |
|---|---|
| ★ `Mod+C` | Chrome（新窗口打开 YouTube） |
| ★ `Mod+W` | Edge（新窗口打开 GitHub） |
| ★ `Mod+V` | VS Code |
| ★ `Mod+M` | SPlayer 音乐播放器 |
| ★ `Mod+9` | OBS |
| ★ `Mod+0` | Steam |
| `Mod+Shift+Q` | 聚焦 QQ（只聚焦，不启动） |
| `Mod+Shift+W` | 聚焦微信（只聚焦，不启动） |

## 截图

截图后会自动复制到剪贴板，并播放快门声。

| 按键 | 作用 |
|---|---|
| ★ `Mod+Shift+A`，`Mod+Alt+A`，`Print` | 选区截图 |
| `Mod+Alt+Ctrl+A`，`Ctrl+Print` | 截取当前窗口 |
| `Mod+Alt+Ctrl+Shift+A`，`Shift+Print` | 截取当前显示器 |
| `Mod+F12` | 截取所有显示器 |
| `Mod+Shift+S` | 用 satty 编辑剪贴板里的截图（标注、裁剪） |

录屏在 waybar 的录屏按钮上，见 [日常使用](03-daily-use.md#waybar)。

## 屏幕共享

在 OBS 或会议软件里共享一次 "niri Dynamic Cast Target"，之后不用回到会议软件，直接用快捷键切换共享的内容：

| 按键 | 作用 |
|---|---|
| `Mod+Alt+C` | 共享当前窗口 |
| `Mod+Alt+Shift+C` | 共享当前显示器 |
| `Mod+Alt+X` | 暂停共享（对方看到黑屏） |

QQ、微信的窗口在录屏、共享屏幕时总是显示成黑块（`rule.kdl`），自己截图不受影响。

## 剪贴板、翻译、通知

| 按键 | 作用 |
|---|---|
| ★ `Mod+X` | 剪贴板历史（fuzzel 选择后复制） |
| `Mod+Alt+V` | 剪贴板历史 TUI（可预览图片、删除条目） |
| ★ `Mod+Y` | 翻译选中的文字（中 ↔ 英，结果在通知里） |
| ★ `Mod+Shift+Y` | 输入文字翻译，译文复制到剪贴板 |
| ★ `Mod+N` | 重新显示上一条通知 |
| ★ `Mod+Shift+N` | 关闭所有通知 |

## 壁纸、配色、状态栏

| 按键 | 作用 |
|---|---|
| `Mod+Alt+W` | 打开壁纸选择器 waypaper（换壁纸后 matugen 自动给全桌面换配色） |
| `Mod+F10` | 随机换一张壁纸（`~/Pictures/Wallpapers`） |
| `Mod+Shift+F10` | 下载一张随机动漫壁纸 |
| `Mod+Alt+M`，`Mod+Alt+T` | 切换 matugen 取色方案 |
| ★ `Mod+Shift+F` | 隐藏 / 显示 waybar（进程不退出） |
| `Mod+F4` | 关闭 / 启动 waybar（关掉进程以节省资源） |
| `Mod+F2` | 切换到默认风格的 waybar |
| `Mod+F3` | 切换到 Win11 风格的 waybar |

## 系统

| 按键 | 作用 |
|---|---|
| ★ `Mod+Shift+/` | 快捷键速查 |
| ★ `Mod+P` | 设置菜单（同 dwm 的 Super+P）：夜灯、勿扰、自动熄屏、触摸板、省电、壁纸、状态栏、Sunshine、提取窗口信息，见 [日常使用 · 设置菜单](03-daily-use.md#设置菜单) |
| ★ `Mod+Ctrl+L` | 锁屏（hyprlock，用登录密码解锁） |
| ★ `Mod+Shift+Escape` | 电源菜单：锁屏、关闭屏幕、退出、挂起、重启、关机 |
| `Mod+Shift+E` | 退出 niri（会弹确认框） |
| ★ `Mod+Shift+R` | 重新加载 niri 配置（通常不需要，改配置文件后会自动加载） |
| `Mod+F1` | 关闭 / 启动输入法（输入法卡住时用） |
| `Mod+F5` / `Mod+F8` | 快速存档 / 读档（btrfs 快照，需要 btrfs + snapper，ext4 上无效） |
| `Mod+Escape` | 暂停 / 恢复全部快捷键（远程桌面等程序抢键时用） |

## 媒体键

锁屏时也可以用。

| 按键 | 作用 |
|---|---|
| 音量加 / 减 / 静音 | 调节音量，屏幕上显示 OSD |
| 麦克风静音键 | 开关麦克风 |
| 播放 / 暂停、下一首、上一首 | 控制正在播放的媒体（playerctl） |
| 亮度加 / 减 | 调节笔记本屏亮度 |

## 输入法

| 按键 | 作用 |
|---|---|
| `Ctrl+Space` | 切换中 / 英文输入法（fcitx5） |
| 左 `Shift` | 快速切换中 / 英（fcitx5；Rime 自己不再处理 Shift） |

更多见 [日常使用 · 输入法](03-daily-use.md#输入法)。
