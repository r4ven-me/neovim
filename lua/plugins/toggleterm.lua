return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { "<F4>", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
  },
  opts = {
    size = 15,
    open_mapping = [[<F4>]],
    direction = "float",
    float_opts = {
      border = "curved",
      winblend = 0,
    },
    highlights = {
      FloatBorder = {
        guifg = "#B0E2FF",
      },
    },
    shell = vim.o.shell,
  },
}
