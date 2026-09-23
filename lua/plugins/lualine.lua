return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      theme = {
        normal = {
          a = { fg = "#ECEFF4", bg = "#5E81AC", gui = "bold" },
          b = { fg = "#E5E9F0", bg = "#4C566A" },
          c = { fg = "#D8DEE9", bg = "#3B4252" },
        },
        insert = {
          a = { fg = "#2E3440", bg = "#A3BE8C", gui = "bold" },
          b = { fg = "#E5E9F0", bg = "#4C566A" },
          c = { fg = "#D8DEE9", bg = "#3B4252" },
        },
        visual = {
          a = { fg = "#2E3440", bg = "#B48EAD", gui = "bold" },
          b = { fg = "#E5E9F0", bg = "#4C566A" },
          c = { fg = "#D8DEE9", bg = "#3B4252" },
        },
        replace = {
          a = { fg = "#2E3440", bg = "#EBCB8B", gui = "bold" },
          b = { fg = "#E5E9F0", bg = "#4C566A" },
          c = { fg = "#D8DEE9", bg = "#3B4252" },
        },
        command = {
          a = { fg = "#2E3440", bg = "#88C0D0", gui = "bold" },
          b = { fg = "#E5E9F0", bg = "#4C566A" },
          c = { fg = "#D8DEE9", bg = "#3B4252" },
        },
        inactive = {
          a = { fg = "#D8DEE9", bg = "#3B4252" },
          b = { fg = "#D8DEE9", bg = "#3B4252" },
          c = { fg = "#81A1C1", bg = "#2E3440" },
        },
      },
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      globalstatus = true,
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diagnostics" },
      lualine_c = {
        { "filename", path = 1 },
      },
      lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
    extensions = { "neo-tree", "quickfix" },
  },
}
