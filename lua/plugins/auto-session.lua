local neo_tree_was_open = false
local window_before_save

local function close_neo_tree_before_save()
  neo_tree_was_open = false
  window_before_save = vim.api.nvim_get_current_win()

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "neo-tree" then
      neo_tree_was_open = true
      vim.cmd("Neotree close")
      break
    end
  end
end

local function restore_neo_tree_after_save()
  if not neo_tree_was_open then
    return
  end

  vim.cmd("Neotree show")
  if window_before_save and vim.api.nvim_win_is_valid(window_before_save) then
    vim.api.nvim_set_current_win(window_before_save)
  end
end

return {
  "rmagatti/auto-session",
  lazy = false,
  opts = {
    auto_save = true,
    auto_restore = false,
    auto_session_root_dir = vim.fn.stdpath("state") .. "/sessions/",
    bypass_save_filetypes = { "neo-tree", "toggleterm" },
    pre_save_cmds = {
      close_neo_tree_before_save,
    },
    post_save_cmds = {
      restore_neo_tree_after_save,
    },
    post_restore_cmds = {
      "Neotree show",
      "wincmd w",
    },
  },
  keys = {
    { "WS", "<cmd>AutoSession save<CR>", desc = "Save current session" },
    { "WR", "<cmd>AutoSession restore<CR>", desc = "Restore last session" },
  },
}
