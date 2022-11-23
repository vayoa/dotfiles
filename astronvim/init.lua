return {
  options = {
    opt = {
      foldmethod = 'expr',
    },
    g = {
      -- Neovide
      neovide_refresh_rate = 144,
      neovide_scale_factor = 0.75,
      neovide_transparency = 0.9,
      neovide_cursor_vfx_mode = "pixiedust",

      -- Leetcode
      leetcode_browser = 'chrome',
      leetcode_solution_filetype = 'python3'
    }
  },
  -- Key Mappings
  mappings = {
    n = {
      ['<leader>j'] = { "<cmd>HopWord<cr>", desc = "Hop Word" },
      ['<leader>r'] = { "<cmd>HopPattern<cr>", desc = "Hop Pattern" }
    }
  },

  -- Lsp Settings
  lsp = {
    servers = { "pylsp" },
    skip_setup = { "rust_analyzer", "dartls" }, -- skip lsp setup because rust-tools and flutter-tools will do it themselves
    ["server-settings"] = {
      dartls = {
        color = {
          enabled = true,
        },
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
        },
      },
    },
  },

  -- Custom Plugins
  plugins = {
    init = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
      {
        "phaazon/hop.nvim",
        branch = 'v2',
        config = function()
          require('hop').setup({
            uppercase_labels = true,
          })
        end
      },
      {
        "kylechui/nvim-surround",
        tag = "*",
        config = function()
          require("nvim-surround").setup({})
        end
      },
      { 'ianding1/leetcode.vim' },

      -- Lsp Related Plugins
      {
        "simrat39/rust-tools.nvim",
        after = "mason-lspconfig.nvim", -- make sure to load after mason-lspconfig
        config = function()
          require("rust-tools").setup {
            server = astronvim.lsp.server_settings "rust_analyzer", -- get the server settings and built in capabilities/on_attach
          }
        end,
      },
      {
        "akinsho/flutter-tools.nvim",
        requires = "nvim-lua/plenary.nvim",
        after = "mason-lspconfig.nvim", -- make sure to load after mason-lspconfig
        config = function()
          require("flutter-tools").setup {
            lsp = astronvim.lsp.server_settings "dartls", -- get the server settings and built in capabilities/on_attach
          }
        end,
      },
    },

    -- Treesitter Config (mainly used for treesitter textobjects)
    treesitter = {
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
          }
        }
      },
      -- Install treesitter grammars.
      ensure_installed = { "rust", "dart", "yaml", "python", "lua" }
    },

    ["mason-lspconfig"] = {
      -- Install lsp (we're not installing dartls because it's bundled with the dart runtime)
      ensure_installed = { "rust_analyzer", "sumneko_lua", "pyright", "yamlls" },
    },
  },

  -- Polish Function
  polish = function()
    vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
  end
}
