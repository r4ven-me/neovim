# Neovim Nord Config

A personal Lua-based Neovim configuration with `lazy.nvim`, Nord styling, Treesitter highlighting, a lightweight lint/format layer, and an easy way to enable LSP when needed.

This config is not trying to be a full IDE bundle. Its focus is a pleasant UI, fast startup, syntax highlighting, optional diagnostics through external CLI linters, formatting on demand, and comfortable file/buffer navigation.

## Requirements

Minimum:

- Neovim `0.10+`
- Git
- curl or HTTPS access for `git clone`
- ripgrep `rg` for Telescope search
- a true color terminal and a Nerd Font

Recommended CLI dependencies for the current config:

```bash
# Debian/Ubuntu
sudo apt install neovim git ripgrep shellcheck shfmt jq
```

Additional language-specific tools:

```bash
# Lua
sudo apt install luacheck

# Python
python3 -m pip install --user ruff black pylint

# YAML / JSON / web formatting
python3 -m pip install --user yamllint
npm install -g prettier jsonlint
```

If a linter or formatter is not installed, Neovim should not crash. The config only enables linters found in `$PATH`.

## Installation

Back up your existing config if you have one:

```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

Clone this configuration repository:

```bash
git clone <REPO_URL> ~/.config/nvim
```

First launch:

```bash
nvim
```

On first startup, the config automatically:

- installs `lazy.nvim` if it is not already installed;
- installs plugins from `lua/plugins`;
- creates service directories under `~/.local/state/nvim`;
- starts installing the required Treesitter parsers.

For unattended installs, install plugins and Treesitter parsers before the
first interactive Neovim launch:

```bash
~/Cloud/Projects/dots/bin/install-nvim-treesitter-parsers
```

Example Ansible task for the `dots` role, after Neovim is installed and the
dotfiles are linked/copied:

```yaml
- name: Install Neovim Treesitter parsers
  ansible.builtin.command: "{{ dots_repo_dir }}/bin/install-nvim-treesitter-parsers"
  become: false
  changed_when: false
```

where `dots_repo_dir` is the checked out dotfiles path, for example
`{{ ansible_env.HOME }}/Cloud/Projects/dots`.

To check or update plugins manually:

```vim
:Lazy
```

## Structure

```text
.
├── init.lua
├── lazy-lock.json
├── lua
│   ├── config
│   │   ├── autocmds.lua
│   │   ├── keymaps.lua
│   │   ├── lazy.lua
│   │   └── options.lua
│   └── plugins
│       ├── auto-session.lua
│       ├── autopairs.lua
│       ├── bufferline.lua
│       ├── conform.lua
│       ├── gitsigns.lua
│       ├── lint.lua
│       ├── lsp.lua
│       ├── lualine.lua
│       ├── neo-tree.lua
│       ├── nord.lua
│       ├── ruscmd.lua
│       ├── scrollview.lua
│       ├── telescope.lua
│       ├── toggleterm.lua
│       └── treesitter.lua
```

`init.lua` only loads the main modules:

```lua
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
```

Each plugin lives in its own file under `lua/plugins`. These files use the regular lazy.nvim spec format.

## Usage

Main keybindings:

| Key | Action |
| --- | --- |
| `F2` | Exact file search in the current file directory |
| `Shift+F2` | Search file contents in the current file directory |
| `F3` | Toggle Neo-tree |
| `F4` | Toggle bottom terminal |
| `F5` | Telescope buffer list |
| `Shift+F5` | Save and run the current `sh`/`python` file |
| `F7` | Run lint manually |
| `Shift+F7` / `F19` | Disable automatic lint for the current session |
| `leader + f` | Format the buffer with conform.nvim |
| `leader + d` | Show line diagnostics |
| `[d` / `]d` | Go to previous/next diagnostic |
| `Shift+h` / `Shift+l` | Previous/next buffer |
| `WW` | Save file |
| `WS` | Save the auto-session session |
| `WR` | Restore the latest auto-session session |

The leader key is currently Space.

## Lint

Linting is configured through `mfussenegger/nvim-lint`, without requiring LSP. Automatic linting starts disabled and can be enabled for the current session with `:LinterToggle`.

Supported linters are enabled only if found on the system:

- `shellcheck` for `sh`, `bash`
- `zsh` for `zsh`
- `ruff` or `pylint` for Python
- `luacheck` for Lua
- `yamllint` for YAML
- `jsonlint` for JSON

For shell files, `shellcheck` checks the current buffer through stdin, so diagnostics can see unsaved changes.

Commands:

```vim
:Lint
:LinterToggle
:LintToggle
```

## Formatting

Formatting is configured through `stevearc/conform.nvim`.

By default, formatting is run manually:

```vim
<leader>f
```

Formatters by file type:

- Lua: `stylua`
- Shell: `shfmt`
- Python: `ruff_format`, then `black`
- JSON: `jq`
- YAML: `yamlfmt`, then `prettier`

Install only the tools you actually use.

## Treesitter

Treesitter provides modern syntax highlighting.

Parsers are enabled for Lua, Vim, Bash, Python, JSON, SQL, YAML, TOML, Markdown, Dockerfile, HTML/CSS/JavaScript, and several configuration formats.

Useful commands:

```vim
:TSInstallInfo
:TSUpdate
```

## Sessions And State

State files live under `~/.local/state/nvim`:

- swap: `~/.local/state/nvim/swap`
- undo: `~/.local/state/nvim/undo`
- backup: `~/.local/state/nvim/backup`
- sessions: `~/.local/state/nvim/sessions`
- ShaDa: `~/.local/state/nvim/shada/main.shada`

The config removes old temporary `main.shada.tmp.*` files older than one day so Neovim does not run into the `E138` error.

## Enabling LSP

There is an LSP starter setup in `lua/plugins/lsp.lua`, but it is disabled:

```lua
enabled = false
```

To enable LSP:

1. Install the required language servers.
2. Change `enabled = false` to `enabled = true`.
3. Add or configure servers in the `config` block.

Examples for `lua_ls` and `pyright` are already included.

## Updating

Update the config:

```bash
cd ~/.config/nvim
git pull
```

Update plugins:

```vim
:Lazy update
```

After updating, you can check startup without the UI:

```bash
nvim --headless '+lua print("config ok")' '+qa'
```
