local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<CR>", "o<Esc>", opts)
map("n", "<Space>", "a <Esc>", opts)
map("i", "jk", "<Esc>", opts)
map("n", ",<Space>", "<cmd>nohlsearch<CR>", opts)
map("n", "x", '"_x', opts)
map("x", "x", '"_x', opts)
map("x", "p", "P", opts)
map("x", "P", "p", opts)
map("n", "WW", "<cmd>w<CR>", opts)

local function git_commit_current_dir()
  local file = vim.fn.expand("%:p")
  local dir = vim.fn.fnamemodify(file ~= "" and file or vim.fn.getcwd(), ":h")

  vim.cmd("!" .. table.concat({
    "git add " .. vim.fn.shellescape(dir),
    "git commit -m Upd",
    "git push",
  }, " && "))
end

map("n", "<S-F1>", git_commit_current_dir, vim.tbl_extend("force", opts, { desc = "Git add/commit/push current dir" }))
map("n", "<F13>", git_commit_current_dir, vim.tbl_extend("force", opts, { desc = "Git add/commit/push current dir" }))

local session_prefix = vim.fn.stdpath("state") .. "/sessions/session"

local function save_session(num)
  vim.cmd("mksession! " .. vim.fn.fnameescape(session_prefix .. num .. ".vim"))
end

local function load_session(num)
  vim.cmd("source " .. vim.fn.fnameescape(session_prefix .. num .. ".vim"))
end

for key, num in pairs({
  ["<S-F9>"] = "1",
  ["<S-F10>"] = "2",
  ["<S-F11>"] = "3",
  ["<S-F12>"] = "4",
  ["<F21>"] = "1",
  ["<F22>"] = "2",
  ["<F23>"] = "3",
  ["<F24>"] = "4",
}) do
  map("n", key, function()
    save_session(num)
  end, { desc = "Save session " .. num })
  map("i", key, function()
    vim.cmd.stopinsert()
    save_session(num)
    vim.cmd.startinsert()
  end, { desc = "Save session " .. num })
end

for key, num in pairs({
  ["<F9>"] = "1",
  ["<F10>"] = "2",
  ["<F11>"] = "3",
  ["<F12>"] = "4",
}) do
  map("n", key, function()
    load_session(num)
  end, { desc = "Load session " .. num })
end

map("", "<S-ScrollWheelUp>", "<cmd>BufferLineMovePrev<CR>", { desc = "Move buffer left" })
map("", "<S-ScrollWheelDown>", "<cmd>BufferLineMoveNext<CR>", { desc = "Move buffer right" })

map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

map("n", "<Esc><Esc>", function()
  local ok, noice = pcall(require, "noice")
  if ok then
    noice.cmd("dismiss")
  else
    vim.cmd.nohlsearch()
  end
end, { desc = "Dismiss UI messages/search" })
