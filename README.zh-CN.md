



<div align="center">

# 💠 end4-pC

**[end4-pC](https://github.com/pctrade/end4-pC)（作者：[@pctrade](https://github.com/pctrade)）的个人分支，
而它本身又是 [illogical-impulse](https://github.com/end-4/dots-hyprland)（作者：[@end-4](https://github.com/end-4)）的分支**
由 **KeylHenrih** 维护

[Русский](README.md) | [English](README.en.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md)

</div>

---

## 🎬 展示

<p align="center">
  <a href="https://www.youtube.com/watch?v=o0Vsh7eVchs">
    <img src="https://img.youtube.com/vi/o0Vsh7eVchs/maxresdefault.jpg" alt="Material 3 Expressive x Linux" width="85%" style="border-radius: 12px; box-shadow: 0px 10px 30px rgba(0,0,0,0.5);"/>
  </a>
</p>

---

## 📸 截图
<div align="center">

| 🎵 歌词 | 🖼️ 在线壁纸 |
|:---:|:---:|
| ![截图 1](screenshots/1.png) | ![截图 2](screenshots/2.png) |
| 🪟 桌面小组件 | 🔧 Hyprland 配置 |
| ![截图 5](screenshots/5.png) | ![截图 6](screenshots/6.png) |
| ⚙️ 可配置的状态栏 | ✨ 以及更多功能 |
| ![截图 3](screenshots/3.png) | ![截图 4](screenshots/4.png) |

</div>

---

## 🎨 社区预设

一键分享你的整个桌面，也可以一键试用别人的。

**[end4-pCpresets](https://github.com/pctrade/end4-pCpresets)** 是本 Shell 的社区预设库。打开 **Dashboard → Presets**，选择预设后点击 **Download** 试用，或点击 **Install** 永久保存。想分享自己的？点击 **Upload**，选择一张截图，再通过 Pull Request 提交即可，无需使用 git。

- 🔒 **注重隐私：** 不会收集你的任何数据，Shell 只读取 GitHub 上的公开文件。
- 🧹 **导出已清理：** 分享前会移除个人路径、密钥和命令。
- ✅ **每个预设都会自动检查**，并由人工合并。

[浏览预设库](https://github.com/pctrade/end4-pCpresets) · [如何分享你的预设](https://github.com/pctrade/end4-pCpresets#share-your-preset)

---

## ⚡ 安装

> [!NOTE]
> 此分支会独立管理自己的配置文件夹，**不会**覆盖或修改任何现有设置。不过，它要求已安装并正在运行 [illogical-impulse](https://github.com/end-4/dots-hyprland)——本分支从它继承 Hyprland 与 quickshell，并不会替换该基础。

### 1. end-4 基础

如果还没有 illogical-impulse，请用官方安装器安装：

```bash
bash <(curl -s https://ii.clsty.link/get)
```

它会自动识别发行版，安装 Hyprland、quickshell 和 `illogical-impulse-*` 软件包，并配置权限与服务。想要最小化安装，在命令末尾加上 `-- --core`。安装器源码见 [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland)，说明见 [ii.clsty.link](https://ii.clsty.link/en/ii-qs/01setup/)。

> [!IMPORTANT]
> 旧的 `raw.githubusercontent.com/.../setup.sh` 命令已失效：该文件已更名为 `setup`，并改成了多子命令脚本。如果在旧教程里看到它，请不要使用——会返回 404。

基础已就绪？直接看第二步。

### 2. 本分支

```bash
cd ~/.config/quickshell/
git clone https://github.com/KeylHenrih/end4-pC.git
killall qs 2>/dev/null; qs -c end4-pC > /dev/null 2>&1 & disown
```

分支会通过 `Dashboard → Updates` 自行检查并拉取更新，指向的正是本仓库，无需额外配置。

### 🔧 设为默认 shell（可选）

如果你喜欢它，并希望它默认加载以取代 `ii`，请编辑：

```bash
~/.config/hypr/hyprland/variables.lua
```

将这一行：

```lua
hl.env("qsConfig", "ii")
```

改为：

```lua
hl.env("qsConfig", "end4-pC")
```

> [!TIP]
> 保存后，重启 Hyprland 或运行 `hyprctl reload` 即可应用更改。

---

### ⚙️ 设置快捷键

要打开设置面板，请将以下内容添加到 Hyprland 配置中：

```lua
hl.bind("SUPER + escape", hl.dsp.global("quickshell:settingsToggle"), {description = "Toggle settings"})
```

> **注意：** 设置是一个覆盖面板，而不是普通窗口，因此 `Super + Q` 无法将其关闭。请使用同一个快捷键进行切换，或按 `Escape`。

## 🙏 致谢

衷心感谢促成此项目的人们：

- **[@end-4](https://github.com/end-4)** — 创建了原始的 [dots-hyprland](https://github.com/end-4/dots-hyprland) / illogical-impulse shell。这个 dotfiles 项目堪称杰作 🫡
- **[@pctrade](https://github.com/pctrade)** — 创建了本分支所基于的 end4-pC，以及社区预设库 🙌
- **[@gh0stzk](https://github.com/gh0stzk)** — 提供了天气 API 集成，让天气小组件得以实现 🙌
- **[@StarS2112](https://github.com/StarS2112)** — 展示了此分支 🙌

---

<div align="center">

用 ❤️ 制作——欢迎自由分支并打造属于你自己的版本

</div>
