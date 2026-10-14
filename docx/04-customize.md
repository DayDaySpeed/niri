# 自定义

## 配置怎么流动

```
项目 dotfiles/  ── ./setup.sh deploy ──▶  ~ (实际生效)
                ◀── ./setup.sh pull ───
```

- 配置是**复制**到 `~` 的，不是链接。matugen 换壁纸时会改写一批配色文件，复制可以避免这些改动直接弄脏仓库，由你决定提交哪些。
- `deploy` 覆盖 `~` 里的同名文件，不删除其他文件。
- `pull` 只拷回 `dotfiles/` 里已经有的文件；新增的文件要先手动放进 `dotfiles/`。
- `.zprofile`、`.bash_profile` 是模板（`@TTY@`），`pull` 不拷回；`waypaper/config.ini`、`gtk-3.0/bookmarks` 里的家目录写成 `@HOME@`，`deploy` 展开、`pull` 换回。

## 两种改法

**在项目里改**（推荐）：

```sh
vim dotfiles/.config/niri/binds.kdl
./setup.sh deploy          # 会先用 niri validate 校验, 不通过就不部署
git commit -am "..."
```

niri 会自动重新加载配置；waybar、mako 要重开（`Mod+F2`），或者重新登录。

**在桌面里直接改了**（包括换壁纸后的配色、VSCode 设置）：

```sh
./setup.sh pull
git diff                   # 看看改了什么, 不想要的 git checkout 掉
git commit -am "..."
```

`deploy` 会用项目里的版本覆盖 `~`。如果两边都改过，**先 `pull` 再 `deploy`**。

## 常改的文件

| 想改 | 文件 |
|---|---|
| 快捷键 | `dotfiles/.config/niri/binds.kdl`（改完同步更新 [快捷键](02-keybindings.md)） |
| 自启动程序、输入设备、Alt+Tab 切换器 | `dotfiles/.config/niri/config.kdl` |
| 屏幕、缩放 | `dotfiles/.config/niri/output.kdl` |
| 窗口间距、边框、预设列宽 | `dotfiles/.config/niri/layout.kdl` |
| 窗口规则（浮动、透明度、圆角） | `dotfiles/.config/niri/rule.kdl` |
| 动画、模糊 | `dotfiles/.config/niri/animations.kdl`、`blur.kdl` |
| 状态栏 | `dotfiles/.config/waybar/config.jsonc`（模块排列）、`modules.jsonc`（各模块行为）、`style.css` |
| 终端 | `dotfiles/.config/kitty/kitty.conf` |
| zsh | `dotfiles/.config/zsh/zshrc`；私有内容放 `~/.config/zsh/local.zsh`（不入库） |
| 输入法 | `dotfiles/.config/fcitx5/`、`dotfiles/.local/share/fcitx5/rime/*.custom.yaml` |
| 换色覆盖哪些程序 | `dotfiles/.config/matugen/config.toml`，模板在 `templates/` |

## 屏幕

1. 在 niri 里运行 `niri msg outputs`，记下屏幕名（如 `eDP-1`、`HDMI-A-1`）和分辨率。
2. 改 `dotfiles/.config/niri/output.kdl`：

   ```kdl
   output "eDP-1" {
       scale 1.35
       position x=0 y=0
   }
   output "HDMI-A-1" {
       scale 1.0
       position x=1896 y=0      // 放在笔记本屏右边: 2560 / 1.35 ≈ 1896
   }
   ```

   `position` 用的是缩放后的逻辑像素：左边屏幕的宽度除以它的缩放倍数。

3. 外接屏名还写死在两处，一起改掉：`rule.kdl`（Chrome / VS Code 固定开在外接屏）和 `binds.kdl`（`Mod+C` / `Mod+V` 的 `--output`）。
4. `./setup.sh deploy`，niri 立即生效。

`dotfiles/.config/niri/output-example.kdl` 里有作者写的更多示例（刷新率、旋转、VRR 等）。

## 加包、加扩展

- 加包：写进 `packages/` 对应的清单（桌面必需的放 `core*.txt`，应用放 `apps*.txt`），再运行 `./setup.sh deps`。
- VSCode / Cursor 扩展：装好后导出清单再提交。

  ```sh
  { head -1 packages/vscode-extensions.txt; code --list-extensions; } > /tmp/ext && mv /tmp/ext packages/vscode-extensions.txt
  ```

## 加一个新的配置文件

把文件按家目录里的相对路径放进 `dotfiles/`，例如 `~/.config/foo/bar.conf` 放到 `dotfiles/.config/foo/bar.conf`。之后 `deploy` / `pull` 会自动带上它。

**不要放密钥**：`./setup.sh check` 会扫描 `dotfiles/` 里常见的密钥格式。
