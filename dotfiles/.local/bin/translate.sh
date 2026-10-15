#!/bin/bash
# 翻译 (translate-shell): 含汉字 -> 英文, 否则 -> 中文; 结果用通知显示 (取自 dwm2 的 bin/translate.sh, 改为 Wayland)
#   translate.sh            翻译鼠标选中的文字 (Super + Y)
#   translate.sh input      弹出 fuzzel 输入框, 翻译输入的文字, 并把译文复制到剪贴板 (Super + Shift + Y)

export LC_ALL=C.UTF-8
# 上一条翻译通知的 id (notify-send -p 打印) 记在这里: 新通知替换旧通知, 不会堆叠
NID_FILE=${XDG_RUNTIME_DIR:-/tmp}/translate-notify-id

notify() {
    local id
    id=$(notify-send -p -r "$(cat "$NID_FILE" 2>/dev/null || echo 0)" -t "${3:-15000}" "$1" "$2")
    echo "$id" > "$NID_FILE"
}
# mako 开启了 markup, 译文中的 & < > 需要转义
escape() { sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g'; }

command -v trans >/dev/null || { notify "󰗊 翻译" "未安装 translate-shell: sudo pacman -S translate-shell"; exit 1; }

case $1 in
    input) text=$(fuzzel --dmenu --lines 0 -p "󰗊 翻译 " < /dev/null) ;;
    *)     text=$(wl-paste -p -n 2>/dev/null) ;;
esac
text=$(printf '%s' "$text" | tr '\n' ' ' | sed 's/^ *//; s/ *$//')
[ -z "$text" ] && { notify "󰗊 翻译" "没有选中文字" 3000; exit 0; }

if printf '%s' "$text" | grep -qP '\p{Han}'; then target=en; else target=zh; fi

notify "󰗊 翻译中..." "$(printf '%s' "$text" | head -c 300 | escape)" 30000
result=$(trans -b -no-autocorrect ":$target" "$text" 2>/dev/null)
[ -z "$result" ] && { notify "󰗊 翻译失败" "请检查网络连接" 5000; exit 1; }

[ "$1" = input ] && printf '%s' "$result" | wl-copy
notify "󰗊 $( [ $target = en ] && echo 中 → 英 || echo 英 → 中 )$( [ "$1" = input ] && echo ' (已复制)')" \
    "<b>$(printf '%s' "$result" | escape)</b>\n\n$(printf '%s' "$text" | head -c 300 | escape)"
