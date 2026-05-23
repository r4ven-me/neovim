return {
  "rmagatti/auto-session",
  lazy = false,
  opts = {
    auto_save = true,
    auto_restore = false,
    auto_session_root_dir = vim.fn.stdpath("state") .. "/sessions/",
    bypass_save_filetypes = { "neo-tree", "toggleterm" },
    pre_save_cmds = {
      "Neotree close",
    },
    post_restore_cmds = {
      "Neotree show",
      "wincmd w",
    },
  },
  keys = {
    { "WS", "<cmd>SessionSave<CR>", desc = "Save current session" },
    { "WR", "<cmd>SessionRestore<CR>", desc = "Restore last session" },
  },
}
