#!/bin/bash
# niri 安装入口: 新装的 Arch (base + 用户 + 网络 + sudo) 上克隆本仓库后运行 ./setup.sh, 重启即进入同样的 Shorin Niri 桌面
# 装给运行它的当前用户; 需要时 sudo 问密码; 每一步都可以重复运行, 已经满足的项会跳过
#   ./setup.sh             全部: bootstrap deps system deploy, 最后 check
#   ./setup.sh --no-apps   同上, 但不装日常应用 (Chrome / Edge / VSCode / Cursor / Typora / OBS / Steam ...); 也可 SETUP_APPS=0
#   ./setup.sh bootstrap   base-devel git, 开启 multilib, 没有 yay 时从 AUR 编译
#   ./setup.sh deps        按 packages/*.txt 装包, 按检测到的显卡追加驱动; 装 VSCode / Cursor 扩展和 SPlayer
#   ./setup.sh system      写 /etc (sudo): tty 自动登录、NVIDIA 设置、zh_CN locale, 登录 shell 改为 zsh, 启用网络和蓝牙
#   ./setup.sh deploy      把 dotfiles/ 复制到 ~ (覆盖同名文件, 不删别的), 设置 GTK 深色主题
#   ./setup.sh pull        反过来: 把 ~ 里改过的、dotfiles/ 里已有的文件拷回项目
#   ./setup.sh check       只读体检: 包、自动登录、系统配置、niri 配置、私密数据, 每项打印 ✓ / ✗
# 环境变量: NIRI_TTY=2 在 tty2 自动登录并启动 niri (默认 tty1; tty1 已被别的桌面占用时用)
set -euo pipefail
NIRI=$(cd "$(dirname "$0")"; pwd)
cd "$NIRI"

U=$(id -un)
TTY=${NIRI_TTY:-1}
STATE=$NIRI/state
APPS=${SETUP_APPS:-1}
args=()
for a in "$@"; do [ "$a" = --no-apps ] && APPS=0 || args+=("$a"); done
set -- "${args[@]+"${args[@]}"}"

step() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[33m%s\033[0m\n' "$*"; }
ok()   { printf '  \033[32m✓\033[0m %s\n' "$*"; }
bad()  { printf '  \033[31m✗\033[0m %s\n' "$*"; fails=$((fails + 1)); }

# 包清单: 去掉注释, 每行可写多个包
pkglist() { sed 's/#.*//' "$@" | tr -s ' \t' '\n' | grep -v '^$' || true; }

# 显卡厂商 (每行一个: intel / amd / nvidia), 按 PCI 显示控制器 (class 0x03xxxx) 判断, 不依赖 lspci
gpus() {
    local d
    for d in /sys/bus/pci/devices/*; do
        case $(cat "$d/class" 2>/dev/null) in 0x03*) ;; *) continue ;; esac
        case $(cat "$d/vendor" 2>/dev/null) in
            0x8086) echo intel ;;
            0x1002) echo amd ;;
            0x10de) echo nvidia ;;
        esac
    done | sort -u
}
has_gpu() { gpus | grep -qx "$1"; }

# 本次要装的包: 官方仓库 / AUR
repo_pkgs() {
    local g
    pkglist packages/core.txt
    [ "$APPS" = 1 ] && pkglist packages/apps.txt
    for g in $(gpus); do pkglist "packages/$g.txt"; done
    # dkms 驱动要有对应内核的头文件 (linux -> linux-headers, linux-lts -> linux-lts-headers)
    has_gpu nvidia && for g in /usr/lib/modules/*/pkgbase; do [ -f "$g" ] && echo "$(cat "$g")-headers"; done
    return 0
}
aur_pkgs() {
    pkglist packages/core-aur.txt
    [ "$APPS" = 1 ] && pkglist packages/apps-aur.txt
    return 0
}

# 把模板 $1 (@USER@ 换成当前用户) 装到 $2, 权限 $3; 内容相同时跳过
put_etc() {
    local tmp
    tmp=$(mktemp)
    sed "s/@USER@/$U/g" "$1" > "$tmp"
    if sudo cmp -s "$tmp" "$2"; then echo "  已是最新: $2"
    else sudo install -D -m "$3" -o root -g root "$tmp" "$2" && echo "  已写入: $2"; fi
    rm -f "$tmp"
}

running() { pgrep -u "$U" -f "$1" >/dev/null; }

bootstrap() {
    step "bootstrap: base-devel git multilib yay"
    sudo pacman -S --needed --noconfirm base-devel git
    # multilib: steam 和 lib32-nvidia-utils 在这里
    if ! grep -q '^\[multilib\]' /etc/pacman.conf; then
        sudo sed -i '/^#\[multilib\]/,/^#Include/ s/^#//' /etc/pacman.conf
        sudo pacman -Sy
    fi
    if ! command -v yay >/dev/null; then
        local tmp
        tmp=$(mktemp -d)
        git clone --depth 1 https://aur.archlinux.org/yay-bin.git "$tmp/yay-bin"
        (cd "$tmp/yay-bin" && makepkg -si --noconfirm)
        rm -rf "$tmp"
    fi
}

# install_exts <显示名> <CLI> <清单文件>: 一次命令装完清单里还没装的扩展 (逐个安装会反复启动 Electron, 很慢);
# 滤掉 CLI 读 code-flags.conf 时打印的无害警告
install_exts() {
    local name=$1 cli=$2 list=$3 e args=() have
    command -v "$cli" >/dev/null || return 0
    have=$("$cli" --list-extensions 2>/dev/null || true)
    for e in $(pkglist "$list"); do
        grep -qxi "$e" <<<"$have" || args+=(--install-extension "$e")
    done
    if [ ${#args[@]} -eq 0 ]; then echo "  $name 扩展已全部装好"; return; fi
    echo "  安装 $((${#args[@]} / 2)) 个 $name 扩展 (一次下载完, 需要一两分钟)..."
    "$cli" "${args[@]}" 2>&1 \
        | grep -vE 'not in the list of known|^options, but|DEP0169|trace-deprecation|was created\)' || true
}

deps() {
    step "装包 (显卡: $(gpus | tr '\n' ' ')应用: $([ "$APPS" = 1 ] && echo 装 || echo 不装))"
    # shellcheck disable=SC2046
    sudo pacman -S --needed $(repo_pkgs)
    warn "  装 niri-shorin-fork-git 时 yay 会问是否移除官方 niri, 输入 y (默认 N 会装失败)"
    # shellcheck disable=SC2046
    yay -S --needed $(aur_pkgs)
    [ "$APPS" = 1 ] || return 0

    step "应用附加: VSCode / Cursor 扩展, SPlayer"
    if running '/usr/share/code/code|/usr/share/cursor/cursor|cursor-electron'; then
        warn "  跳过扩展: VSCode / Cursor 正在运行, 关掉后重跑 ./setup.sh deps"
    else
        install_exts VSCode code packages/vscode-extensions.txt
        install_exts Cursor cursor packages/cursor-extensions.txt
    fi
    # 音乐播放器 SPlayer (binds.kdl 里绑了快捷键): 官方 AppImage 自带 Electron, 无需编译
    if [ ! -x ~/.local/share/splayer/SPlayer.AppImage ]; then
        mkdir -p ~/.local/share/splayer
        curl -fL -o ~/.local/share/splayer/SPlayer.AppImage \
            https://github.com/imsyy/SPlayer/releases/download/v3.1.1/splayer-3.1.1-x86_64.AppImage
        chmod +x ~/.local/share/splayer/SPlayer.AppImage
    fi
}

system() {
    step "系统配置 (/etc, 需要 sudo): tty$TTY 自动登录 $U"
    put_etc system/getty-autologin.conf "/etc/systemd/system/getty@tty$TTY.service.d/autologin.conf" 644
    if has_gpu nvidia; then
        put_etc system/modprobe-nvidia.conf /etc/modprobe.d/nvidia.conf 644
        put_etc system/50-limit-free-buffer-pool-in-wayland-compositors.json \
            /etc/nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json 644
    fi
    # 中文界面 / 锁屏的中文星期
    if ! locale -a 2>/dev/null | grep -qi '^zh_CN\.utf8$'; then
        sudo sed -i 's/^#\s*\(zh_CN\.UTF-8 UTF-8\)/\1/' /etc/locale.gen
        sudo locale-gen
    fi
    # ~/.zprofile 在自动登录的 tty 上执行 niri-session, 登录 shell 要是 zsh
    if [ "$(getent passwd "$U" | cut -d: -f7)" != /usr/bin/zsh ] && [ -x /usr/bin/zsh ]; then
        sudo chsh -s /usr/bin/zsh "$U"
    fi
    # 多用户共享的 Steam 库 (见 docx/05-troubleshooting.md): 有这个目录才装
    if [ -d /games/SteamLibrary ]; then
        put_etc system/steam-library-perms.service /etc/systemd/system/steam-library-perms.service 644
        put_etc system/steam-library-perms.path /etc/systemd/system/steam-library-perms.path 644
    fi
    sudo systemctl daemon-reload
    sudo systemctl enable NetworkManager.service bluetooth.service
    [ -d /games/SteamLibrary ] && sudo systemctl enable --now steam-library-perms.path steam-library-perms.service
}

# 这些文件里有家目录的绝对路径, 项目里写成 @HOME@: deploy 时展开, pull 时换回
HOMEPATH_FILES=(.config/waypaper/config.ini .config/gtk-3.0/bookmarks)

# 在 state/stage 组装要放进 ~ 的文件: dotfiles/, 登录脚本里的 @TTY@ 换成实际 tty, @HOME@ 换成家目录
stage() {
    local S=$STATE/stage f
    rm -rf "$S"
    mkdir -p "$STATE"
    cp -a dotfiles "$S"
    rm -f "$S/.config/zsh/local.zsh"                 # 私有文件, 只在 ~ 里维护
    sed -i "s/@TTY@/$TTY/g" "$S/.zprofile" "$S/.bash_profile"
    for f in "${HOMEPATH_FILES[@]}"; do sed -i "s#@HOME@#$HOME#g" "$S/$f"; done
    niri validate -c "$S/.config/niri/config.kdl" >/dev/null 2>&1 \
        || { niri validate -c "$S/.config/niri/config.kdl"; echo "niri 配置校验失败, 没有部署"; exit 1; }
}

deploy() {
    step "部署配置到 $HOME (niri 在 tty$TTY 启动)"
    stage
    rsync -a "$STATE/stage/" "$HOME/"
    chmod 700 "$HOME"                                 # rsync 会把 stage 目录的 755 带过来
    [ -f ~/.config/zsh/local.zsh ] || { cp dotfiles/.config/zsh/local.zsh.example ~/.config/zsh/local.zsh; echo "  已创建 ~/.config/zsh/local.zsh (按需填写)"; }
    LANG=en_US.UTF-8 LANGUAGE=en_US xdg-user-dirs-update --force
    # GTK 深色主题 + 中键粘贴 (新版 GNOME 默认关闭了它): 会话在跑就直接写进 dconf, 否则临时起一个总线
    local cmds='gsettings set org.gnome.desktop.interface color-scheme prefer-dark
                gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3-dark
                gsettings set org.gnome.desktop.interface gtk-enable-primary-paste true
                gsettings set org.gnome.desktop.wm.preferences button-layout minimize,maximize,close'
    if [ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ]; then sh -c "$cmds"
    else dbus-run-session sh -c "$cmds"; fi
    echo "  完成; niri 会自动重新加载配置, waybar / mako 改动要重开 (或重新登录)"
}

pull() {
    step "把 ~ 里改过的文件拷回 dotfiles/"
    local list f
    list=$(mktemp)
    # 只拷两边都有的文件 (~ 里缺的文件会让 rsync 报错退出)
    (cd dotfiles && find . -type f ! -name .zprofile ! -name .bash_profile ! -name local.zsh.example) \
        | while read -r f; do [ -f "$HOME/$f" ] && echo "$f"; done > "$list"
    rsync -a --existing --files-from="$list" "$HOME/" dotfiles/
    rm -f "$list"
    for f in "${HOMEPATH_FILES[@]}"; do sed -i "s#$HOME#@HOME@#g" "dotfiles/$f"; done
    git status --short -- dotfiles | head -40
}

# expect <通过时的说明> <失败时的说明> <命令...>: 命令成功打印 ✓, 否则打印 ✗ 并计数
expect() {
    local good=$1 fail=$2
    shift 2
    if "$@"; then ok "$good"; else bad "$fail"; fi
}
# hint: 同 expect, 但失败只提示不计数 (私密数据这类要手动处理的项)
hint() {
    local good=$1 fail=$2
    shift 2
    if "$@"; then ok "$good"; else warn "  ! $fail"; fi
}
has_secrets() { grep -rlE 'sk-(or|ant)-[A-Za-z0-9]|BEGIN (OPENSSH|PGP) PRIVATE|oauth_token' dotfiles 2>/dev/null | grep -q .; }
local_zsh_filled() { [ -f "$HOME/.config/zsh/local.zsh" ] && ! cmp -s "$HOME/.config/zsh/local.zsh" dotfiles/.config/zsh/local.zsh.example; }

# shellcheck disable=SC2088  # 说明文字里的 ~ 只是给人看的
check() {
    local miss f
    fails=0
    step "体检: 包"
    miss=$(for f in $(repo_pkgs; aur_pkgs); do pacman -Q "$f" >/dev/null 2>&1 || echo "$f"; done | tr '\n' ' ')
    expect "packages/*.txt 全部已装" "未安装: $miss(./setup.sh deps)" test -z "$miss"
    expect "niri 是作者的分支" "niri 不是作者的分支 (./setup.sh deps)" sh -c 'pacman -Q niri 2>/dev/null | grep -q shorin-fork'

    step "体检: 系统配置"
    expect "tty$TTY 自动登录 $U" "tty$TTY 自动登录未配置 (./setup.sh system; 不是 tty$TTY 时设 NIRI_TTY)" \
        grep -qs -- "--autologin $U " "/etc/systemd/system/getty@tty$TTY.service.d/autologin.conf"
    expect "登录 shell 是 zsh" "登录 shell 不是 zsh (./setup.sh system)" \
        test "$(getent passwd "$U" | cut -d: -f7)" = /usr/bin/zsh
    if has_gpu nvidia; then
        expect "NVIDIA modeset" "缺 /etc/modprobe.d/nvidia.conf (./setup.sh system)" test -f /etc/modprobe.d/nvidia.conf
        expect "NVIDIA 下 niri 的显存设置" "缺 NVIDIA 显存设置 (./setup.sh system)" \
            test -f /etc/nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json
    fi
    expect "NetworkManager 已启用" "NetworkManager 未启用 (./setup.sh system)" systemctl is-enabled --quiet NetworkManager.service

    step "体检: 配置"
    expect "niri 配置校验通过" "niri 配置校验失败 (niri validate -c dotfiles/.config/niri/config.kdl)" \
        sh -c 'niri validate -c dotfiles/.config/niri/config.kdl >/dev/null 2>&1'
    expect "~/.zprofile 在 tty$TTY 启动 niri" "~/.zprofile 没有在 tty$TTY 启动 niri (./setup.sh deploy)" \
        grep -qs "/dev/tty$TTY ]" "$HOME/.zprofile"
    expect "$HOME 权限 700" "$HOME 权限是 $(stat -c %a "$HOME"), 别的用户能读 (chmod 700 ~)" \
        test "$(stat -c %a "$HOME")" = 700
    expect "dotfiles/ 里没有密钥" "dotfiles/ 里有密钥, 不要提交" eval '! has_secrets'

    step "提示: 私密数据 (不入库, 从旧电脑手动拷; 见 docx/01-install.md)"
    for f in .ssh .gnupg; do
        hint "~/$f" "没有 ~/$f" test -d "$HOME/$f"
    done
    hint "gh 已登录" "gh 未登录 (gh auth login)" sh -c 'gh auth status >/dev/null 2>&1'
    hint "~/.config/zsh/local.zsh" "~/.config/zsh/local.zsh 还是示例, 没填" local_zsh_filled

    echo
    if [ "$fails" = 0 ]; then printf '\033[1;32m全部通过\033[0m\n'
    else printf '\033[1;31m%d 项未通过\033[0m\n' "$fails"; fi
}

case "${1:-all}" in
    all)    bootstrap; deps; system; deploy; check
            step "完成。重启 (或切到 tty$TTY 重新登录) 即进入 niri" ;;
    bootstrap|deps|system|deploy|pull|check) "$1" ;;
    *)      sed -n '2,13p' "$0"; exit 1 ;;
esac
