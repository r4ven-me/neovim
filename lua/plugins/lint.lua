return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local lint = require("lint")
    local enabled = true

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

    local timer

    local function try_lint()
      if enabled then
        lint.try_lint()
      end
    end

    local function try_lint_debounced()
      if timer then
        timer:stop()
      end

      timer = vim.defer_fn(try_lint, 500)
    end

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged", "TextChangedI" }, {
      group = group,
      callback = try_lint_debounced,
    })

    vim.api.nvim_create_user_command("Lint", try_lint, {})
    vim.api.nvim_create_user_command("LintToggle", function()
      enabled = not enabled
      if not enabled then
        vim.diagnostic.reset(nil, 0)
      end
      vim.notify("Lint " .. (enabled and "enabled" or "disabled"))
    end, {})

    vim.keymap.set({ "n", "i" }, "<F7>", function()
      if vim.api.nvim_get_mode().mode:match("^i") then
        vim.cmd.stopinsert()
      end
      try_lint()
    end, { desc = "Run lint" })

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
