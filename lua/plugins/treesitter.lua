return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    auto_install = true,
    ensure_installed = {
      "lua",
      "vim",
      "vimdoc",
      "bash",
      "python",
      "json",
      "sql",
      "yaml",
      "toml",
      "markdown",
      "tmux",
      "ssh_config",
      "terraform",
      "nginx",
      "groovy",
      "pem",
      "dockerfile",
      "javascript",
      "css",
      "html",
    },
    sync_install = false,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true,
    },
  },
  config = function(_, opts)
    local ok, configs = pcall(require, "nvim-treesitter.configs")
    if not ok then
      vim.notify("nvim-treesitter legacy config module is unavailable", vim.log.levels.WARN)
      return
    end

    configs.setup(opts)
  end,
}
