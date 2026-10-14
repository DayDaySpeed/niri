# 安装

## 前提

一台装好的 Arch Linux：base、能联网、有一个带 sudo 的普通用户。用这个用户执行下面的命令（不要用 root）。

## 一条命令安装

```sh
sudo pacman -S --needed git
git clone <本仓库> ~/projs/niri
cd ~/projs/niri
./setup.sh
```

按顺序执行 `bootstrap deps system deploy`，最后运行 `check`。完成后重启，会在 tty1 自动登录并进入 niri。

安装过程中要注意：

- 装作者的 niri 分支 `niri-shorin-fork-git` 时，yay 会问是否移除官方 niri，**输入 y**。默认是 N，直接回车会装失败。
- 作者的 niri 分支要从源码编译，需要十几分钟。
- 需要 sudo 的地方会询问密码。

## 选项

| 写法 | 作用 |
|---|---|
| `NIRI_TTY=2 ./setup.sh` | 在 tty2 自动登录并启动 niri（默认 tty1）。tty1 已被别的桌面占用时用，比如和 dwm 共存的机器。**以后每次运行 `setup.sh` 都要带上它** |
| `./setup.sh --no-apps` | 只装桌面，不装 Chrome / Edge / VSCode / Cursor / Typora / OBS / Steam / LibreOffice / SPlayer；也可以写 `SETUP_APPS=0` |

## 子命令

每个子命令都可以单独运行、重复运行，已经满足的项会跳过。

| 命令 | 作用 |
|---|---|
| `./setup.sh bootstrap` | 安装 base-devel、git，开启 multilib，没有 yay 时从 AUR 编译 |
| `./setup.sh deps` | 按 `packages/*.txt` 装包，按显卡（Intel / AMD / NVIDIA）追加驱动；安装 VSCode / Cursor 扩展和 SPlayer |
| `./setup.sh system` | 写 `/etc`：tty 自动登录、NVIDIA 设置、zh_CN locale；登录 shell 改为 zsh；启用 NetworkManager 和蓝牙 |
| `./setup.sh deploy` | 把 `dotfiles/` 复制到 `~`：覆盖同名文件，不删除其他文件；设置 GTK 深色主题 |
| `./setup.sh pull` | 反方向：把 `~` 里改过、且 `dotfiles/` 里也有的文件拷回项目 |
| `./setup.sh check` | 只读体检，每项打印 ✓ / ✗ |

## 装完后：手动迁移私密数据

这些内容不进仓库，需要从旧电脑拷过来，或者重新登录。`./setup.sh check` 最后一段会提示哪些还没处理。

| 内容 | 怎么迁移 |
|---|---|
| `~/.ssh`、`~/.gnupg` | 从旧电脑拷过来，拷完执行 `chmod 700 ~/.ssh ~/.gnupg` |
| GitHub CLI | `gh auth login`；git 推送通过 gh 认证 |
| `~/.config/zsh/local.zsh` | 存放环境变量、API 密钥、个人工具路径。`deploy` 会先放一份示例，照着填写，或者直接从旧电脑拷 |
| 浏览器 | 登录 Chrome / Edge 账号，同步书签和扩展 |
| 输入法词库 | Rime 的用户词库在 `~/.local/share/fcitx5/rime/` 下的 `*.userdb`，需要的话从旧电脑拷 |

## 装完后：按本机调整

- **屏幕**：`output.kdl` 里写的是原来那台电脑的屏幕（笔记本屏 eDP-1 缩放 1.35，外接屏 HDMI-A-1 缩放 1.0）。在 niri 里运行 `niri msg outputs` 查看本机的屏幕名，改 `dotfiles/.config/niri/output.kdl`，再运行 `./setup.sh deploy`。详见 [自定义 · 屏幕](04-customize.md#屏幕)。
- **锁屏密码**：hyprlock 用的是登录密码，确认当前用户设置了密码。

## 包清单

| 文件 | 内容 | 什么时候装 |
|---|---|---|
| `packages/core.txt` | 桌面必需（官方仓库） | 总是 |
| `packages/core-aur.txt` | 桌面必需（AUR）：niri 分支、nirius、字体、雾凇等 | 总是 |
| `packages/apps.txt`、`apps-aur.txt` | 日常应用 | 不带 `--no-apps` 时 |
| `packages/{intel,amd,nvidia}.txt` | 显卡驱动 | 检测到对应显卡时 |
| `packages/vscode-extensions.txt`、`cursor-extensions.txt` | 编辑器扩展 | 装了对应编辑器时 |

格式：`#` 后面是注释，每行可以写多个包。
