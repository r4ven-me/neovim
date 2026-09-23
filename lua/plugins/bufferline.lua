return {
  "akinsho/bufferline.nvim",
  version = "*",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "famiu/bufdelete.nvim",
  },
  keys = {
    { "<S-l>", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
    { "<S-h>", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
  },
  config = function()
    vim.cmd([[
      function! OpenFileExplorer(_1, _2, _3, _4)
        Neotree toggle
      endfunction
    ]])

    vim.cmd([[
      function! OpenAIChat(_1, _2, _3, _4)
        if exists(':CodeCompanionChat') == 2
          CodeCompanionChat Toggle
        else
          echohl ErrorMsg
          echom 'CodeCompanion requires Neovim 0.11+. Run ~/bin/install-neovim first.'
          echohl None
        endif
      endfunction

      function! OpenBottomTerminal(_1, _2, _3, _4)
        lua toggle_bottom_terminal()
      endfunction
    ]])

    local function open_buffer(bufnr)
      local current_buf = vim.api.nvim_get_current_buf()

      if vim.bo[current_buf].filetype == "neo-tree" then
        local editor_win = require("neo-tree").get_prior_window({
          "codecompanion",
          "codecompanion_input",
          "terminal",
          "toggleterm",
        }, true)

        if editor_win < 0 or not vim.api.nvim_win_is_valid(editor_win) then
          vim.notify("No editor window available", vim.log.levels.WARN)
          return
        end

        vim.api.nvim_set_current_win(editor_win)
      end

      vim.api.nvim_set_current_buf(bufnr)
    end

    require("bufferline").setup({
      options = {
        mode = "buffers",
        themable = true,
        numbers = "none",
        close_command = "Bdelete! %d",
        left_mouse_command = open_buffer,
        right_mouse_command = "Bdelete! %d",
        middle_mouse_command = "Bdelete! %d",
        diagnostics = "nvim_lsp",
        show_buffer_icons = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        show_tab_indicators = true,
        persist_buffer_sort = true,
        separator_style = "thick",
        always_show_bufferline = true,
        indicator = {
          icon = "",
          style = "icon",
        },
        offsets = {
          {
            filetype = "neo-tree",
            text = " Files",
            highlight = "Directory",
            separator = true,
          },
        },
        custom_areas = {
          left = function()
            return {
              { text = " %@OpenFileExplorer@  %X ", bg = "#5E81AC", fg = "#ECEFF4", gui = "bold" },
              { text = " ", fg = "#5E81AC" },
            }
          end,
          right = function()
            return {
              { text = " ", fg = "#5E81AC" },
              { text = " %@OpenAIChat@ 󰍹 %X ", bg = "#5E81AC", fg = "#ECEFF4", gui = "bold" },
              { text = "", bg = "#5E81AC", fg = "#81A1C1" },
              { text = " %@OpenBottomTerminal@  %X ", bg = "#5E81AC", fg = "#ECEFF4", gui = "bold" },
            }
          end,
        },
      },
      highlights = {
        fill = { fg = "#3B4252", bg = "#3B4252" },
        background = { fg = "#D8DEE9", bg = "#434C5E" },
        tab = { fg = "#D8DEE9", bg = "#434C5E" },
        tab_selected = { fg = "#ECEFF4", bg = "#5E81AC", bold = true, italic = false },
        tab_separator = { fg = "#3B4252", bg = "#4C566A" },
        tab_separator_selected = { fg = "#3B4252", bg = "#5E81AC" },
        buffer_selected = { fg = "#ECEFF4", bg = "#5E81AC", bold = true, italic = false },
        buffer_visible = { fg = "#D8DEE9", bg = "#434C5E" },
        separator = { fg = "#3B4252", bg = "#3B4252" },
        indicator_visible = { fg = "#D8DEE9", bg = "#434C5E" },
        modified = { fg = "#EBCB8B", bg = "#434C5E" },
        modified_visible = { fg = "#EBCB8B", bg = "#434C5E" },
        modified_selected = { fg = "#EBCB8B", bg = "#5E81AC" },
        duplicate_selected = { fg = "#E5E9F0", bg = "#5E81AC", italic = true },
        duplicate_visible = { bg = "#434C5E", italic = true },
        duplicate = { fg = "#D8DEE9", bg = "#434C5E", italic = true },
        error = { fg = "#BF616A", bg = "#434C5E" },
        error_visible = { fg = "#BF616A", bg = "#434C5E" },
        error_selected = { fg = "#ECEFF4", bg = "#5E81AC", bold = true, italic = false },
        warning = { fg = "#EBCB8B", bg = "#434C5E" },
        warning_visible = { fg = "#EBCB8B", bg = "#434C5E" },
        warning_selected = { fg = "#ECEFF4", bg = "#5E81AC", bold = true, italic = false },
        trunc_marker = { fg = "#81A1C1", bg = "#434C5E" },
        offset_separator = { bg = "#2E3440" },
      },
    })
  end,
}
