[ -f ~/.bashrc ] && . ~/.bashrc
# 自动登录的 tty 上进入 niri (niri-session 走 systemd, XDG 自启动的 fcitx5 也由它拉起)
# @TTY@ 由 ./setup.sh deploy 换成 NIRI_TTY (默认 1)
# 只在交互式登录 shell 里启动, 并带 -l: niri-session 不带 -l 时会再开一个登录 shell (bash -l -c),
# 那个 shell 又读到这里, 就会无限循环
if [[ $- == *i* ]] && [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = /dev/tty@TTY@ ]; then
    exec niri-session -l
fi
