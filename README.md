# niri

可复现的 [Shorin Niri](https://github.com/SHORiN-KiWATA/shorin-niri) 桌面：niri（作者分支）+ waybar + matugen 按壁纸取色，键位按 dwm 的习惯改过，输入法是 fcitx5 + Rime 雾凇。新装的 Arch 上运行一条命令，重启后就是同一套桌面。

> `dotfiles/` 里是作者 shorin-niri 仓库（56d2411，2026-10-12）的配置，加上本项目的改动。作者的仓库**没有开源许可证**，本项目只供自己使用，**不要公开推送**。

## 快速开始

```sh
sudo pacman -S --needed git
git clone <本仓库> ~/projs/niri && cd ~/projs/niri
./setup.sh            # 装包、写系统配置、部署 dotfiles，最后体检
```

装完重启，会在 tty1 自动登录进入 niri。按 `Mod+Shift+/` 查看快捷键。还要手动迁移 SSH / GPG 密钥等私密数据，见 [安装](docx/01-install.md#装完后手动迁移私密数据)。

## 文档

- [安装](docx/01-install.md)：选项（`NIRI_TTY`、`--no-apps`）、子命令、私密数据迁移
- [快捷键](docx/02-keybindings.md)
- [日常使用](docx/03-daily-use.md)
- [自定义](docx/04-customize.md)：改配置的流程，`deploy` / `pull`
- [排错](docx/05-troubleshooting.md)
- [决策记录](docx/notes.md)

## 目录

```
setup.sh      入口: bootstrap / deps / system / deploy / pull / check
packages/     包清单: core、apps (官方仓库 / AUR)、按显卡的驱动、编辑器扩展
system/       /etc 模板: tty 自动登录、NVIDIA 设置
dotfiles/     复制到 ~ 的配置 (作者的配置 + 本项目的改动)
docx/         使用文档
state/        不入库: 部署时的临时目录
```
