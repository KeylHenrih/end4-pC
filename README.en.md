<div align="center">

# 💠 end4-pC

**A fork of [end4-pC](https://github.com/pctrade/end4-pC) by [@pctrade](https://github.com/pctrade),
itself a fork of [illogical-impulse](https://github.com/end-4/dots-hyprland) by [@end-4](https://github.com/end-4)**
Maintained by **KeylHenrih**

[Русский](README.md) | [English](README.en.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md)

</div>

---

## 🎬 Showcase

<p align="center">
  <a href="https://www.youtube.com/watch?v=o0Vsh7eVchs">
    <img src="https://img.youtube.com/vi/o0Vsh7eVchs/maxresdefault.jpg" alt="Material 3 Expressive x Linux" width="85%" style="border-radius: 12px; box-shadow: 0px 10px 30px rgba(0,0,0,0.5);"/>
  </a>
</p>

---

## 📸 Screenshots

<div align="center">

| 🎵 Lyrics | 🖼️ Online Wallpapers |
|:---:|:---:|
| ![Screenshot 1](screenshots/1.png) | ![Screenshot 2](screenshots/2.png) |
| 🪟 Desktop Widgets | 🔧 Hyprland Configs |
| ![Screenshot 5](screenshots/5.png) | ![Screenshot 6](screenshots/6.png) |
| ⚙️ Configurable Bar | ✨ And More |
| ![Screenshot 3](screenshots/3.png) | ![Screenshot 4](screenshots/4.png) |

</div>

---

## 🔧 What this fork adds

This is not a plain mirror of upstream. The fork is in sync with
`pctrade/end4-pC` (omni-search, the dock work, the media player are all pulled
in), and on top of that sit its own changes: 22 code files, +357/−154 lines,
plus the rewritten READMEs. They add no new panels or widgets: the fork is about
making the shell Russian, responsive, and tidy in the details.

### 🇷🇺 Localization

The largest piece of work. Upstream wrote its labels directly in the code, so
widgets stayed English under a Russian locale.

- **Strings are moved into `Translation.tr`** — 8 files: the media widget,
  notes, resources, the to-do list, the user card, weather, the desktop menu
  and the weather service. Hardcoded text like `` `• raining, grab a coffee` ``
  became `` `• ${Translation.tr("raining, grab a coffee")}` ``.
- **Weather is translated end to end** — its description, the city name and the
  quips. The city comes from your settings
  (`Config.options.bar.weather.city`), not from the API response, so the name
  you set is what stays on screen.
- **Condition names are capitalized** — `Ясно` rather than the lowercase string
  Open-Meteo returns.
- **Weather detection understands Russian words.** This is the non-obvious
  part: upstream matched the condition against English substrings
  (`desc.includes("rain")`), so with a Russian API response no condition
  matched and the widget showed a neutral icon. Both languages are checked now:
  `desc.includes("rain") || desc.includes("дожд")`.
- **Time is formatted per locale** — `toLocaleTimeString` is called with
  `Qt.locale().name` instead of a hardcoded `"en-US"`, and the clock is 24-hour.
- **The API request carries the language** — `&lang=` is appended to the URL,
  taken from the current locale, so the description arrives in the right
  language already.

The shell reads translations from two places: its own `translations/` and
`~/.config/illogical-impulse/translations/`. The second overrides the first for
any key it contains, so an extra translation lives apart from the code and
survives fork updates.

### 🌡️ Weather

- **Atmospheric pressure replaces rain chance.** Open-Meteo returns a
  precipitation percentage that is simply empty in clear weather, leaving the
  widget showing a dash. Pressure is informative at all times.

### 🎨 Looks

- **Tray icons are rounded** with an `OpacityMask` — 53 lines in
  `SysTrayItem.qml`. Their shape now matches the rest of the bar instead of
  standing out as rectangles.

### ⚡ Responsiveness

- **Animation curves are retimed for 60 Hz.** On a 60 Hz panel, durations of
  500–650 ms read as the shell lagging behind the cursor. Every spatial duration
  is cut, and the curve shapes are untouched — the motion keeps its language,
  only the clock changed:

  | Curve | Before | After |
  |---|---:|---:|
  | `expressiveFastSpatialDuration` | 350 ms | 220 ms |
  | `expressiveDefaultSpatialDuration` | 500 ms | 300 ms |
  | `expressiveSlowSpatialDuration` | 650 ms | 400 ms |
  | `expressiveEffectsDuration` | 200 ms | 150 ms |
  | element enter | 400 ms | 260 ms |
  | element exit | 200 ms | 160 ms |
  | element resize | 300 ms | 200 ms |
  | click bounce | 400 ms | 260 ms |
  | menu deceleration | 350 ms | 220 ms |
  | sidebar slide in | 300 ms | 240 ms |
  | sidebar slide out | 250 ms | 200 ms |

- **Heavy services start deferred.** `Component.onCompleted` used to fire
  everything at once: wallpaper scanning, update checks, lyrics loading, weather
  and football data hydration. The shell waited for that work to finish. Now
  `onCompleted` only calls `MaterialThemeLoader.reapplyTheme()`, and the rest
  starts from `Timer { interval: 300 }` — the first frame gets drawn before the
  shell turns to initialization.

### 🧹 Small things

- `.gitignore` gained `*.bak`, so local copies left over from tuning no longer
  show up in `git status`.
- **The distro logo on the About page now always resolves.** The page looked
  the logo up through the active system icon theme, while this shell keeps its
  own distro icons in `assets/icons` — with a theme that has no matching file
  the lookup logged `Could not load icon "arch-symbolic"` and fell back to the
  generic Arch logo instead of the configured one. It now uses the same
  `CustomIcon` as the settings card, honouring `custom.distroIcon`,
  `colorizeIcon`, `iconColor` and `iconsPath`.
- **Hover-less popups no longer complain in the log.** `StyledPopup` declares
  `shouldShow` as a `bool`, but with `hoverTarget == null` the expression
  `null && …` yields `null`, which QML refuses to assign — one line per start
  for each of the seven popups opened programmatically. Behaviour is unchanged;
  the expression simply produces the `bool` its type declares.
- **The tray menu no longer opens empty.** A right click on a tray icon would
  sometimes show a popup with only the "Unpin" row: the menu arrives over D-Bus
  asynchronously, while a Quickshell popup is created on show and keeps the size
  it was created with (`clip: true` then cut off everything that arrived later).
  The popup now waits for the menu's first entry (with a 400 ms fallback timer)
  before it appears, and its size follows the current submenu.
- **The tray menu now looks like the other popups.** It was drawn by hand and
  had drifted from them in every value: a near-black `#151517` card on a black
  desktop, a tight 18 px radius, bright white full-width separators, and a plain
  fade with no growth. It is now `colUiPopupBackground` with a `large + 5`
  radius, separators reduced to a `transparentize(m3outline, 0.7)` hairline with
  insets, 15 px text instead of 13, 16 px icons instead of 20, disabled entries
  dimmed to 0.38, and an opening that grows out of the bar edge over 500 ms the
  way `StyledPopup` and the dock menu do.
- **The on-screen keyboard's layout is no longer lost.** The handler for
  Hyprland's `activelayout` event wrote a name like `English` into the config —
  no such key exists in `layouts.js` (which has `English (US)`, `German`,
  `Russian`), so the OSK silently fell back to its default while the junk value
  survived restarts. Only names the OSK actually knows are written now.
- **Omni-search now has switches in Settings.** Upstream added five search
  options (browser history, direct URLs, files, AI, Spotify) with no UI at all —
  turning browser-history search off meant editing `config.json` by hand. They
  now live under Settings → Services → Search → Omni-search.

### Files this fork touches

```
modules/common/Appearance.qml                      animation timings
modules/ii/bar/SysTrayItem.qml                     tray icon rounding
modules/ii/background/widgets/clock/DailyClock.qml
modules/ii/background/widgets/media/MediaWidget.qml
modules/ii/background/widgets/notes/NotesWidget.qml
modules/ii/background/widgets/resources/ResourcesWidget.qml
modules/ii/background/widgets/todo/TodoWidget.qml
modules/ii/background/widgets/usercard/UserCardWidget.qml
modules/ii/background/widgets/weather/WeatherWidget.qml
modules/ii/background/widgets/worldclock/WorldClockWidget.qml
modules/ii/bar/WeatherPopup.qml
modules/ii/desktopMenu/DesktopMenu.qml
modules/ii/settings/pages/About.qml                distro logo
modules/common/widgets/StyledPopup.qml             bool type in shouldShow
modules/ii/bar/SysTrayMenu.qml                     tray menu styling
modules/ii/bar/SysTrayMenuEntry.qml                tray menu entries
modules/ii/settings/pages/ServicesConfig.qml       omni-search switches
services/HyprlandXkb.qml                           valid OSK layout name
services/Weather.qml                               weather and locale
shell.qml                                          deferred startup
```

> [!NOTE]
> The fork is in sync with upstream `pctrade/end4-pC`: launcher omni-search,
> dock tooltips and window previews, the sidebar media player and everything
> else upstream has shipped is in here. To pick up future changes:
>
> ```bash
> git remote add upstream https://github.com/pctrade/end4-pC.git
> git fetch upstream
> git merge upstream/main
> ```

---

## 🎨 Community Presets

Share your whole desktop with one button, or try someone else's in a click.

**[end4-pCpresets](https://github.com/pctrade/end4-pCpresets)** is the community
gallery for this shell, shared by upstream and its forks. Open
**Dashboard → Presets**, pick a preset and press **Download** to try it or
**Install** to keep it. Made your own? Press **Upload**, choose a screenshot and
it is sent for you with one click. The first time, a terminal opens to install
the [GitHub CLI](https://cli.github.com) (`gh`) and sign you in, which takes a
minute. If you skip that, the shell opens a GitHub page where you drag the
folder in instead. Changed your mind? **Remove from gallery** takes your own
preset back out.

- 🔒 **Private by design:** nothing is collected from you. The shell only reads
  public files from GitHub.
- 🧹 **Clean exports:** personal paths, keys and commands are removed before
  anything is shared.
- ✅ **Every preset is checked** automatically. First-time authors are reviewed
  by hand, and trusted authors are merged automatically once the check passes.
- 👤 **Yours stays yours:** only the person who shared a preset can change or
  remove it.

[Browse the gallery](https://github.com/pctrade/end4-pCpresets) · [How to share yours](https://github.com/pctrade/end4-pCpresets#share-your-preset)

---

## ⚡ Installation

> [!NOTE]
> This fork manages its own configuration folder independently — it does **not**
> overwrite or modify any existing setup. However, it does require
> [illogical-impulse](https://github.com/end-4/dots-hyprland) to be installed
> and running; that base is what it inherits Hyprland and quickshell from, and
> this shell does not replace it.

### 1. The end-4 base

If illogical-impulse isn't installed yet, install it with the official
installer:

```bash
bash <(curl -s https://ii.clsty.link/get)
```

It detects your distribution, installs Hyprland, quickshell and the
`illogical-impulse-*` packages, and sets up the permissions and services. For a
minimal install without the extra packages, append `-- --core`. The installer's
source lives at [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland),
and its guide is at
[ii.clsty.link](https://ii.clsty.link/en/ii-qs/01setup/).

> [!IMPORTANT]
> The old `raw.githubusercontent.com/.../setup.sh` command no longer works: the
> file was renamed to `setup` and turned into a multi-command script. If you saw
> that command in an older guide, don't use it — it returns a 404.

The base already installed? Skip straight to the second step.

### 2. This fork

```bash
cd ~/.config/quickshell/
git clone https://github.com/KeylHenrih/end4-pC.git
killall qs 2>/dev/null; qs -c end4-pC > /dev/null 2>&1 & disown
```

Nothing needs configuring for the shell to pick up updates: it does that itself
through `Dashboard → Updates`, and pulls from this repository.

### 🔧 Set as your default shell (optional)

If you like it and want it to load by default instead of `ii`, edit:

```bash
~/.config/hypr/hyprland/variables.lua
```

And change this line:

```lua
hl.env("qsConfig", "ii")
```

to:

```lua
hl.env("qsConfig", "end4-pC")
```

> [!TIP]
> After saving, restart Hyprland or run `hyprctl reload` to apply the change.

### ⚙️ Settings keybind

To open the settings panel, add this to your Hyprland config:

```lua
hl.bind("SUPER + escape", hl.dsp.global("quickshell:settingsToggle"), {description = "Toggle settings"})
```

> **Note:** Settings is an overlay panel, not a regular window — `Super + Q`
> won't close it. Use the same keybind to toggle it or press `Escape`.

---

## ❓ FAQ

### How do I see my keybinds?

Open the launcher (`SUPER`) and type `<` — it'll show you the full list of
configured keybinds.

### Why doesn't Settings have a search bar?

It doesn't need one — the launcher already does that job. Open the launcher
(`SUPER`) and just type what you're looking for (e.g. `wallpaper`, `bar`,
`blur`); it'll match against page names and section keywords and jump you
straight to the right Settings page, so there's no need for a separate search
inside Settings itself.

---

## 🙏 Credits

Huge thanks to the people who made this possible:

- **[@end-4](https://github.com/end-4)** — for creating the original
  [dots-hyprland](https://github.com/end-4/dots-hyprland) / illogical-impulse
  shell. An absolute masterpiece of a dotfiles project 🫡
- **[@pctrade](https://github.com/pctrade)** — for end4-pC, which this is
  forked from, and for the community presets gallery 🙌
- **[@gh0stzk](https://github.com/gh0stzk)** — for providing the weather API
  integration that made the weather widget possible 🙌
- **[@StarS2112](https://github.com/StarS2112)** — for showcasing this fork 🙌
- **[@simeulinuxkaliaiwr](https://github.com/simeulinuxkaliaiwr)** — for some
  shader transitions 🎨

---

## 📄 License

Released under [GPL-3.0](LICENSE), same as upstream. The fork keeps that
license and the same rights over the original code.

---

<div align="center">

Made with ❤️ — feel free to fork and make it your own

</div>
