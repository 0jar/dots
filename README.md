# Jarema's dotfiles
This repository contains configuration files and settings for apps I use.

## Apps

### System
*   **[zsh](./zsh) & [bash](./bash)**: shell configs
*   **[Git](./git)** config
*   **[SSH](./ssh)** configs

### Code editors
*   **[Visual Studio Code](./Code)**: keybinds and QoL settings
*   **[Zed](./zed)** [(website)](https://zed.dev): usability settings

### Browsers
*   **[Firefox](./firefox)**: hardening configs
*   **[uBlock Origin](./ublock-origin)**: custom filters
*   **[Mullvad Browser](./Mullvad)**: extension settings

### Social
*   **[Vesktop](./dev.vencord.Vesktop)** & **[Equibop](./equibop)** : settings for custom Discord clients
*   **[SchildiChat Revenge](./SchildiChatRevenge)** [(website)](https://schildi.chat): preferences for a Matrix client
*   **[Beeper](./BeeperTexts)** [(website)](https://beeper.com): configs for a Matrix chat app

### Media
*   **[Komikku](./info.febvre.Komikku)**\: settings keyfile for a comics reader
*   **[NewsFlash](./io.gitlab.news_flash.NewsFlash)** [(website)](https://gitlab.com/news-flash/news_flash_gtk): preferences for a RSS reader
*   **[Mission Center](./io.missioncenter.MissionCenter)** [(website)](https://gitlab.com/mission-center-devs/mission-center): settings keyfile for a system monitor
*   **[Gear Lever](./it.mijorus.gearlever)** [(website)](https://github.com/mijorus/gearlever): configs for an AppImage manager
*   **[Sober](./org.vinegarhq.Sober)** & **[Lunar Client](./.lunarclient)**: settings for game clients
*   **[YouTube Music](./YouTube%20Music)**: configs for a YouTube Music desktop player

## Installation

### Interactive installer

Run `./install.sh` to launch the interactive dotfiles installer. You can select which apps you want to install configurations for and it will copy the files to their locations.

```bash
Select the apps you want to install dotfiles for.
Use UP/DOWN to navigate, SPACE to toggle, ENTER to confirm.

> [x] bash (System)
  [ ] zsh (System)
      ...
```

If it detects existing files, it will prompt you with options to skip, override, halt process, or merge (JSON and plaintext) to preserve your current settings.

```bash
$ ./install.sh
Installing selected dotfiles...

--- Installing app X ---
Warning: /home/path/to/existing/file already exists.
Choose action - [S]kip app, [O]verride file, [M]erge (experimental), [Q]uit install:
```

### Manually copy to paths

*   zsh, bash, git: Directly in your home directory (`~/.zshrc`, `~/.bashrc`, `~/.gitconfig`).
*   ssh: The `.ssh` folder directly in your home directory.
*   **Code editors**:
    *   VSCode: `~/.config/Code/User/` (native) or `~/.var/app/com.visualstudio.code/config/Code/User/` (Flatpak).
    *   Zed: `~/.config/zed/`.
*   **Browsers & extensions**:
    *   Firefox: Profile configs are in `~/.mozilla/firefox/<profile>/`. Firefox configs go in `/usr/lib64/firefox/`.
        *   If using Zen Browser, the profile path is `~/.zen/<profile>/`. You only need to extract `user.js`.
    *   uBlock Origin: Restore from the backup file in the extension's settings UI.
    *   Mullvad Browser extension: Import settings directly through the extension's UI.
*   **Other apps**:
    *   Equibop: `~/.config/equibop/`.
    *   SchildiChat Revenge: `~/.config/SchildiChatRevenge/`.
    *   Beeper: `~/.config/BeeperTexts/`.
    *   YouTube Music: `~/.config/YouTube Music/`.
*   **Flatpaks**: For most Flatpak apps (Tauon, Vesktop, Komikku, NewsFlash, Mission Center, Gear Lever, Sober, etc.), settings go into their respective app data folders: `~/.var/app/<app-id>/`.

## License
This repository is licensed under GPLv3, see [LICENSE](./LICENSE).
