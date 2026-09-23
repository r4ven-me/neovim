return {
  "olimorris/codecompanion.nvim",
  version = "*",
  enabled = vim.fn.has("nvim-0.11") == 1,
  cmd = {
    "CodeCompanion",
    "CodeCompanionActions",
    "CodeCompanionChat",
    "CodeCompanionCLI",
    "CodeCompanionCodeReview",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      ft = { "markdown", "codecompanion" },
      opts = {
        file_types = { "markdown", "codecompanion" },
      },
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "codecompanion", "codecompanion_input" },
      callback = function()
        vim.schedule(function()
          if _G.keep_bottom_terminal_full_width then
            _G.keep_bottom_terminal_full_width(true)
          end
        end)
      end,
    })
  end,
  keys = {
    { "<F5>", "<cmd>CodeCompanionChat Toggle<CR>", mode = { "n", "i" }, desc = "Toggle AI chat" },
    { "<leader>ai", "<cmd>CodeCompanionChat Toggle<CR>", desc = "Toggle AI chat" },
    { "<leader>aa", "<cmd>CodeCompanionActions<CR>", mode = { "n", "v" }, desc = "AI actions" },
  },
  opts = {
    adapters = {
      acp = {
        extend = {
          codex = {
            defaults = {
              auth_method = "chat-gpt",
            },
          },
        },
      },
    },
    interactions = {
      chat = {
        adapter = "codex",
      },
      cli = {
        agent = "claude_code",
        agents = {
          claude_code = {
            cmd = "claude",
            args = {},
            description = "Claude Code CLI",
            provider = "terminal",
          },
          codex = {
            cmd = "codex",
            args = {},
            description = "OpenAI Codex CLI",
            provider = "terminal",
          },
        },
      },
    },
    display = {
      action_palette = {
        provider = "telescope",
      },
      chat = {
        show_context = false,
        show_header_separator = false,
        window = {
          layout = "vertical",
          position = "right",
          width = 0.4,
        },
        start_in_insert_mode = true,
      },
    },
    opts = {
      language = "Russian",
    },
  },
}
