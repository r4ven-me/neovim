return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  cmd = "Neotree",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<F3>", "<cmd>Neotree toggle<CR>", desc = "Toggle Neo-tree" },
  },
  opts = {
    close_if_last_window = true,
    enable_git_status = true,
    window = {
      width = 35,
    },
    filesystem = {
      bind_to_cwd = true,
      cwd_target = "window",
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
  },
}
