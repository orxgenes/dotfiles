# dotfiles

A Fedora Hyprland setup with a Quickshell bar and dock, installed and linked
by scripts in this repository.

Hyprland provides the compositor and keybindings; Quickshell draws the top bar
and dock on top of it. Both read their configuration from `config/` in this
repo, which gets symlinked into `~/.config`.

## Requirements

- Fedora (the install scripts check for `/etc/fedora-release`)
- A Wayland-capable GPU driver
- A normal user account with `sudo` access — the scripts refuse to run as root

## Install

```sh
make bootstrap
```

That installs packages, then links the configurations. Equivalent to running
`./bootstrap.sh`, which chains the three scripts in `install/` and finishes
with `./link.sh`.

Steps can also be run individually:

```sh
make prerequisites   # base desktop dependencies and kitty
make hyprland        # Hyprland, portals, wofi, thunar
make quickshell      # Quickshell
make link            # just (re)link the configs
```

Afterwards, log out and start a Hyprland session.

Quickshell is not available in the default Fedora repositories yet. If it
cannot be found, `20-quickshell.sh` stops and explains rather than adding a
third-party repository behind your back.

## Linking

`link.sh` symlinks `config/hypr` and `config/quickshell` into `~/.config`, so
editing a file in this repo changes your live configuration and `git` tracks
every change.

It will not delete anything. A real file, or a symlink pointing somewhere
else, is moved to `<name>.bak.<timestamp>` before the link is created.

```sh
./link.sh --dry-run   # show the plan, change nothing
./link.sh             # link
./link.sh --unlink    # remove the links, restore the newest backup
```

## Layout

```
bootstrap.sh          Full setup: packages, then link
link.sh               Symlink config/ into ~/.config, and back out
Makefile              Entry points; run 'make help'
config/
  hypr/               Hyprland
    hyprland.conf       Entry point; sources the rest
    environment.conf    Environment variables
    monitors.conf       Monitor layout
    rules.conf          Window rules
    keybinds.conf       Keybindings
  quickshell/         Quickshell shell
    shell.qml           Shell root
    bar/                Top bar and its widgets
    dock/               Dock and its items
    components/         Reusable pieces (GlassPanel, AppIcon)
    config/             Theme (Colors, Appearance singletons)
install/
  00-prerequisites.sh Base dependencies and kitty
  10-hyprland.sh      Hyprland and desktop utilities
  20-quickshell.sh    Quickshell
  lib/common.sh       Shared shell helpers
```

## Keybindings

`SUPER` is the main modifier.

| Binding               | Action                          |
| --------------------- | ------------------------------- |
| `SUPER` `Return`      | Terminal (kitty)                |
| `SUPER` `Space`       | Application launcher (wofi)     |
| `SUPER` `E`           | File manager (thunar)           |
| `SUPER` `Q`           | Close window                    |
| `SUPER` `V`           | Toggle floating                 |
| `SUPER` `F`           | Toggle fullscreen               |
| `SUPER` `H` `J` `K` `L` | Move focus (left, down, up, right) |
| `SUPER` `Shift` `H` `J` `K` `L` | Move window             |
| `SUPER` `1`–`0`       | Switch to workspace 1–10        |
| `SUPER` `Shift` `1`–`0` | Move window to workspace 1–10 |
| `SUPER` `Shift` `Q`   | Exit Hyprland                   |
| `SUPER` `Shift` `R`   | Reload configuration            |
| `SUPER` + left drag   | Move window                     |
| `SUPER` + right drag  | Resize window                   |

## Theming

Two QML singletons hold the theme:

- `config/quickshell/config/Colors.qml` — every colour in the shell
- `config/quickshell/config/Appearance.qml` — bar and dock metrics

Change a value there and reload with `make reload`.

## Notes

- The shell is written against a recent Quickshell. Its QML API moves quickly,
  so `Hyprland.*`, `Quickshell.iconPath()` and `SystemClock` in particular may
  need adjusting for older versions.
- The workspace indicator reads its state from Hyprland, so it is empty when
  the shell runs outside a Hyprland session.
- CI runs `shellcheck` over the shell scripts. QML is not linted, because
  `qmllint` cannot resolve the Quickshell module or the relative directory
  imports used here without a build step.
