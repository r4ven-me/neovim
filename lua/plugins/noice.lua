local function toggle_history()
  if vim.bo.filetype == "TelescopePrompt" then
    require("telescope.actions").close(vim.api.nvim_get_current_buf())
    return
  end

  require("noice").cmd("telescope")
end

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  keys = {
    { "<S-F4>", toggle_history, mode = { "n", "i", "t" }, desc = "Toggle Noice history" },
    { "<F16>", toggle_history, mode = { "n", "i", "t" }, desc = "Toggle Noice history" },
  },
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "rcarriga/nvim-notify",
      opts = {
        stages = "fade_in_slide_out",
        timeout = 4000,
        top_down = true,
      },
    },
  },
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    presets = {
      bottom_search = true,
      command_palette = false,
      long_message_to_split = true,
      inc_rename = false,
      lsp_doc_border = true,
    },
  },
}
