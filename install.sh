#!/usr/bin/env bash

# Jarema's dotfiles installer
DOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Format: "App name|sourcedir|targetdir"
APPS=(
  "bash (System)|bash|$HOME"
  "zsh (System)|zsh|$HOME"
  "git (System)|git|$HOME"
  "ssh (System)|.ssh|$HOME/.ssh"
  "Code (VSCode native)|Code|$HOME/.config/Code/User"
  "Code (VSCode Flatpak)|Code|$HOME/.var/app/com.visualstudio.code/config/Code/User"
  "zed (Code Editor)|zed|$HOME/.config/zed"
  "firefox (Browser)|firefox|SPECIAL_FIREFOX"
  "equibop (Social)|equibop|$HOME/.config/equibop"
  "SchildiChatRevenge (Social)|SchildiChatRevenge|$HOME/.config/SchildiChatRevenge"
  "BeeperTexts (Social)|BeeperTexts|$HOME/.config/BeeperTexts"
  "YouTube Music (Media)|YouTube Music|$HOME/.config/YouTube Music"
  "Tauon Music Box (Flatpak)|com.github.taiko2k.tauonmb|$HOME/.var/app/com.github.taiko2k.tauonmb"
  "Vesktop (Flatpak)|dev.vencord.Vesktop|$HOME/.var/app/dev.vencord.Vesktop"
  "Komikku (Flatpak)|info.febvre.Komikku|$HOME/.var/app/info.febvre.Komikku"
  "NewsFlash (Flatpak)|io.gitlab.news_flash.NewsFlash|$HOME/.var/app/io.gitlab.news_flash.NewsFlash"
  "Mission Center (Flatpak)|io.missioncenter.MissionCenter|$HOME/.var/app/io.missioncenter.MissionCenter"
  "Gear Lever (Flatpak)|it.mijorus.gearlever|$HOME/.var/app/it.mijorus.gearlever"
  "Sober (Flatpak)|org.vinegarhq.Sober|$HOME/.var/app/org.vinegarhq.Sober"
  "Lunar Client (Media/Games)|.lunarclient|$HOME/.lunarclient"
)

SELECTED=()
for i in "${!APPS[@]}"; do SELECTED[$i]=0; done
CURRENT=0

function draw_menu() {
    tput cup 0 0
    echo "Select the apps you want to install dotfiles for."
    echo "Use UP/DOWN to navigate, SPACE to toggle, ENTER to confirm."
    echo ""
    for i in "${!APPS[@]}"; do
        local name="${APPS[$i]%%|*}"

        if [ "$i" -eq "$CURRENT" ]; then
            echo -en "\033[1;32m> "
        else
            echo -en "  "
        fi

        if [ "${SELECTED[$i]}" -eq 1 ]; then
            echo -en "[x] "
        else
            echo -en "[ ] "
        fi

        echo -e "${name}\033[0m"
    done
}

tput smcup
clear
echo -en "\033[?25l"

while true; do
    draw_menu
    IFS= read -rsn1 key
    if [[ $key == "" ]]; then break; fi
    if [[ $key == $'\x1b' ]]; then
        read -rsn2 -t 0.1 key2
        if [[ $key2 == "[A" ]]; then
            ((CURRENT--))
            if [ $CURRENT -lt 0 ]; then CURRENT=$((${#APPS[@]} - 1)); fi
        elif [[ $key2 == "[B" ]]; then
            ((CURRENT++))
            if [ $CURRENT -ge ${#APPS[@]} ]; then CURRENT=0; fi
        fi
    elif [[ $key == " " ]]; then
        SELECTED[$CURRENT]=$((1 - SELECTED[$CURRENT]))
    fi
done

echo -en "\033[?25h"
tput rmcup

echo "Installing selected dotfiles..."
echo ""

function copy_dir_contents() {
    local src="$1" dest="$2"
    if [ ! -d "$src" ]; then
        echo "Warning: Source directory $src not found!"
        return
    fi
    mkdir -p "$dest"
    for file in "$src"/* "$src"/.[!.]* "$src"/..?*; do
        [ -e "$file" ] || [ -L "$file" ] || continue

        local target="$dest/$(basename "$file")"
        if [ -e "$target" ] || [ -L "$target" ]; then
            echo -e "\033[1;33mWarning: $target already exists.\033[0m"
            while true; do
                read -p "Choose action - [S]kip app, [O]verride file, [M]erge (experimental), [Q]uit install: " action
                case "$action" in
                    [Ss]* )
                        echo "Skipping app..."
                        return 1
                        ;;
                    [Oo]* )
                        echo "Overriding $(basename "$file")..."
                        rm -rf "$target"
                        cp -r "$file" "$target"
                        echo "Copied $(basename "$file") -> $dest/"
                        break
                        ;;
                    [Mm]* )
                        if [[ "$file" == *.json ]] && command -v jq &> /dev/null; then
                            echo "Smart merging JSON (preferring existing $target)..."
                            temp_file=$(mktemp)
                            jq -s '.[0] * .[1]' "$file" "$target" > "$temp_file"
                            mv "$temp_file" "$target"
                            echo "Merged $(basename "$file") -> $dest/"
                            break
                        elif [[ $(file --mime-type -b "$file") == text/* ]]; then
                            echo "Appending to existing text file $target..."
                            echo -e "\n# --- Appended from Jarema's dotfiles installer ---\n" >> "$target"
                            cat "$file" >> "$target"
                            echo "Merged $(basename "$file") -> $dest/"
                            break
                        else
                            echo "Merging is only supported for JSON files (requires 'jq') or plaintext files."
                            echo "Please choose another action."
                        fi
                        ;;
                    [Qq]* )
                        echo "Stopping installation."
                        exit 1
                        ;;
                    * )
                        echo "Please answer S, O, M, or Q."
                        ;;
                esac
            done
        else
            cp -r "$file" "$target"
            echo "Copied $(basename "$file") -> $dest/"
        fi
    done
    return 0
}

any_selected=0
for i in "${!APPS[@]}"; do
    if [ "${SELECTED[$i]}" -eq 1 ]; then
        any_selected=1

        IFS='|' read -r name src_dir target_dir <<< "${APPS[$i]}"
        echo "--- Installing $name ---"

        if [ "$target_dir" == "SPECIAL_FIREFOX" ]; then
            echo "Installing Firefox profile configs..."
            if [ -d "$HOME/.mozilla/firefox" ]; then
                for profile in "$HOME/.mozilla/firefox/"*.default*; do
                    if [ -d "$profile" ]; then
                        echo "Copying to Firefox profile: $(basename "$profile")"
                        copy_dir_contents "$DOTDIR/$src_dir/profile" "$profile" || break
                    fi
                done
            else
                echo "Firefox profile not found in ~/.mozilla/firefox"
            fi
            echo "Note: To install system-wide Firefox configs, you must run:"
            echo "sudo cp -r $DOTDIR/firefox/defaults $DOTDIR/firefox/distribution $DOTDIR/firefox/firefox.cfg /usr/lib64/firefox/"
        else
            copy_dir_contents "$DOTDIR/$src_dir" "$target_dir"
        fi
        echo ""
    fi
done

if [ "$any_selected" -eq 0 ]; then
    echo "No apps selected. Exiting."
else
    echo "Done!"
fi
