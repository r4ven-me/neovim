return {
  "mhinz/vim-startify",
  event = "VimEnter",
  init = function()
    vim.g.startify_session_dir = vim.fn.stdpath("state") .. "/sessions"
  end,
}
