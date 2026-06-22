return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  cmd = "Telescope",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<F2>",
      function()
        local file = vim.api.nvim_buf_get_name(0)
        local cwd = file ~= "" and vim.fs.dirname(file) or vim.fn.getcwd()

        require("telescope.builtin").find_files({
          cwd = cwd,
          prompt_title = "Files: " .. vim.fn.fnamemodify(cwd, ":~"),
          sorter = require("telescope.sorters").get_substr_matcher(),
        })
      end,
      desc = "Find files in current file directory",
    },
    {
      "<S-F2>",
      function()
        local file = vim.api.nvim_buf_get_name(0)
        local cwd = file ~= "" and vim.fs.dirname(file) or vim.fn.getcwd()

        require("telescope.builtin").live_grep({
          cwd = cwd,
          prompt_title = "Grep: " .. vim.fn.fnamemodify(cwd, ":~"),
        })
      end,
      desc = "Search file contents in current file directory",
    },
    {
      "<F5>",
      function()
        require("telescope.builtin").buffers({
          sort_mru = true,
          ignore_current_buffer = false,
        })
      end,
      desc = "Buffers",
    },
  },
  opts = {
    defaults = {
      mappings = {
        i = {
          ["<Esc>"] = require("telescope.actions").close,
        },
        n = {
          ["<Esc>"] = require("telescope.actions").close,
        },
      },
      layout_config = {
        horizontal = {
          width = 0.9,
          height = 0.7,
          preview_width = 0.5,
        },
        vertical = {
          width = 0.9,
          height = 0.9,
          preview_height = 0.5,
        },
      },
      layout_strategy = "horizontal",
    },
  },
}
