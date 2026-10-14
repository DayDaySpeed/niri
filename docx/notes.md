# 决策记录

为什么这样做、对作者的配置改了什么。使用方法见 [文档目录](README.md)。

## 为什么不运行作者的一键脚本

作者的 [shorin-arch-setup](https://github.com/SHORiN-KiWATA/shorin-arch-setup) 和 `shorinniri init` 面向刚装好的 btrfs 系统，会修改整个系统。在最初那台（和 dwm 共存的）机器上会出现这些问题：

- 根分区是 ext4，作者靠 btrfs 快照实现的回滚不可用。
- 选用户时默认选 UID 1000（也就是 jiang），30 秒不操作就自动确认。
- 会把 fcitx5 换成作者打过补丁的版本，并启用 power-profiles-daemon（会和 dwm2 的 `bin/powersave.sh` 抢着设置 EPP）。
- 会给 wheel 组开免密 pacman / systemctl，可能安装 ly 并占用 tty1，还会运行 `chwd -a` 自动换显卡驱动。

因此本项目只做这几件事：从官方仓库和 AUR 装包；把作者的 dotfiles 复制到家目录；少量系统设置（tty 自动登录、NVIDIA、locale）；补上 `shorinniri init` 里属于用户级的设置（gsettings 深色主题、xdg-terminals、xdg-user-dirs）。作者那些系统级改动（power-profiles-daemon、swayosd 的 libinput 服务、i2c、firefox 策略）全部不做，所以 waybar 上的外接屏亮度（ddcutil）、大写锁定提示这类功能可能不可用。

## 为什么要用作者的 niri 分支

shorin-niri 的配置里用了分支独有的选项，比如 `ignore-grid-overview`、`confine-mouse-to-fullscreen`，用官方 niri 26.04 跑 `niri validate` 会直接报错。所以要装 `niri-shorin-fork-git`：它在官方基础上增加了网格总览、放大镜等功能，从源码编译，并会替换掉官方的 niri 包。

作者另有一个 DMS 版（shorin-dms-niri，可以用官方 niri），一开始试的就是它。但教程截图里的 waybar 样式来自 shorin-niri 这一版，所以最后换了过来。

## 对作者配置做的改动（dotfiles/）

| 文件 | 改动 | 原因 |
|---|---|---|
| `.config/fcitx5/`、`.local/share/fcitx5/rime/` | 换成 dwm2 `home/fcitx5` 的版本 | Rime 雾凇 + 万象语法模型，Ctrl+Space 切换（作者用的是 Super+Space） |
| `.zshrc`、`.config/zsh/zshrc` | 新增，取自 dwm2 `home/zsh` | 和 dwm 那边同一套 zsh；私有内容放 `~/.config/zsh/local.zsh`（不入库，有 `.example`） |
| `.config/starship.toml` | matugen 生成的版本 | 跟着壁纸配色 |
| `.config/kitty/kitty.conf` | 删除 `shell fish` | 使用登录 shell zsh |
| `.config/niri/binds.kdl` | 键位改成 dwm 习惯（Super+hjkl 聚焦、Super+上下切工作区等，见文件开头注释）；Mod+B 从 firefox 改为 google-chrome-stable | 两个桌面用同一套肌肉记忆；没装 firefox |
| `.config/niri/config.kdl` | 窗口切换从 Mod+Tab 改为 Alt+Tab；焦点跟随鼠标、切换焦点时光标跟过去 | 同上 |
| `.config/niri/layout.kdl` | 只有一个窗口时居中 | |
| `.config/niri/scripts/niri-exchange`、`niri-float-toggle`、`niri-tag` | 新增：`Mod+Shift+hjkl` 交换 / 贴边，`Mod+T` 浮动时居中，应用键开在单独的空工作区 | 仿 dwm 的 exchange_client、togglefloating、应用 tag |
| `.config/niri/scripts/menu` | 新增：`Mod+P` 设置菜单（原来 `Mod+P` 是提取窗口信息，已并入菜单） | 仿 dwm 的 `bin/rofi.sh`；省电、Sunshine 两项依赖 dwm2 的脚本 |
| `.config/niri/rule.kdl` | 新增：QQ / 微信在录屏时显示黑块；Chrome / VS Code 固定开在外接屏 | |
| `.config/niri/scripts/scratchpad`、`rule.kdl` | 新增：Super+S 呼出/收回浮动终端 | 仿 dwm 的 togglescratch，依赖 nirius |
| `.local/bin/translate.sh` | 新增：Super+Y 翻译选中文字，Super+Shift+Y 输入翻译 | 取自 dwm2 的 `bin/translate.sh`，rofi / xclip 换成 fuzzel / wl-paste |
| `.config/{Code,Cursor}/User/settings.json` | 新增 | 编辑器设置；matugen 换壁纸时会往 VSCode 设置里注入配色，改完记得 `pull` |
| `.gitconfig` | 新增 | git 用户名、gh 凭据助手（不含密钥） |
| `.config/niri/output.kdl` | 改成本机的两块屏 | eDP-1 2560x1440 缩放 1.35；HDMI-A-1 1920x1080 缩放 1.0，放在右边，x=1896（= 2560 / 1.35） |
| `.config/gtk-3.0/bookmarks`、`.config/waypaper/config.ini` | 家目录写成 `@HOME@`，`deploy` 时展开、`pull` 时换回 | 原来写死了作者的 /home/shorin |
| `.config/xdg-terminals.list` | 新增，内容为 kitty | 原本由 `shorinniri init` 写入 |
| `.bash_profile`、`.zprofile` | 新增：在 tty`@TTY@` 上执行 `exec niri-session -l`，`@TTY@` 由 `deploy` 换成 `NIRI_TTY`（默认 1） | 见下文"死循环"；`pull` 不拷回这两个文件 |
| `.config/{chrome,code,electron}-flags.conf` | 新增：`--ozone-platform-hint=auto --enable-wayland-ime --wayland-text-input-version=3` | Chrome / VSCode 以原生 Wayland 运行，输入法走 text-input-v3 |
| `Pictures/Wallpapers/` | 放入作者的壁纸 | 启动时 `waypaper --random` 需要至少一张壁纸 |

## 缩放

Wayland 下每块屏单独缩放，应用会按缩放倍数直接渲染，不像 X11 那样整个桌面只能有一个 DPI，所以笔记本屏和外接屏都清晰。

- **不要**把 dwm（X11）那边的 `electron-flags.conf`（`--force-device-scale-factor=1.35`）拿过来：它是 X11 下的变通做法，在 Wayland 下会再放大一次。
- X11 程序（比如 Steam）通过 xwayland-satellite 运行。两块屏缩放不同时，它会统一按最小的 1x 渲染，再由 niri 放大到 1.35 倍，所以在笔记本屏上尺寸是对的，但会发虚。

## tty 自动登录与"死循环"

`niri-session` 不带 `-l` 运行时，会先另开一个登录 shell 再调用自己。那个 shell 又读到 `.bash_profile` / `.zprofile`，于是再次执行 `niri-session`，无限循环（表现为一直停在 tty，bash 占用约 25% CPU）。现在的写法是：只在交互式 shell 里执行，并且带 `-l`。

登录 shell 改成 zsh 以后，读的是 `.zprofile` 而不是 `.bash_profile`，所以两份都要有。

## 为什么是复制而不是链接

matugen 换壁纸时会改写一批配置（各种 `colors.*`、starship、VSCode 设置），链接的话这些改动会直接弄脏仓库。所以 `deploy` 复制、`pull` 拷回，由自己决定提交哪些。`rsync` 会把 stage 目录的 755 权限带到家目录，`deploy` 结束时改回 700（家目录里有密钥）。

## 历史：和 dwm 共存的双用户模式

最初本项目是在 jiang 的 dwm2 机器上加一个测试用户 nirijiang（tty2），输入法、zsh 从 dwm2 复制，`sync` 从 jiang 同步密钥和应用配置。后来改成独立模式：装给运行 `setup.sh` 的当前用户，输入法、zsh 收进本项目，私密数据改为手动迁移。原来那台机器继续用时带 `NIRI_TTY=2`。

## 删掉的作者配置

这些内容没装或用不上，已从 `dotfiles/` 删除。需要时到作者仓库 [shorin-niri](https://github.com/SHORiN-KiWATA/shorin-niri) 取回。

| 删掉的 | 原来的用途 |
|---|---|
| `Mod+F9` → `miyu` | AI 语音助手（AUR `miyu-git`），还有 matugen 里的 miyu 配色模板 |
| `Mod+F11`、`Mod+Shift+T` → `wl-wordlens` | 截图翻译 |
| `Super+Alt+S` → `orca` | 读屏 |
| `Mod+Ctrl+Shift+Alt+B` → `~/.local/bin/bad-apple` | 彩蛋，播放 Bad Apple（17M 二进制） |
| 自启动 flatpak easyeffects | 音效调节 |
| matugen 的 pywalfox 模板 | Firefox 跟随配色（没装 Firefox） |
| matugen 里注释掉的模板：wlogout、swaync、ghostty、qt5ct / qt6ct、KDE 配色、hyprland、niriswitcher、swaylock、neovim、steam | 对应程序没装 |
| `lsfg-vk/`、`qq-flags.conf`、`waybar/scripts/old-longshot.sh` | 游戏插帧、QQ 的 Wayland 参数、旧的长截图脚本 |

作者文档里的 `pac` / `pacr`、Proton 运行 Windows 程序、linuxqq-wayland-fix、`shorin-undochange` 回档等，依赖作者一键脚本装的东西，本项目没有装，文档也没有搬过来。

`quicksave` / `quickload`（`Mod+F5` / `Mod+F8`）保留了，但它们基于 btrfs + snapper，在 ext4 上无效。

已知问题见 [排错](05-troubleshooting.md)。
