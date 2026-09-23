return {
  "dstein64/nvim-scrollview",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    scrollview_current_only = true,
    scrollview_excluded_filetypes = { "neo-tree" },
    hide_on_cursor_intersect = true,
    hide_on_text_intersect = true,
  },
}
