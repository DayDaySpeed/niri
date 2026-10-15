# 排错

先运行 `./setup.sh check`，它会逐项检查包、自动登录、系统配置、niri 配置。

## 开机停在 tty，没有进入 niri

- `./setup.sh check` 看"自动登录"和"~/.zprofile 在 ttyN 启动 niri"两项。两者的 tty 要一致：`NIRI_TTY` 设成 2 时，`system` 和 `deploy` 都要带上它运行。
- 手动启动看报错：在那个 tty 登录后执行 `niri-session -l`。
- **一直停在 tty，bash/zsh 占 CPU**：多半是登录脚本的死循环。`niri-session` 不带 `-l` 时会另开一个登录 shell，那个 shell 又读到 `.zprofile`，于是再次启动 `niri-session`。项目里的 `.zprofile` / `.bash_profile` 只在交互式 shell 里启动，并且带 `-l`，不要改掉这两点。

## niri 配置报错

```sh
niri validate -c dotfiles/.config/niri/config.kdl
```

`deploy` 部署前会自动校验，不通过就不部署。配置用了作者分支独有的选项（如 `toggle-grid-overview`），**必须装 `niri-shorin-fork-git`**，官方 niri 会报错。`check` 会检查装的是不是分支。

## 装 niri-shorin-fork-git 失败

yay 问"是否移除 niri"时默认是 N，直接回车会冲突失败。重新运行 `./setup.sh deps`，这次输入 `y`。

## 输入法没反应

- `Mod+F1` 把 fcitx5 关掉再开。
- 在 Chrome / VSCode 里打不出中文：确认 `~/.config/chrome-flags.conf`、`code-flags.conf` 存在（`deploy` 会放），然后重启这个程序。它们让程序以原生 Wayland 运行，输入法走 text-input-v3。
- 换壁纸时**不要**用 `fcitx5 -r` 重启输入法：新开的实例会被 niri 拒绝，输入法会卡死。matugen 里已经改成只让正在运行的 fcitx5 重新加载皮肤。

## 程序发虚

- X11 程序（比如 Steam）通过 xwayland-satellite 运行。两块屏缩放不同时，它按 1x 渲染再由 niri 放大，所以在笔记本屏上尺寸对但发虚。这是已知限制。
- Electron 程序（VSCode 等）发虚：确认 `~/.config/electron-flags.conf` 里**没有** `--force-device-scale-factor`。那是 X11 下的做法，在 Wayland 下会再放大一次。

## 换壁纸后 VSCode 设置变了

matugen 会往 `~/.config/Code/User/settings.json` 注入配色（`dotfiles/.config/matugen/scripts/inject_vscode.sh`），这是正常的。想保留就 `./setup.sh pull`。

## NVIDIA

- `./setup.sh system` 会写 `/etc/modprobe.d/nvidia.conf`（开启 modeset）和 niri 的显存设置，重启后生效。
- 在 X 桌面（另一个 tty）和 niri 之间来回切换，偶尔切回时会黑屏。驱动 555 以后好了很多；黑屏时再切一次 tty 通常能恢复。

## 扩展安装时出现 "not in the list of known options"

VSCode 命令行读到了 `code-flags.conf` 里的 Wayland 参数，警告无害，脚本已经过滤掉了。

## Chrome / VS Code 没开在想要的屏幕上

`rule.kdl` 和 `binds.kdl` 里写死了外接屏名 `HDMI-A-1`。换了电脑或接口后，用 `niri msg outputs` 查出新的屏幕名，替换这两个文件里的 `HDMI-A-1`。

## 快捷键没反应

- `Mod+S` scratchpad、`Mod+Ctrl+G` 跟随模式、`Mod+Shift+Q` / `W` 依赖 `niriusd`，确认它在运行：`pgrep niriusd`。
- 应用快捷键（`Mod+C`、`Mod+V` 等）用的是 `niri-tag` 脚本，需要 `python3`。
- 远程桌面等程序可能会暂停快捷键，按 `Mod+Escape` 恢复。
- `Mod+F5` / `Mod+F8` 快速存档需要 btrfs + snapper，ext4 上无效。

## 多个用户共享 Steam 库，另一个用户的游戏打不开

共享库 `/games/SteamLibrary` 归 `games` 组（setgid + 默认 ACL `g:games:rwx`），两个用户都在 `games` 组里。

- 日志 `~/.local/share/Steam/logs/console-linux.txt` 里有 `pressure-vessel-wrap: E: openat(.../files/.ref): Permission denied`：Steam 写进来的文件是 755/644，ACL 的 mask 跟着变成 `r-x`，组写权限没了。`./setup.sh system` 会装 `steam-library-perms.path`，库里有变动时自动放开组写权限；手动修一次：`sudo systemctl start steam-library-perms.service`。
- Proton 游戏的 Wine 前缀（`compatdata/<AppID>/pfx`）只能给所有者用。另一个用户在游戏属性的启动选项里换成自己的前缀：`STEAM_COMPAT_DATA_PATH=/home/<用户名>/.local/share/Steam/steamapps/compatdata/<AppID> %command%`。
- 不要两个用户的 Steam 同时开着。

## 打开应用时弹窗要求解锁 "Default Keyring"

tty 自动登录时没有输入密码，gnome-keyring 没法自动解锁带密码的钥匙环。`./setup.sh` 只在还没有钥匙环时创建一个空密码的（不加密，存在 `~/.local/share/keyrings`）。如果已有的钥匙环带密码，就重置一下（里面存的登录信息会丢，应用需要重新登录）：

```bash
systemctl --user stop gnome-keyring-daemon.service gnome-keyring-daemon.socket
mv ~/.local/share/keyrings ~/.local/share/keyrings.bak
./setup.sh deploy        # 会重新创建空密码的钥匙环
systemctl --user start gnome-keyring-daemon.socket
```
