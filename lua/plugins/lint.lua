return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local lint = require("lint")
    local enabled = false

    lint.linters.shellcheck.args = {
      "--format",
      "json1",
      "-",
    }

    local function executable(name)
      return vim.fn.executable(name) == 1
    end

    local function add_linters(target, ft, linters)
      local available = {}

      for _, name in ipairs(linters) do
        if executable(name) then
          table.insert(available, name)
        end
      end

      if #available > 0 then
        target[ft] = available
      end
    end

    local linters_by_ft = {}
    add_linters(linters_by_ft, "lua", { "luacheck" })
    add_linters(linters_by_ft, "sh", { "shellcheck" })
    add_linters(linters_by_ft, "bash", { "shellcheck" })
    add_linters(linters_by_ft, "zsh", { "zsh" })
    add_linters(linters_by_ft, "python", { "ruff", "pylint" })
    add_linters(linters_by_ft, "json", { "jsonlint" })
    add_linters(linters_by_ft, "yaml", { "yamllint" })

    lint.linters_by_ft = linters_by_ft

    local group = vim.api.nvim_create_augroup("UserLint", { clear = true })

    local timers = {}

    local function run_lint(notify_status, bufnr)
      bufnr = bufnr or vim.api.nvim_get_current_buf()
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end

      vim.api.nvim_buf_call(bufnr, function()
        local filetype = vim.bo.filetype
        local linters = lint.linters_by_ft[filetype]

        if not linters or #linters == 0 then
          if notify_status then
            vim.notify(
              "No installed linter configured for filetype: " .. (filetype ~= "" and filetype or "unknown"),
              vim.log.levels.WARN
            )
          end
          return
        end

        lint.try_lint()
        if notify_status then
          vim.notify("Lint started: " .. table.concat(linters, ", "))
        end
      end)
    end

    local function try_lint(bufnr)
      if enabled then
        run_lint(false, bufnr)
      end
    end

    local function try_lint_debounced(bufnr)
      local timer = timers[bufnr]
      if timer then
        timer:stop()
        timer:close()
      end

      timers[bufnr] = vim.defer_fn(function()
        timers[bufnr] = nil
        try_lint(bufnr)
      end, 500)
    end

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged", "TextChangedI" }, {
      group = group,
      callback = function(event)
        try_lint_debounced(event.buf)
      end,
    })

    local initial_buf = vim.api.nvim_get_current_buf()
    vim.schedule(function()
      try_lint(initial_buf)
    end)

    vim.api.nvim_create_user_command("Lint", function()
      run_lint(true)
    end, {})

    local function toggle_linter()
      enabled = not enabled
      if enabled then
        run_lint(false)
      else
        vim.diagnostic.reset(nil, 0)
      end
      vim.notify("Lint " .. (enabled and "enabled" or "disabled"))
    end

    vim.api.nvim_create_user_command("LinterToggle", toggle_linter, {})
    vim.api.nvim_create_user_command("LintToggle", toggle_linter, {})

    vim.keymap.set({ "n", "i" }, "<F7>", function()
      if vim.api.nvim_get_mode().mode:match("^i") then
        vim.cmd.stopinsert()
      end
      enabled = true
      run_lint(true)
    end, { desc = "Enable and run lint" })

    vim.keymap.set({ "n", "i" }, "<S-F7>", function()
      enabled = false
      vim.diagnostic.reset(nil, 0)
      vim.notify("Lint disabled")
    end, { desc = "Disable lint" })

    vim.keymap.set({ "n", "i" }, "<F19>", function()
      enabled = false
      vim.diagnostic.reset(nil, 0)
      vim.notify("Lint disabled")
    end, { desc = "Disable lint" })
  end,
}
