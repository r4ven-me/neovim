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
    event_handlers = {
      {
        event = "neo_tree_window_after_open",
        handler = function()
          local terminal_win = vim.t.toggleterm_restore_win
          vim.t.toggleterm_restore_win = nil

          vim.schedule(function()
            if _G.keep_bottom_terminal_full_width then
              _G.keep_bottom_terminal_full_width(false)
            end

            if type(terminal_win) == "number" and vim.api.nvim_win_is_valid(terminal_win) then
              vim.api.nvim_set_current_win(terminal_win)
              vim.cmd.startinsert()
            end
          end)
        end,
      },
    },
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
