return {
  "shaunsingh/nord.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.nord_contrast = true
    vim.g.nord_borders = false
    vim.g.nord_disable_background = false
    vim.g.nord_italic = false
    vim.g.nord_uniform_diff_background = true
    vim.g.nord_bold = false

    vim.cmd.colorscheme("nord")

    local function set_highlights()
      local hl = vim.api.nvim_set_hl

      hl(0, "Cursor", { fg = "#2E3440", bg = "#ECEFF4" })
      hl(0, "lCursor", { fg = "#2E3440", bg = "#ECEFF4" })
      hl(0, "TermCursor", { fg = "#2E3440", bg = "#ECEFF4" })
      hl(0, "iCursor", { fg = "#2E3440", bg = "#A3BE8C" })
      hl(0, "rCursor", { fg = "#2E3440", bg = "#EBCB8B" })
      hl(0, "CursorIM", { fg = "#2E3440", bg = "#A3BE8C" })
      hl(0, "CursorLine", { bg = "#3B4252" })
      hl(0, "CursorLineNr", { fg = "#ECEFF4", bg = "#3A4150", bold = true })
      hl(0, "WinSeparator", { fg = "#88C0D0", bg = "#2E3440" })
      hl(0, "ToggleTermSeparator", { fg = "#88C0D0", bg = "#2E3440" })
      hl(0, "MatchParen", { fg = "#8FBCBB", bg = "NONE", bold = true, underline = true })

      hl(0, "DiagnosticSignError", { fg = "#BF616A", bg = "NONE" })
      hl(0, "DiagnosticSignWarn", { fg = "#EBCB8B", bg = "NONE" })
      hl(0, "DiagnosticSignInfo", { fg = "#88C0D0", bg = "NONE" })
      hl(0, "DiagnosticSignHint", { fg = "#A3BE8C", bg = "NONE" })
      hl(0, "DiagnosticVirtualTextError", { fg = "#BF616A", bg = "#3B4252" })
      hl(0, "DiagnosticVirtualTextWarn", { fg = "#EBCB8B", bg = "#3B4252" })
      hl(0, "DiagnosticVirtualTextInfo", { fg = "#88C0D0", bg = "#3B4252" })
      hl(0, "DiagnosticVirtualTextHint", { fg = "#A3BE8C", bg = "#3B4252" })
      hl(0, "DiagnosticFloatingError", { fg = "#BF616A" })
      hl(0, "DiagnosticFloatingWarn", { fg = "#EBCB8B" })
      hl(0, "DiagnosticFloatingInfo", { fg = "#88C0D0" })
      hl(0, "DiagnosticFloatingHint", { fg = "#A3BE8C" })
    end

    set_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "nord",
      callback = set_highlights,
    })
  end,
}
