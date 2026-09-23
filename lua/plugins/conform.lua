local function format_buffer()
  require("conform").format({ async = true, lsp_fallback = true })
end

return {
  "stevearc/conform.nvim",
  cmd = "ConformInfo",
  keys = {
    { "<leader>f", format_buffer, mode = { "n", "v" }, desc = "Format buffer" },
    { "<S-F3>", format_buffer, mode = { "n", "v" }, desc = "Format buffer" },
    { "<F15>", format_buffer, mode = { "n", "v" }, desc = "Format buffer" },
  },
  opts = {
    notify_on_error = false,
    formatters_by_ft = {
      lua = { "stylua" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      zsh = { "shfmt" },
      python = { "ruff_format", "black" },
      json = { "jq" },
      yaml = { "yamlfmt", "prettier" },
    },
  },
}
