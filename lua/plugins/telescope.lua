return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  cmd = "Telescope",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<F2>", function() require("telescope.builtin").buffers() end, desc = "Buffers" },
    { "<S-F2>", function() require("telescope.builtin").live_grep() end, desc = "Live grep" },
    { "<F14>", function() require("telescope.builtin").live_grep() end, desc = "Live grep" },
  },
  opts = {
    defaults = {
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
