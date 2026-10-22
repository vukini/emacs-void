# emacs-void

A personal Emacs configuration that works on Void Linux.

It is the `~/.emacs.d` that [Vikix](https://vikix.dev) installs.
It also works on its own, on any Linux with a recent Emacs.

- **Literate.** The configuration is one Org file, `config.org`, with prose around every block.
- **Modern completion.** Vertico, Orderless, Marginalia, Consult and Embark in the minibuffer; Corfu and Cape in buffers.
- **Languages through eglot.** C, C++, JavaScript, TypeScript, Python, Zig and Odin start their language server by themselves.
- **Lisp first.** SLIME for Common Lisp, racket-mode, Paredit everywhere Lisp is written.
- **Tools inside Emacs.** Magit, vterm, PDF Tools, an EPUB reader, gptel and agent-shell for AI.
- **Vikix-aware, not Vikix-bound.** On Vikix it picks up the desktop theme, the AI models, the notes and Esploro. Elsewhere those parts are simply skipped.

---

## Contents

- [What you need](#what-you-need)
- [Install](#install)
- [The first start](#the-first-start)
- [How it is put together](#how-it-is-put-together)
- [Keys](#keys)
- [Languages](#languages)
- [On Vikix](#on-vikix)
- [What is not in git](#what-is-not-in-git)
- [Changing the configuration](#changing-the-configuration)
- [Troubleshooting](#troubleshooting)

---

## What you need

**Emacs 30 or newer.**

- Vikix uses Void's `emacs-x11` package (30.2).
- Emacs 31 works too.
- 30 is the floor: `which-key` is built in from 30, and one package installs with `use-package :vc`, which is new in 30.

**Programs the configuration calls.**
Nothing breaks if one is missing; that feature just does not work until it is installed.

| For | Void package(s) |
|---|---|
| Fetching packages | `git` |
| `consult-ripgrep`, `consult-fd` | `ripgrep`, `fd` |
| Common Lisp (SLIME) | `sbcl` |
| C and C++ server | `ccls` |
| Building PDF Tools | `pkg-config`, `autoconf`, `automake`, `poppler-glib-devel`, `libpng-devel`, `zlib-devel` |
| Building vterm's module | `cmake`, `libtool`, `base-devel` |
| Python REPL | `python3-ipython` |
| Racket | `racket` (optional — racket-mode loads only if it is there) |
| Word completion in text buffers | a word list in `/usr/share/dict/words` (optional) |

**Language servers from npm** (Vikix installs these into `~/.local`):

```sh
npm install -g typescript-language-server typescript pyright bash-language-server
```

`zls` (Zig) and `ols` (Odin) come with those languages.

---

## Install

### With Vikix

Nothing to do.
The installer stage `45-editors` clones this repository to `~/.emacs.d`.

`vikix update` pulls it.
`vikix doctor` checks it is a clone.

To use a fork instead, set `VIKIX_EMACS_REPO` before installing.

### By hand

Move any existing configuration out of the way first:

```sh
mv ~/.emacs.d ~/.emacs.d.old
```

```sh
mv ~/.emacs ~/.emacs.old
```

Then clone:

```sh
git clone https://github.com/vukini/emacs-void ~/.emacs.d
```

And start Emacs:

```sh
emacs
```

---

## The first start

The first start is slow. Let it finish.

- **Packages install themselves.** Every `use-package` declaration has `:ensure t`, so about forty packages download from GNU ELPA, NonGNU ELPA and MELPA. This takes a few minutes.
- **One package comes straight from GitHub:** the Haskell unicode input method (it is not on any archive).
- **`config.el` is generated.** `init.el` tangles `config.org` into `config.el` and loads it.
- **PDF Tools builds its server** the first time a PDF is opened. It needs the build packages listed above.
- **vterm asks to compile its module** the first time `M-x vterm` runs. Answer yes.

Later starts are quick: nothing is downloaded, and `config.el` is only rebuilt when `config.org` is newer.

`*Messages*` shows a banner for each section as it loads (`== Core ==`, `== Completion ==` …), so a failure is easy to place.

---

## How it is put together

```
init.el  ──loads──▶  config.org  ──tangles to──▶  config.el  (generated, not in git)
```

`init.el` is small.
It does the few things that must happen before anything else:

- no bell, no splash screen, an empty `*scratch*`;
- no menu bar, tool bar or scroll bars;
- `save-place-mode` — files reopen where you left them;
- `windmove` — Shift + arrows moves between windows;
- `desktop-save-mode` — the open buffers come back after a restart;
- then it loads `config.org`.

It also makes a **new frame come back as the last frame closed**: the same windows, buffers and places.
With nothing to come back to, a new frame shows `*scratch*` in `~`.
This is what makes `emacsclient -c` (Super+x on Vikix) feel like reopening a window rather than starting over.

`config.org` holds everything else, in load order:

| Section | What is in it |
|---|---|
| Bootstrap | load path, package archives, `use-package`, `exec-path-from-shell` |
| Core | custom file, backups, read-only files, theme, global keys, which-key |
| Completion | vertico, savehist, orderless, marginalia, consult, embark, corfu, cape, kind-icon |
| Navigation | avy, projectile, speedbar |
| Editing | paredit, yasnippet, the Haskell unicode input method |
| Languages | eglot and each language |
| Tools | magit, vterm, pdf-tools, nov, gptel, agent-shell, notes, Esploro |
| Attic | disabled configuration, kept for reference, never loaded |

### The files in this repository

| Path | What it is |
|---|---|
| `init.el` | Startup; loads `config.org` |
| `config.org` | The configuration |
| `snippets/` | Yasnippet snippets for C, JavaScript, HTML, Makefiles, Org and Emacs Lisp |
| `racket-mode/repl.rkt` | Used by `M-x racket-repl` |
| `local/` | Local Lisp on the load path (`local/rc.el` is an old helper file; nothing loads it now) |
| `init-backup` | An old `init.el`, kept for reference; not loaded |

---

## Keys

Only the keys this configuration adds or changes.
`C-h k` then a key says what any key does; which-key shows what can follow a prefix.

### Moving around

| Key | Does |
|---|---|
| Shift + arrows | Move to the window in that direction |
| `M-\` | Previous window |
| `C-:` | Jump to a character on screen (avy) |
| `C-'` | Jump to a two-character pair |
| `M-g w` / `M-g e` | Jump to a word |
| `M-g f` | Jump to a line |
| `C-c C-j` | Repeat the last jump |
| `M-g i` | Jump to a definition or heading (consult-imenu) |

### Finding things

| Key | Does |
|---|---|
| `C-x b` | Switch buffer — also recent files and bookmarks |
| `C-s` | Search this buffer, with a live list of matches |
| `M-s r` | Search the project with ripgrep |
| `M-s f` | Find a file in the project with fd |

### Acting on things

| Key | Does |
|---|---|
| `C-.` | Embark: what can I do with the thing at point? |
| `C-;` | Embark: do the obvious thing with it |
| `C-c p` | Cape's completion menu (words, files, symbols …) |
| `C-x C-q` | Make a read-only buffer editable, and back |
| `C-=` / `C--` | Larger / smaller text |
| `C-\` | Toggle the input method (Haskell: `->` becomes `→`) |

### Tools

| Key | Does |
|---|---|
| `C-x g` | Magit status |
| `C-c g` | gptel: open a chat |
| `C-c G` | gptel menu (pick the model with `-m`) |
| `C-c a` | An AI agent in a chat buffer (agent-shell) |
| `C-c A` | The agent in a terminal (Vikix only) |
| `C-c n …` | Notes (Vikix only — see below) |

### In Markdown buffers

| Key | Does |
|---|---|
| `C-c C-x C-m` | Show / hide the markup |
| `C-c C-x C-l` | Show / hide link URLs |
| `C-c C-x C-i` | Show / hide images |
| `C-c C-o` | Follow a link, including `[[Wiki links]]` |

---

## Languages

The servers start by themselves when a file of that kind opens (`eglot-ensure`).

| Language | Mode | Server |
|---|---|---|
| C, C++ | `c-mode`, `c++-mode` | `ccls` |
| JavaScript, TypeScript | `js-mode`, `typescript-ts-mode` | `typescript-language-server` |
| Python | `python-mode` | `pyright` (REPL is `ipython`) |
| Zig | `zig-mode` | `zls` |
| Odin | `odin-ts-mode` | `ols` |
| Common Lisp | SLIME | `sbcl` — no LSP needed |
| Racket | `racket-mode` + `racket-xp-mode` | racket-mode's own back end |
| Emacs Lisp | built in | `elisp-slime-nav` for `M-.` |

Also installed, with their defaults: Markdown, CSV, Jinja, Lua, Go, PHP and an RFC reader.
Built-in Emacs covers CSS/Less, CMake and many more.

**Python.**
Activate the project's virtual environment first: `M-x pyvenv-activate`.
On Vikix this is done for you (see below).

**Odin.**
`odin-ts-mode` is not on any archive. Install it once by evaluating:

```elisp
(package-vc-install "https://github.com/Sampie159/odin-ts-mode")
```

**Common Lisp HyperSpec.**
If a copy exists at `~/.emacs.d/HyperSpec-7-0/HyperSpec/`, SLIME looks things up there, offline.
Without it, SLIME uses the online HyperSpec.
The copy is 20 MB and is not in git.

**Tree-sitter grammars** are looked for in `~/.emacs.d/tree-sitter/`.

---

## On Vikix

Vikix keeps a few Emacs Lisp files current in `~/.local/share/vikix/emacs/`.
`config.org` loads each one if it is there, and quietly does nothing if it is not.

| File | Adds |
|---|---|
| `vikix-theme.el` | Emacs follows the desktop theme; `vikix theme NAME` repaints a running Emacs. Without it, the theme is gruber-darker. |
| `vikix-ai.el` | Claude and local Ollama models in gptel; the default is the model Super+i uses (`vikix ai use`). `C-c a` starts your agent through `vikix agent`. |
| `vikix-notes.el` | The notes in `~/Dropbox/notes` under `C-c n` |
| `vikix-python.el` | Python as an IDE — see below |

**Notes, under `C-c n`:**

| Key | Does |
|---|---|
| `C-c n a` | Agenda: this week, then every TODO |
| `C-c n t` | The TODOs |
| `C-c n c` | Capture a note into the inbox |
| `C-c n o` | Open a notes file |
| `C-c n j` | Today's journal page |
| `C-c n f` | Find or start a note (org-roam) |
| `C-c n i` | Insert a link to a note |
| `C-c n l` | Backlinks |
| `C-c n g` | The graph, in the browser (org-roam-ui, on 127.0.0.1 only) |

Files in `~/Dropbox/notes` always open editable (see [read-only files](#troubleshooting)).

**Python as an IDE.**
`vikix-python.el` finds the project's `.venv` by itself for pyright, the REPL, pytest and ruff.
It shows ruff's findings next to pyright's and formats the buffer on save.
Its keys (tests, run, REPL, venv, layout, docs) are under `C-c p` in Python buffers.

**Esploro**, the Vikix file explorer, runs in an Emacs frame (Super+e).
`M-x esploro` opens it.
With Embark, `C-.` then `,` on any file name gives Esploro's commands; `J` shows the file in Esploro.

**The Emacs daemon.**
On Vikix the session starts `emacs --fg-daemon`, and `e` in a terminal is `emacsclient`.
Super+x opens a new frame; Super+q closes one.

---

## What is not in git

Each machine keeps its own state. These are in `.gitignore`, so two machines never fight over them:

- `config.el` — generated from `config.org`;
- `custom-vars.el` — whatever `M-x customize` writes;
- `bookmarks`, `.emacs.desktop`, `places`, `recentf`, `history`, `projects.eld`, the REPL histories;
- `elpa/` and `eln-cache/` — the installed packages;
- `.saves/` — versioned backups (six new, two old, per file), kept out of your source folders;
- the HyperSpec copy, tree-sitter grammars and other downloads.

Delete any of them and Emacs makes a fresh one.

---

## Changing the configuration

**Edit `config.org`, never `config.el`.**
`config.el` is rebuilt from `config.org` whenever `config.org` is newer, so hand edits are lost.

To rebuild and load it without restarting:

```
M-x org-babel-load-file RET ~/.emacs.d/config.org RET
```

**Adding a package** is one block in the right section:

```elisp
(use-package some-package
  :ensure t
  :defer t)
```

Packages that come with Emacs need `:ensure nil`, or `use-package` tries to download them.

**Machine-only settings** go through `M-x customize`. They land in `custom-vars.el`, which is not shared.

**The Attic** at the end of `config.org` keeps old configuration (Obsidian, lsp-mode, earlier gptel setups …).
Nothing there is loaded: every block is `:tangle no` and commented out.
To bring one back, move it into the body, remove `:tangle no` and uncomment it — and test it, because it has not been kept working.

---

## Troubleshooting

**I can't type in a file.**
Existing files open read-only, so a stray key can't change them.
`C-x C-q` makes the buffer editable.
New files, anything under `.git/` (so Magit works) and the notes folder open editable.
To add a folder, put it in `my/editable-directories` in `config.org`.

**A program is "not found" inside vterm.**
Under the runit-started daemon, `$SHELL` is unset, so Emacs would fall back to `/bin/sh` (dash), which never reads `~/.bashrc`.
`vterm-shell` is pinned to `/bin/bash` for that reason, so `~/.bashrc` sets the full `PATH`.
If a program is still missing, add its folder to `PATH` in `~/.bashrc`.

**gptel says there is no API key.**
Keys are read from the login shell: export `OPENAI_API_KEY` or `PERPLEXITY_API_KEY` in `~/.bash_profile` or `~/.bashrc`.

**"Cannot executable-find Racket".**
Should not happen: racket-mode is only set up when `racket` is on `PATH`. If Racket was installed after Emacs started, restart Emacs.

**Package installs fail with `Wrong type argument: stringp, #<symbol xterm-color …>`.**
`xterm-color` is installed before SLIME to stop exactly this. If it happens anyway, restart Emacs; the remaining installs then go through.

**A first start was interrupted and packages now fail to load.**
Delete `~/.emacs.d/elpa/` and start Emacs again; everything is downloaded afresh.

**Warnings about `lexical-binding` cookies.**
Silenced for third-party packages (gruber-darker-theme lacks the cookie). Files in this repository all carry it.

**Faces warn about `nil` attributes under the daemon.**
Handled: theme face specs have `nil` rewritten to `unspecified` as the theme loads.

**ispell errors on every word in Org or Markdown.**
Handled: word completion in text buffers is off unless a word list is installed.
