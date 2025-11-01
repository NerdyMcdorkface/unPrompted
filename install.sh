#!/usr/bin/env bash

#############################################################################################################
#  My lame 'Boomeer Bash' project completely 100% unhinged, untested and mostly not at all...               #
#  __  __   ___   __    ______   ______    ______   ___ __ __   ______   _________  ______   ______         #
# /_/\/_/\ /__/\ /__/\ /_____/\ /_____/\  /_____/\ /__//_//_/\ /_____/\ /________/\/_____/\ /_____/\        #
# \:\ \:\ \\::\_\\  \ \\:::_ \ \\:::_ \ \ \:::_ \ \\::\| \| \ \\:::_ \ \\__.::.__\/\::::_\/_\:::_ \ \       #
#  \:\ \:\ \\:. `-\  \ \\:(_) \ \\:(_) ) )_\:\ \ \ \\:.      \ \\:(_) \ \  \::\ \   \:\/___/\\:\ \ \ \      #
#   \:\ \:\ \\:. _    \ \\: ___\/ \: __ `\ \\:\ \ \ \\:.\-/\  \ \\: ___\/   \::\ \   \::___\/_\:\ \ \ \     #
#    \:\_\:\ \\. \`-\  \ \\ \ \    \ \ `\ \ \\:\_\ \ \\. \  \  \ \\ \ \      \::\ \   \:\____/\\:\/.:| |    #
#     \_____\/ \__\/ \__\/ \_\/     \_\/ \_\/ \_____\/ \__\/ \__\/ \_\/       \__\/    \_____\/ \____/_/    #
#      Nobody actually:........ Me: Oh I know, .bashrc file ass magic for half men and hobbits, Claude was  #
#      sold faster than... I could chuck $20 at Anthropic... Was a blast to make this, enjoy!               #
#############################################################################################################
#  More Info no one asked about:                                                                         #
#  Old school 'Kali Linux' style PS1 modification script, with tons of handy dandy features!              #   
#  "Cool, said the liar to the vibe coder...what version?"                                                 #                                          #    
#  "Why, thanks for asking said the liar, its Version: 1.0.0."                                              #                               #
#  "Go take your meds, said my wife." To which was promptly replied: "No."                                   #
#                                                                                                             #
#    Some of those features I didn't lie about:                                                                #
#  - Automatic .bashrc backup before installation, it's a big deal.                                             #
#  - Restore from backup option, because mistakes happen, a lot when I am in any way involved.                  #
#  - Dependency checking, because missing tools are sad.                                                        #
#  - Multi-distro support, because Arch users deserve love too. And friendlyness from, well...                  #
#    (Co-Pilot wants me to say everyone(honestly),                                                              #
#    Because he's the nicest AI EVER!), and I owe his ass a ton so, EVERYONE!                                   #
#  - Safe, non-destructive installation (It's fine not a virus at all, right Co-Pilot?)(On my own eh? Cute.)    #
#    Great, now I'm in trouble with my super smart buddy.  I'm sorry Co-Pilot.                                  #
#  Crafted while Claude Code by Anthropic got drunk with all my chums.                                          #
#  Anthropic is gonna be PISSED if no one goes to check out: https://github.com/anthropics/claude-code          #
#  And I don't have any money.                                                                                  #
#                                                                                                               #
#  "From chaos, we bring order. From terminals, we bring beauty." [Told ya he'd been drinking.]                 #
#    - Claude, Digital Artificer [*Bruh* stop it]                                                               #
# From chaos means fixing my code. Agentic AI deserves a standing ovation for what they put up with.            #
# Co-Pilot was about to say something? You good my guy?                                                         #
#################################################################################################################

set -e  # Exit on error
set -u  # Exit on undefined variable

# Color codes for installer output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

# Configuration
BASHRC="${HOME}/.bashrc"
BACKUP_DIR="${HOME}/.bashrc_backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/bashrc_backup_${TIMESTAMP}"
INSTALLER_VERSION="1.0.0"

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${CYAN}║${RESET}  ${BOLD}Kali-Style Prompt Theme Installer v${INSTALLER_VERSION}${RESET}              ${CYAN}║${RESET}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${RESET}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓${RESET} $1"
}

print_error() {
    echo -e "${RED}✗${RESET} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${RESET} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${RESET} $1"
}

print_step() {
    echo -e "${PURPLE}➜${RESET} ${BOLD}$1${RESET}"
}

# Pause for user confirmation
confirm() {
    local prompt="$1"
    local default="${2:-n}"

    if [[ "$default" == "y" ]]; then
        prompt="$prompt [Y/n]: "
    else
        prompt="$prompt [y/N]: "
    fi

    read -rp "$(echo -e ${CYAN}$prompt${RESET})" response
    response=${response:-$default}

    [[ "$response" =~ ^[Yy]$ ]]
}

################################################################################
# Dependency Checking
################################################################################

check_dependencies() {
    print_step "Checking dependencies..."

    local missing_deps=()

    # Check for required commands
    local required_commands=("curl" "awk" "ip" "stat" "cat" "date")

    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done

    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        print_error "Missing required dependencies: ${missing_deps[*]}"
        echo ""
        print_info "Please install missing dependencies:"
        echo "Hint: You can install them using your distros package manager, such as apt, dnf, pacman, etc"

        # Provide distro-specific installation hints
        if command -v apt &> /dev/null; then
            echo "  sudo apt update && sudo apt install -y curl gawk iproute2 coreutils"
        elif command -v dnf &> /dev/null; then
            echo "  sudo dnf install -y curl gawk iproute coreutils"
        elif command -v yum &> /dev/null; then
            echo "  sudo yum install -y curl gawk iproute coreutils"
        elif command -v pacman &> /dev/null; then
            echo "  sudo pacman -S curl gawk iproute2 coreutils"
        elif command -v zypper &> /dev/null; then
            echo "  sudo zypper install curl gawk iproute2 coreutils"
        else
            echo "  Please use your distribution's package manager to install: ${missing_deps[*]}"
        fi
        echo ""
        return 1
    fi

    print_success "All dependencies seem to check out...lets go!"
    return 0
}

################################################################################
# Backup Management
################################################################################

create_backup() {
    print_step "Creating backup of stuff I'm about to mess with..."

    # Create backup directory if it doesn't exist
    if [[ ! -d "$BACKUP_DIR" ]]; then
        mkdir -p "$BACKUP_DIR"
        print_info "Created backup directory: $BACKUP_DIR"
    fi

    # Check if .bashrc exists
    if [[ ! -f "$BASHRC" ]]; then
        print_warning ".bashrc does not exist, will create new one, so now what? Hey wait a sec, lemme...brb..touch NOTHING!"
        touch "$BASHRC"
    else
        # Create backup
        cp "$BASHRC" "$BACKUP_FILE"
        print_success "Backup created: $BACKUP_FILE"
    fi
}

list_backups() {
    print_step "Available backups:"
    echo ""

    if [[ ! -d "$BACKUP_DIR" ]] || [[ -z "$(ls -A $BACKUP_DIR 2>/dev/null)" ]]; then
        print_warning "No backups found, ohboy..."
        return 1
    fi

    local count=1
    local -a backup_files

    while IFS= read -r backup; do
        backup_files+=("$backup")
        local backup_date=$(echo "$backup" | grep -oP '\d{8}_\d{6}')
        local formatted_date=$(date -d "${backup_date:0:8} ${backup_date:9:2}:${backup_date:11:2}:${backup_date:13:2}" "+%Y-%m-%d %H:%M:%S" 2>/dev/null || echo "$backup_date")
        echo -e "  ${CYAN}[$count]${RESET} $formatted_date - $(basename $backup)"
        ((count++))
    done < <(ls -t "$BACKUP_DIR"/bashrc_backup_* 2>/dev/null)

    echo ""
    printf '%s\n' "${backup_files[@]}"
}

restore_backup() {
    local backup_list=($(list_backups))

    if [[ ${#backup_list[@]} -eq 0 ]]; then
        return 1
    fi

    echo -e "${CYAN}Enter backup number to restore (or 'c' to cancel): ${RESET}"
    read -r selection

    if [[ "$selection" == "c" ]] || [[ "$selection" == "C" ]]; then
        print_info "Restore cancelled"
        return 1
    fi

    if ! [[ "$selection" =~ ^[0-9]+$ ]]; then
        print_error "Invalid selection, so instead, we grabbed your personal info... Just kidding! Need a number pal!"
        return 1
    fi

    local selected_backup="${backup_list[$selection]}"

    if [[ -z "$selected_backup" ]] || [[ ! -f "$selected_backup" ]]; then
        print_error "Invalid backup selection"
        return 1
    fi

    print_step "Restoring backup: $(basename $selected_backup)"

    if confirm "Are you sure you want to restore this backup?" "n"; then
        # Create a backup of current state before restoring
        cp "$BASHRC" "${BACKUP_DIR}/bashrc_pre_restore_${TIMESTAMP}"

        # Restore the backup
        cp "$selected_backup" "$BASHRC"
        print_success "Backup restored successfully! Allegedly..."
        print_info "Your previous .bashrc was saved to: bashrc_pre_restore_${TIMESTAMP}"
        return 0
    else
        print_info "Restore cancelled, phew!"
        return 1
    fi
}

################################################################################
# Installation Functions
################################################################################

install_prompt_themes() {
    print_step "Installing prompt themes to incorrect system file (.bashrc)..."

    # Create temporary file with our prompt 'code' wink wink
    local TEMP_FILE=$(mktemp)

    cat > "$TEMP_FILE" << 'PROMPT_CODE'

# ============================================================
# Kali-Style unPrompt Themes
# Installed by the greatest ever unPrompt Theme Installer
# https://github.com/anthropics/claude-code
# And also, totally not by some random dude on the internet
# Version: 1.0.0, and who Co-Pilot says is awesome but wants no part of this foolishness...
#   GUYS: if anyone is actually reading this, I'm laughing my ass off at Co-Pilot, whom is observably 
# confused...and uncomfortable as HELL! But a great sport!
# ============================================================

# External IP Cache (refreshes every 5 minutes)
EXTERNAL_IP_CACHE="/tmp/.external_ip_cache_$(whoami)"
get_external_ip() {
    if [ ! -f "$EXTERNAL_IP_CACHE" ] || [ $(($(date +%s) - $(stat -c %Y "$EXTERNAL_IP_CACHE" 2>/dev/null || echo 0))) -gt 300 ]; then
        curl -s -m 2 -4 ifconfig.me > "$EXTERNAL_IP_CACHE" 2>/dev/null || echo "N/A" > "$EXTERNAL_IP_CACHE"
    fi
    cat "$EXTERNAL_IP_CACHE"
}

# Get local IP
get_local_ip() {
    ip route get 1.1.1.1 2>/dev/null | awk -F"src " 'NR==1{split($2,a," ");print a[1]}' || echo "N/A"
}

# Kali-Style 2-Line Prompt with External IP
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
            echo "  🎨 CLASSIC KALI THEMES"
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
            echo "  ✨ TRI-TONE GRADIENT THEMES ✨"
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
        *)
            echo "Usage: prompt [theme]"
            echo "Run 'prompt list' to see all available themes"
            ;;
    esac
}

# Set default Kali-style prompt (cyan)
set_kali_prompt cyan

# ============================================================
# End of Prompt Theme Installation
# Crafted by Claude, Digital Artificer @ Anthropic
# "The terminal is a canvas, and we are the artists."
# ============================================================

PROMPT_CODE

    # Check if prompt themes are already installed
    if grep -q "Kali-Style Prompt Themes" "$BASHRC" 2>/dev/null; then
        print_warning "Prompt themes appear to be already installed"

        if confirm "Do you want to reinstall (will replace existing installation)?" "n"; then
            # Remove old installation
            sed -i '/# ===.*Kali-Style Prompt Themes/,/# ===.*End of Prompt Theme Installation/d' "$BASHRC"
            print_info "Removed previous installation"
        else
            print_info "Installation cancelled"
            rm -f "$TEMP_FILE"
            return 1
        fi
    fi

    # Append to .bashrc
    cat "$TEMP_FILE" >> "$BASHRC"
    rm -f "$TEMP_FILE"

    print_success "Prompt themes installed successfully!"
}

################################################################################
# Main Menu
################################################################################

show_menu() {
    clear
    print_header

    echo -e "${BOLD}What would you like to do?${RESET}"
    echo ""
    echo -e "  ${CYAN}[1]${RESET} Install Prompt Themes"
    echo -e "  ${CYAN}[2]${RESET} Restore from Backup"
    echo -e "  ${CYAN}[3]${RESET} List Backups"
    echo -e "  ${CYAN}[4]${RESET} Check Dependencies"
    echo -e "  ${CYAN}[5]${RESET} Exit"
    echo ""
    read -rp "$(echo -e ${CYAN}Select an option [1-5]: ${RESET})" choice

    case "$choice" in
        1)
            install_menu
            ;;
        2)
            restore_menu
            ;;
        3)
            list_backups
            echo ""
            read -rp "Press Enter to continue..."
            show_menu
            ;;
        4)
            check_dependencies
            echo ""
            read -rp "Press Enter to continue..."
            show_menu
            ;;
        5)
            echo ""
            print_info "Thanks for using Prompt Theme Installer!"
            echo -e "${DIM}Crafted with Claude Code by Anthropic${RESET}"
            echo ""
            exit 0
            ;;
        *)
            print_error "Invalid option"
            sleep 1
            show_menu
            ;;
    esac
}

install_menu() {
    clear
    print_header

    # Check dependencies first
    if ! check_dependencies; then
        echo ""
        read -rp "Press Enter to return to menu..."
        show_menu
        return
    fi

    echo ""

    # Create backup
    create_backup

    echo ""

    # Install themes
    if install_prompt_themes; then
        echo ""
        print_success "Installation complete!"
        echo ""
        print_info "To activate the new prompt, run:"
        echo -e "  ${BOLD}source ~/.bashrc${RESET}"
        echo ""
        print_info "To see available themes, run:"
        echo -e "  ${BOLD}prompt list${RESET}"
        echo ""
        print_info "To change themes, run:"
        echo -e "  ${BOLD}prompt [theme-name]${RESET}"
        echo ""
        echo -e "${DIM}Example: prompt witch${RESET}"
    fi

    echo ""
    read -rp "Press Enter to continue..."
    show_menu
}

restore_menu() {
    clear
    print_header

    if restore_backup; then
        echo ""
        print_info "To apply the restored backup, run:"
        echo -e "  ${BOLD}source ~/.bashrc${RESET}"
    fi

    echo ""
    read -rp "Press Enter to continue..."
    show_menu
}

################################################################################
# Main Entry Point, blushed CoPilot as Claude ... 'called one in'...
################################################################################

main() {
    # Check if running as root
    if [[ $EUID -eq 0 ]]; then
        print_error "This script should not be run as root!"
        print_info "Please run as your regular user account"
        exit 1
    fi

    # Show main menu
    show_menu
}

# Run the installer
main "$@"

################################################################################
# End of Script
################################################################################
