return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    auto_install = true,
    ensure_installed = {
      "lua",
      "vim",
      "vimdoc",
      "bash",
      "python",
      "json",
      "sql",
      "yaml",
      "toml",
      "markdown",
      "tmux",
      "ssh_config",
      "terraform",
      "nginx",
      "groovy",
      "pem",
      "dockerfile",
      "javascript",
      "css",
      "html",
    },
    -- Avoid concurrent installers racing over tree-sitter-<parser>-tmp
    -- while bootstrapping Neovim on a clean host.
    sync_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true,
    },
  },
  config = function(_, opts)
    local ok, configs = pcall(require, "nvim-treesitter.configs")
    if not ok then
      vim.notify("nvim-treesitter legacy config module is unavailable", vim.log.levels.WARN)
      return
    end

    local function first_node(match, capture)
      local nodes = match[capture]
      return type(nodes) == "table" and nodes[1] or nodes
    end

    vim.treesitter.query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
      local node = first_node(match, pred[2])
      if not node then
        return
      end

      local alias = vim.treesitter.get_node_text(node, bufnr):lower()
      local language_aliases = {
        ex = "elixir",
        pl = "perl",
        sh = "bash",
        ts = "typescript",
        uxn = "uxntal",
      }
      metadata["injection.language"] = vim.filetype.match({ filename = "a." .. alias })
        or language_aliases[alias]
        or alias
    end, { force = true })

    vim.treesitter.query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
      local node = first_node(match, pred[2])
      if not node then
        return
      end

      local mime = vim.treesitter.get_node_text(node, bufnr)
      local mime_languages = {
        importmap = "json",
        module = "javascript",
        ["application/ecmascript"] = "javascript",
        ["text/ecmascript"] = "javascript",
      }
      local parts = vim.split(mime, "/", { plain = true })
      metadata["injection.language"] = mime_languages[mime] or parts[#parts]
    end, { force = true })

    vim.treesitter.query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
      local capture = pred[2]
      local node = first_node(match, capture)
      if not node then
        return
      end

      metadata[capture] = metadata[capture] or {}
      local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[capture] }) or ""
      metadata[capture].text = text:lower()
    end, { force = true })

    -- GitHub's codeload archive endpoint sometimes 404s for pinned parser
    -- revisions that aren't a branch tip (e.g. tree-sitter-html), which
    -- surfaces as "gzip: stdin: not in gzip format". `git clone` of the
    -- same commit works fine, so prefer it over tarball downloads.
    require("nvim-treesitter.install").prefer_git = true

    configs.setup(opts)
  end,
}
