#!/data/data/com.termux/files/usr/bin/bash

# Termux-specific exports
export GDK_SCALE=1
export PULSE_SERVER=127.0.0.1
export TERMUX_X11_XSTARTUP="xfce4-session"

# Aliases
alias ll="ls -la"

# Termux X11 launchers
alias xfce4launch="termux-x11 :1"
alias xfce4launch2="termux-x11 :1 -xstartup 'xfce4-session' || echo 'Failed to launch!'"

# ============================================================
# Kali-Style unPrompt Themes - Termux Edition
# Adapted for Android/Termux environment
# ============================================================

# External IP Cache (set once per shell session)
EXTERNAL_IP_CACHE="/data/data/com.termux/files/usr/tmp/.external_ip_cache_$(whoami)"
get_external_ip() {
    if [ ! -f "$EXTERNAL_IP_CACHE" ]; then
        # Try multiple methods to get external IP
        curl -s -m 5 -4 ifconfig.me > "$EXTERNAL_IP_CACHE" 2>/dev/null ||
        curl -s -m 5 -4 icanhazip.com > "$EXTERNAL_IP_CACHE" 2>/dev/null ||
        curl -s -m 5 -4 ipinfo.io/ip > "$EXTERNAL_IP_CACHE" 2>/dev/null ||
        echo "N/A" > "$EXTERNAL_IP_CACHE"
    fi
    cat "$EXTERNAL_IP_CACHE"
}

# Get local IP for Termux (WiFi/Mobile data)
get_local_ip() {
    # Try to get WiFi IP first
    ip addr show wlan0 2>/dev/null | grep -oP 'inet \K[\d.]+' | head -1 ||
    ip addr show rmnet0 2>/dev/null | grep -oP 'inet \K[\d.]+' | head -1 ||
    ip addr show eth0 2>/dev/null | grep -oP 'inet \K[\d.]+' | head -1 ||
    echo "N/A"
}

# Pre-cache external IP when shell starts (runs in background)
precache_external_ip() {
    {
        curl -s -m 5 -4 ifconfig.me > "$EXTERNAL_IP_CACHE" 2>/dev/null ||
        curl -s -m 5 -4 icanhazip.com > "$EXTERNAL_IP_CACHE" 2>/dev/null ||
        curl -s -m 5 -4 ipinfo.io/ip > "$EXTERNAL_IP_CACHE" 2>/dev/null ||
        echo "N/A" > "$EXTERNAL_IP_CACHE"
    } &
}

# Kali-Style 2-Line Prompt with External IP - Termux Optimized
set_kali_prompt() {
    local color="${1:-cyan}"

    case "$color" in
        cyan)
            local C1='\[\e[1;36m\]'  # Bright Cyan
            local C2='\[\e[0;36m\]'  # Cyan
            local SYMBOL='$'
            ;;
        green)
            local C1='\[\e[1;32m\]'  # Bright Green
            local C2='\[\e[0;32m\]'  # Green
            local SYMBOL='$'
            ;;
        red)
            local C1='\[\e[1;31m\]'  # Bright Red
            local C2='\[\e[0;31m\]'  # Red
            local SYMBOL='$'
            ;;
        purple)
            local C1='\[\e[1;35m\]'  # Bright Purple
            local C2='\[\e[0;35m\]'  # Purple
            local SYMBOL='$'
            ;;
        yellow)
            local C1='\[\e[1;33m\]'  # Bright Yellow
            local C2='\[\e[0;33m\]'  # Yellow
            local SYMBOL='$'
            ;;
        blue)
            local C1='\[\e[1;34m\]'  # Bright Blue
            local C2='\[\e[0;34m\]'  # Blue
            local SYMBOL='$'
            ;;
        # ═══════════════════════════════════════════════
        # DOUBLE BAR THEMES
        # ═══════════════════════════════════════════════
        double-cyan)
            local C1='\[\e[1;36m\]'
            local C2='\[\e[0;36m\]'
            local SYMBOL='➜'
            local BARS='╔══ ╚══'
            ;;
        double-green)
            local C1='\[\e[1;32m\]'
            local C2='\[\e[0;32m\]'
            local SYMBOL='⚡'
            local BARS='╔══ ╚══'
            ;;
        # ═══════════════════════════════════════════════
        # TRI-TONE GRADIENT THEMES
        # ═══════════════════════════════════════════════
        neon|cyberpunk)
            local C1='\[\e[1;38;5;201m\]'  # Hot Pink
            local C2='\[\e[1;38;5;51m\]'   # Cyan
            local C3='\[\e[1;38;5;165m\]'  # Purple
            local SYMBOL='▶'
            ;;
        sunset|fire)
            local C1='\[\e[1;38;5;196m\]'  # Red
            local C2='\[\e[1;38;5;208m\]'  # Orange
            local C3='\[\e[1;38;5;226m\]'  # Yellow
            local SYMBOL='🔥'
            ;;
        matrix|hacker)
            local C1='\[\e[1;38;5;46m\]'   # Bright Green
            local C2='\[\e[0;38;5;40m\]'   # Medium Green
            local C3='\[\e[0;38;5;34m\]'   # Dark Green
            local SYMBOL='◆'
            ;;
        witch|occult)
            local C1='\[\e[1;38;5;129m\]'  # Purple
            local C2='\[\e[1;38;5;91m\]'   # Dark Magenta
            local C3='\[\e[1;38;5;54m\]'   # Deep Purple
            local SYMBOL='✦'
            ;;
        vaporwave|retro)
            local C1='\[\e[1;38;5;213m\]'  # Pink
            local C2='\[\e[1;38;5;141m\]'  # Light Purple
            local C3='\[\e[1;38;5;117m\]'  # Sky Blue
            local SYMBOL='◈'
            ;;
        ocean|deep)
            local C1='\[\e[1;38;5;45m\]'   # Aqua
            local C2='\[\e[1;38;5;39m\]'   # Deep Cyan
            local C3='\[\e[1;38;5;33m\]'   # Deep Blue
            local SYMBOL='⬡'
            ;;
        toxic|slime)
            local C1='\[\e[1;38;5;154m\]'  # Lime
            local C2='\[\e[1;38;5;118m\]'  # Bright Green
            local C3='\[\e[1;38;5;82m\]'   # Aqua Green
            local SYMBOL='☢'
            ;;
        blood|vampire)
            local C1='\[\e[1;38;5;196m\]'  # Blood Red
            local C2='\[\e[1;38;5;124m\]'  # Dark Red
            local C3='\[\e[1;38;5;88m\]'   # Deep Red
            local SYMBOL='⚔'
            ;;
        *)
            local C1='\[\e[1;36m\]'
            local C2='\[\e[0;36m\]'
            local SYMBOL='$'
            ;;
    esac

    local RESET='\[\e[0m\]'
    local BOLD='\[\e[1m\]'
    local DIM='\[\e[2m\]'

    # Check if we're using double bars
    if [[ "$color" == double-* ]]; then
        PS1="${C1}╔══${RESET}${DIM}[${RESET}${C1}\u${RESET}${DIM}@${RESET}${C2}\$(get_external_ip)${RESET}${DIM}|${RESET}${C2}\$(get_local_ip)${RESET}${DIM}]══[${RESET}${BOLD}\w${RESET}${DIM}]${RESET}\n${C1}╚══${RESET}${C1}${SYMBOL}${RESET} "
    # Check if we're using tri-tone themes
    elif [[ -n "$C3" ]]; then
        PS1="${C1}┌──${RESET}${DIM}[${RESET}${C1}\u${RESET}${DIM}@${RESET}${C2}\$(get_external_ip)${RESET}${DIM}|${RESET}${C3}\$(get_local_ip)${RESET}${DIM}]─[${RESET}${C2}\w${RESET}${DIM}]${RESET}\n${C1}└─${RESET}${C2}${SYMBOL}${RESET} "
    else
        PS1="${C1}┌──${RESET}${DIM}[${RESET}${C1}\u${RESET}${DIM}@${RESET}${C2}\$(get_external_ip)${RESET}${DIM}|${RESET}${C2}\$(get_local_ip)${RESET}${DIM}]─[${RESET}${BOLD}\w${RESET}${DIM}]${RESET}\n${C1}└─${RESET}${C1}${SYMBOL}${RESET} "
    fi
}

# Prompt Theme Switcher
prompt() {
    case "$1" in
        # Classic Kali Themes
        kali|cyan)
            set_kali_prompt cyan
            echo "✓ Prompt set to: Kali (Cyan) - Classic hacker vibes"
            ;;
        green)
            set_kali_prompt green
            echo "✓ Prompt set to: Kali (Green) - Matrix mode"
            ;;
        red)
            set_kali_prompt red
            echo "✓ Prompt set to: Kali (Red) - Alert status"
            ;;
        purple)
            set_kali_prompt purple
            echo "✓ Prompt set to: Kali (Purple) - Royal treatment"
            ;;
        yellow)
            set_kali_prompt yellow
            echo "✓ Prompt set to: Kali (Yellow) - Sunshine state"
            ;;
        blue)
            set_kali_prompt blue
            echo "✓ Prompt set to: Kali (Blue) - Ocean depths"
            ;;

        # Double Bar Themes
        double-cyan)
            set_kali_prompt double-cyan
            echo "✓ Prompt set to: Double Cyan ➜ - Extra thicc bars"
            ;;
        double-green)
            set_kali_prompt double-green
            echo "✓ Prompt set to: Double Green ⚡ - Lightning strikes"
            ;;

        # Tri-Tone Gradient Themes
        neon|cyberpunk)
            set_kali_prompt neon
            echo "✓ Prompt set to: Neon/Cyberpunk ▶ - Welcome to 2077"
            ;;
        sunset|fire)
            set_kali_prompt sunset
            echo "✓ Prompt set to: Sunset/Fire 🔥 - Feel the burn"
            ;;
        matrix|hacker)
            set_kali_prompt matrix
            echo "✓ Prompt set to: Matrix/Hacker ◆ - Following the white rabbit"
            ;;
        witch|occult)
            set_kali_prompt witch
            echo "✓ Prompt set to: Witch/Occult ✦ - Casting spells"
            ;;
        vaporwave|retro)
            set_kali_prompt vaporwave
            echo "✓ Prompt set to: Vaporwave/Retro ◈ - A E S T H E T I C"
            ;;
        ocean|deep)
            set_kali_prompt ocean
            echo "✓ Prompt set to: Ocean/Deep ⬡ - 20,000 leagues under"
            ;;
        toxic|slime)
            set_kali_prompt toxic
            echo "✓ Prompt set to: Toxic/Slime ☢ - Radioactive vibes"
            ;;
        blood|vampire)
            set_kali_prompt blood
            echo "✓ Prompt set to: Blood/Vampire ⚔ - Hunting at night"
            ;;

        # List all themes
        list)
            echo "═══════════════════════════════════════════════════════"
            echo "  💀 unPrompted Theme Selector - Termux Edition"
            echo "═══════════════════════════════════════════════════════"
            echo "  prompt cyan        - Classic cyan ($)"
            echo "  prompt green       - Matrix green ($)"
            echo "  prompt red         - Alert red ($)"
            echo "  prompt purple      - Royal purple ($)"
            echo "  prompt yellow      - Sunshine yellow ($)"
            echo "  prompt blue        - Ocean blue ($)"
            echo ""
            echo "═══════════════════════════════════════════════════════"
            echo "  ╔══ DOUBLE BAR THEMES ══╗"
            echo "═══════════════════════════════════════════════════════"
            echo "  prompt double-cyan  - Thicc cyan bars (➜)"
            echo "  prompt double-green - Thicc green bars (⚡)"
            echo ""
            echo "═══════════════════════════════════════════════════════"
            echo "    TRI-TONE GRADIENT THEMES ✨"
            echo "═══════════════════════════════════════════════════════"
            echo "  prompt neon        - Pink/Cyan/Purple cyberpunk (▶)"
            echo "  prompt sunset      - Red/Orange/Yellow fire (🔥)"
            echo "  prompt matrix      - Triple green hacker (◆)"
            echo "  prompt witch       - Purple/Magenta occult (✦)"
            echo "  prompt vaporwave   - Pink/Purple/Blue retro (◈)"
            echo "  prompt ocean       - Aqua/Cyan/Blue depths (⬡)"
            echo "  prompt toxic       - Lime/Green/Aqua slime (☢)"
            echo "  prompt blood       - Red gradient vampire (⚔)"
            ;;
        refresh)
            # Refresh IP cache
            rm -f "$EXTERNAL_IP_CACHE"
            precache_external_ip
            echo "✓ IP cache refreshed"
            ;;
        *)
            echo "Usage: prompt [theme|list|refresh]"
            echo "Run 'prompt list' to see all available themes"
            echo "Run 'prompt refresh' to update external IP"
            ;;
    esac
}

# Initialize - Pre-cache IP and set default theme
precache_external_ip
set_kali_prompt cyan

echo "✓ unPrompted Themes loaded! Use 'prompt list' to see options."