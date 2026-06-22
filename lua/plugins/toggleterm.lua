return {
  "akinsho/toggleterm.nvim",
  version = "*",
  lazy = false,
  init = function()
    _G.toggle_bottom_terminal = function()
      vim.cmd("1ToggleTerm direction=horizontal")
    end

    _G.keep_bottom_terminal_full_width = function(restore_focus)
      local term = require("toggleterm.terminal").get(1, true)
      if not term or not term:is_open() or not vim.api.nvim_win_is_valid(term.window) then
        return
      end

      local current_win = vim.api.nvim_get_current_win()
      vim.api.nvim_set_current_win(term.window)
      vim.cmd("wincmd J")

      if restore_focus and vim.api.nvim_win_is_valid(current_win) then
        vim.api.nvim_set_current_win(current_win)
      end
    end
  end,
  opts = {
    size = 15,
    open_mapping = nil,
    direction = "horizontal",
    persist_size = true,
    persist_mode = false,
    start_in_insert = true,
    shade_terminals = false,
    shell = vim.o.shell,
    on_open = function(term)
      local previous_win = vim.fn.win_getid(vim.fn.winnr("#"))
      if previous_win ~= 0 and vim.api.nvim_win_is_valid(previous_win) then
        vim.t.toggleterm_last_editor_win = previous_win
      end

      _G.keep_bottom_terminal_full_width(false)

      vim.api.nvim_set_hl(0, "ToggleTermSeparator", { fg = "#88C0D0", bg = "#2E3440" })

      local winhighlight = vim.wo[term.window].winhighlight
      if not winhighlight:find("WinSeparator:", 1, true) then
        vim.wo[term.window].winhighlight = table.concat({
          winhighlight,
          "WinSeparator:ToggleTermSeparator",
        }, ","):gsub("^,", "")
      end

      local function resize(delta)
        vim.cmd(("resize %s%d"):format(delta > 0 and "+" or "", delta))
      end

      local opts = { buffer = term.bufnr, silent = true }
      local function enter_terminal_mode()
        if term:is_open() and vim.api.nvim_get_current_win() == term.window then
          vim.cmd("startinsert")
        end
      end

      vim.keymap.set({ "n", "t" }, "<C-Up>", function()
        resize(2)
      end, vim.tbl_extend("force", opts, { desc = "Increase terminal height" }))
      vim.keymap.set({ "n", "t" }, "<C-Down>", function()
        resize(-2)
      end, vim.tbl_extend("force", opts, { desc = "Decrease terminal height" }))

      vim.defer_fn(enter_terminal_mode, 50)
    end,
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    local toggle = "<cmd>1ToggleTerm direction=horizontal<CR>"
    local toggle_keys = { "<F4>", "<S-F4>", "<F16>" }

    for _, key in ipairs(toggle_keys) do
      vim.keymap.set("n", key, toggle, {
        noremap = true,
        silent = true,
        nowait = true,
        desc = "Toggle bottom terminal",
      })
      vim.keymap.set("i", key, "<Esc>" .. toggle, {
        noremap = true,
        silent = true,
        nowait = true,
        desc = "Toggle bottom terminal",
      })
      vim.keymap.set("t", key, [[<C-\><C-n>]] .. toggle, {
        noremap = true,
        silent = true,
        nowait = true,
        desc = "Toggle bottom terminal",
      })
    end

    local function forward_to_editor(key)
      vim.cmd.stopinsert()

      local previous_win = vim.t.toggleterm_last_editor_win
      if type(previous_win) == "number" and previous_win ~= 0 and vim.api.nvim_win_is_valid(previous_win) then
        local previous_buf = vim.api.nvim_win_get_buf(previous_win)
        if vim.bo[previous_buf].buftype ~= "terminal" then
          vim.api.nvim_set_current_win(previous_win)
        end
      end

      vim.schedule(function()
        local mapping = vim.fn.maparg(key, "n", false, true)

        if type(mapping.callback) == "function" then
          local ok, err = pcall(mapping.callback)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
          return
        end

        if type(mapping.rhs) == "string" and mapping.rhs ~= "" then
          local rhs = vim.api.nvim_replace_termcodes(mapping.rhs, true, false, true)
          vim.api.nvim_feedkeys(rhs, "nx", false)
          return
        end

        vim.notify("No editor mapping for " .. key, vim.log.levels.WARN)
      end)
    end

    vim.keymap.set("t", "<F3>", function()
      local terminal_win = vim.api.nvim_get_current_win()
      vim.t.toggleterm_restore_win = terminal_win

      require("neo-tree.command").execute({
        action = "show",
        source = "filesystem",
        position = "left",
        toggle = true,
      })

      if vim.api.nvim_win_is_valid(terminal_win) then
        vim.api.nvim_set_current_win(terminal_win)
        vim.cmd.startinsert()
      end
    end, {
      noremap = true,
      silent = true,
      nowait = true,
      desc = "Toggle Neo-tree without leaving terminal",
    })

    local editor_function_keys = {
      "<S-F1>",
      "<F13>",
      "<F2>",
      "<S-F2>",
      "<F5>",
      "<S-F5>",
      "<F7>",
      "<S-F7>",
      "<F19>",
      "<F9>",
      "<F10>",
      "<F11>",
      "<F12>",
      "<S-F9>",
      "<S-F10>",
      "<S-F11>",
      "<S-F12>",
      "<F21>",
      "<F22>",
      "<F23>",
      "<F24>",
    }

    for _, key in ipairs(editor_function_keys) do
      local editor_key = key
      vim.keymap.set("t", editor_key, function()
        forward_to_editor(editor_key)
      end, {
        noremap = true,
        silent = true,
        nowait = true,
        desc = "Run " .. editor_key .. " in the editor",
      })
    end
  end,
}
