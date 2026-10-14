# 日常使用

快捷键见 [快捷键](02-keybindings.md)，本页讲各功能怎么用。

## 登录与退出

- 开机后在 tty1 自动登录并进入 niri（设了 `NIRI_TTY` 时是对应的 tty）。
- 锁屏：`Mod+Ctrl+L`，或者 waybar 右端的电源按钮。解锁用登录密码。
- 退出 niri 会回到 tty；重新登录这个 tty 会再次自动进入 niri。
- 登录后默认**不会**空闲自动熄屏（`config.kdl` 里 swayidle 那行是注释掉的）。可以在 `Mod+P` 菜单里选 resume auto lock 临时开启（5 分钟无操作关闭屏幕，不锁屏）；想登录就开启，去掉 `config.kdl` 里那行的注释。

## 设置菜单

`Mod+P` 打开设置菜单（fuzzel），对应 dwm 的 Super+P。开关类的项按当前状态显示"开"或"关"。

| 菜单项 | 作用 |
|---|---|
| night light | 开关护眼色温（wlsunset） |
| do not disturb | 开关勿扰模式：通知不再弹出，关掉后恢复 |
| auto lock | 暂停 / 恢复自动熄屏（swayidle：5 分钟无操作关闭屏幕） |
| touchpad | 禁用 / 启用触摸板；重启 niri 后自动恢复启用 |
| power save | 开关省电模式（调 CPU 节能策略） |
| choose / random wallpaper | 打开壁纸选择器 / 随机换一张 |
| update statusbar | 刷新 waybar |
| sunshine | 开关 Sunshine 远程桌面串流 |
| pick window info | 选择复制当前窗口的信息（标题、App ID、PID）或吸取屏幕颜色 |

省电模式和 Sunshine 两项调用的是 dwm2 的脚本（`~/.config/dwm2/bin/powersave.sh`、`sunshine.sh`），没有 dwm2 的机器上这两项不可用。

## waybar

状态栏从左到右：

| 位置 | 模块 | 操作 |
|---|---|---|
| 左 | 工作区、当前窗口标题 | 点击工作区可切换 |
| 中 | 常用命令 | 左键：更新系统、更新镜像源、系统清理等菜单（来自 `shorin` 命令） |
| 中 | 录屏 | 左键：开始 / 停止录屏（可选区域或全屏）；右键：停止 |
| 中 | 截图 | 左键：快速截图到剪贴板；中键：截图菜单 |
| 中 | 剪贴板 | 左键：剪贴板历史；右键：清空历史；中键：重启剪贴板后台 |
| 中 | 防止熄屏 | 点击开关：开着时屏幕不会自动熄灭 |
| 中 | 取色 | 左键：屏幕取色并复制；右键：换壁纸；中键：切换取色方案 |
| 右 | 更新、托盘 | 有可更新的包时显示数量 |
| 右 | 音量 | 左键：静音；右键：麦克风静音；中键：音量面板；悬停展开滑块 |
| 右 | 蓝牙 | 左键：蓝牙管理（bluetui）；右键：开关蓝牙 |
| 右 | 网络 | 左键：选择网络（终端界面）；右键：网络连接设置 |
| 右 | 电池、时钟、电源 | 悬停电源按钮展开：锁屏、登出、重启、关机 |

- `Mod+F2` / `Mod+F3` 在默认风格和 Win11 风格的 waybar 之间切换。
- `Mod+Shift+F` 只是隐藏，`Mod+F4` 会直接关掉进程。
- 外接屏亮度（ddcutil）、性能模式（power-profiles-daemon）这两个模块需要的包没装，所以不会显示。原因见 [决策记录](notes.md)。

## 壁纸与配色

- 壁纸放在 `~/Pictures/Wallpapers/`，登录时随机选一张。
- `Mod+Alt+W` 打开 waypaper 选壁纸，`Mod+F10` 随机换一张，`Mod+Shift+F10` 从网上下载一张动漫壁纸（存到 `~/Pictures/Wallpapers/api-random-download/`）。
- **换壁纸后 matugen 会按壁纸取色，自动给整个桌面换配色**：niri 边框、waybar、kitty、fuzzel、mako 通知、GTK 程序、fcitx5 皮肤、starship 提示符、btop、yazi、VSCode 等。
- `Mod+Alt+M` 切换取色方案（偏鲜艳、偏柔和等）。
- 配色文件会被改写，所以换壁纸后 `git status` 能看到 `dotfiles/` 有改动；想保留就运行 `./setup.sh pull` 再提交。

## 输入法

- `Ctrl+Space` 切换输入法，左 `Shift` 快速切换中 / 英。
- 中文输入用 Rime + 雾凇拼音，开启了万象语法模型，长句更准。
- 第一次登录时如果输入法没反应，按 `Mod+F1` 关掉再开一次。
- 图形化设置：运行 `fcitx5-configtool`。Rime 的设置在 `~/.local/share/fcitx5/rime/*.custom.yaml`，改完在输入法菜单里选"重新部署"。
- 皮肤颜色跟着壁纸变。

## 窗口管理要点

- niri 的窗口是**一列一列左右排开**的，可以无限向右延伸，屏幕只显示其中一段。`Mod+H/L` 左右切换，`Mod+,` / `Mod+.` 调列宽。
- 工作区**上下排列**，用 `Mod+↑/↓`、`Mod+1…8` 或 `Mod+滚轮` 切换。空工作区会自动消失，最下面总会有一个空的。
- 找不到窗口时：`Mod+A` 打开窗口网格总览，或 `Mod+Shift+Tab` 按名字搜索。
- 鼠标移到哪个窗口就聚焦哪个；用键盘切换聚焦时，鼠标指针会跟过去。
- 工作区里只有一个窗口时，它居中显示，不会贴在左边。
- 应用键（`Mod+C` / `Mod+V` 等）会把应用开在单独的空工作区里，效果和 dwm 的应用 tag 一样。
- `Mod+S` 的 scratchpad 终端适合临时敲命令：再按一次收起，里面的内容保留。

## 截图与录屏

- 选区截图 `Mod+Shift+A`（或 `Print`），截完在剪贴板里，可以直接粘贴。
- 要标注就接着按 `Mod+Shift+S`，用 satty 编辑后保存或复制。
- 录屏用 waybar 上的录屏按钮。
- 开会共享屏幕时，共享 "niri Dynamic Cast Target"，之后用 `Mod+Alt+C` / `Mod+Alt+Shift+C` / `Mod+Alt+X` 切换共享窗口、显示器或暂停，见 [快捷键 · 屏幕共享](02-keybindings.md#屏幕共享)。

## 剪贴板

- 复制过的文字和图片都会进历史。`Mod+X` 用 fuzzel 选一条重新复制；`Mod+Alt+V` 打开 TUI 版，可以预览图片、删除条目。
- 清空历史：waybar 剪贴板按钮右键。

## 多显示器

- 每块屏幕各自缩放（`output.kdl`），笔记本屏和外接屏都清晰。
- `Mod+B` 切换聚焦的屏幕，`Mod+Shift+B` 把窗口带过去，`Mod+Shift+Alt+B` 把整个工作区带过去。
- 外接屏插上后自动启用。屏幕名和缩放的改法见 [自定义 · 屏幕](04-customize.md#屏幕)。

## 系统维护

`shorin` 命令（`shorin-contrib-git` 提供）集合了一些维护命令，运行 `shorin` 可以看到全部。常用的：

| 命令 | 作用 |
|---|---|
| `shorin sysup` | 更新系统（官方仓库 + AUR） |
| `shorin mirror-update` | 更新镜像源 |
| `shorin clean` | 清理软件包缓存、回收站等 |
| `quicksave` / `quickload` | 快速存档 / 读档。**需要 btrfs + snapper**，ext4 上不可用 |

`~/.cache` 里的东西都可以删，但全删可能需要重新登录一些应用。

## 常用 TUI 程序

| 命令 | 作用 |
|---|---|
| `btop` | 任务管理器 |
| `yazi` | 文件管理器 |
| `nmtui` | 网络设置 |
| `bluetui` | 蓝牙 |
| `fastfetch` | 系统信息 |

## 参考

- niri 官方 Wiki：<https://github.com/niri-wm/niri/wiki>
- ArchWiki：<https://wiki.archlinux.org/>
- Shorin（配置作者）的文档：<https://shorin.xyz/wiki>
