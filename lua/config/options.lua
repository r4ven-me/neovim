vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local state_path = vim.fn.stdpath("state")
local function state_dir(name)
  return table.concat({ state_path, name }, "/")
end

for _, dir in ipairs({ "swap", "undo", "backup", "sessions", "shada" }) do
  vim.fn.mkdir(state_dir(dir), "p")
end

local function clean_stale_shada_tmp()
  local shada_tmp_files = vim.fn.glob(state_dir("shada") .. "/main.shada.tmp.*", false, true)
  local now = os.time()

  for _, file in ipairs(shada_tmp_files) do
    local mtime = vim.fn.getftime(file)
    if mtime > 0 and now - mtime > 86400 then
      pcall(vim.fn.delete, file)
    end
  end
end

clean_stale_shada_tmp()

vim.opt.mouse = "a"
vim.opt.encoding = "utf-8"
vim.opt.number = true
vim.opt.scrolloff = 7
vim.opt.showmode = false
vim.opt.showcmd = false
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.laststatus = 2
vim.opt.cmdheight = 1
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.fileformats = { "unix", "dos", "mac" }
vim.opt.showtabline = 2
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.equalalways = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 500
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.signcolumn = "yes"

vim.opt.sessionoptions = {
  "buffers",
  "curdir",
  "folds",
  "help",
  "tabpages",
  "winsize",
  "winpos",
  "terminal",
  "localoptions",
}

vim.opt.shada = { "!", "'100", "<50", "s10", "h" }
vim.opt.shadafile = state_dir("shada") .. "/main.shada"

vim.opt.swapfile = true
vim.opt.directory = state_dir("swap") .. "//"
vim.opt.writebackup = true
vim.opt.backup = false
vim.opt.backupcopy = "auto"
vim.opt.backupdir = state_dir("backup") .. "//"
vim.opt.undofile = true
vim.opt.undodir = state_dir("undo") .. "//"

vim.opt.foldmethod = "indent"
vim.opt.foldnestmax = 10
vim.opt.foldenable = false
vim.opt.foldlevel = 2

vim.opt.guicursor = table.concat({
  "n-v-c:block-Cursor",
  "i-ci-ve:ver25-iCursor",
  "r-cr:hor20-rCursor",
  "o:hor50",
}, ",")

vim.diagnostic.config({
  virtual_text = {
    spacing = 2,
    prefix = "●",
    source = "if_many",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "if_many",
    header = "",
  },
})

local diagnostic_signs = {
  Error = "E",
  Warn = "W",
  Hint = "H",
  Info = "I",
}

for type, icon in pairs(diagnostic_signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
