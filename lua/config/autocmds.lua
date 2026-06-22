local group = vim.api.nvim_create_augroup("UserConfig", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "lua", "json", "yaml", "toml" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "sh", "bash", "zsh", "python" },
  callback = function(event)
    local function run_current_file()
      local file = vim.api.nvim_buf_get_name(event.buf)
      if file == "" then
        return
      end

      vim.cmd.write()
      vim.fn.system({ "chmod", "ug+x", file })
      vim.cmd("!" .. vim.fn.shellescape(file))
    end

    vim.keymap.set({ "n", "i" }, "<S-F5>", run_current_file, {
      buffer = event.buf,
      desc = "Save and run current file",
    })
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  callback = function(event)
    vim.api.nvim_create_autocmd("BufWinEnter", {
      group = group,
      once = true,
      buffer = event.buf,
      callback = function()
        local ft = vim.bo[event.buf].filetype
        local last_line = vim.api.nvim_buf_get_mark(event.buf, '"')[1]

        if ft:match("commit") or ft:match("rebase") then
          return
        end

        if last_line > 1 and last_line <= vim.api.nvim_buf_line_count(event.buf) then
          pcall(vim.cmd.normal, { args = { 'g`"' }, bang = true })
        end
      end,
    })
  end,
})

vim.api.nvim_create_autocmd("SessionLoadPost", {
  group = group,
  command = "wincmd =",
})

local function is_editor_buffer(buf)
  if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].buftype ~= "" or vim.bo[buf].filetype == "neo-tree" then
    return false
  end

  if vim.api.nvim_buf_get_name(buf) ~= "" or vim.bo[buf].modified then
    return true
  end

  local lines = vim.api.nvim_buf_get_lines(buf, 0, 2, false)
  return #lines > 1 or lines[1] ~= ""
end

vim.api.nvim_create_autocmd("QuitPre", {
  group = group,
  callback = function()
    local current_win = vim.api.nvim_get_current_win()
    if not is_editor_buffer(vim.api.nvim_get_current_buf()) then
      return
    end

    local auxiliary_windows = {}
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if win ~= current_win then
        local buf = vim.api.nvim_win_get_buf(win)
        if is_editor_buffer(buf) then
          return
        end

        if vim.bo[buf].filetype == "neo-tree" or vim.bo[buf].buftype == "terminal" then
          table.insert(auxiliary_windows, win)
        end
      end
    end

    for _, win in ipairs(auxiliary_windows) do
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end
  end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = group,
  callback = function()
    vim.fn.mkdir(vim.fn.stdpath("state") .. "/shada", "p")
  end,
})
