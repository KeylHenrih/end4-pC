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

This is not a plain mirror of upstream. Nine commits sit on top of `6f461b4`,
and they deal mainly with Russian localization, interface responsiveness and
small pieces of polish:

**Localization**

- Widget strings are wrapped in `Translation.tr` — weather, resources, notes,
  the to-do list, the clock, the user card and the weather popup now translate
  instead of staying English.
- Weather is translated end to end: its description, the city name and the
  quips.
- Weather conditions are capitalized, as Russian typography expects.

**Weather**

- The widget shows atmospheric pressure instead of rain chance — pressure is
  consistently informative, whereas the precipitation percentage from
  Open-Meteo is often empty.

**Looks**

- System tray icons are rounded with an `OpacityMask`, so their shape matches
  the rest of the bar.
- The overview unfolds from the centre instead of dropping down from the bar:
  it reads as the workspaces surfacing rather than yet another panel sliding in.

**Responsiveness**

- Animation curves are retimed for 60 Hz: durations of 500–650 ms are cut to
  300–400 ms so the shell no longer trails the compositor by a beat. The curve
  shapes are untouched — the motion keeps its language.
- Heavy services (wallpaper scanning, update checks, lyrics) start deferred,
  300 ms after the first frame. The shell appears immediately instead of
  waiting for initialization to finish.

> [!NOTE]
> This fork trails `pctrade/end4-pC` by roughly 29 commits: upstream has since
> gained launcher omni-search, dock tooltips and other improvements that are
> not here — they were never in the live shell when the fork was taken. To pull
> them in, add upstream and merge:
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
> and running; that base is not replaced by this shell.

```bash
cd ~/.config/quickshell/
git clone https://github.com/KeylHenrih/end4-pC.git
killall qs 2>/dev/null; qs -c end4-pC > /dev/null 2>&1 & disown
```

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
