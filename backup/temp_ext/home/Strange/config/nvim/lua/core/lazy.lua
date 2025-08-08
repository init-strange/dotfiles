-- Lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

vim.fn.system({ 'git', 'config', '--global', 'url."https://".insteadOf', 'git@github.com:' })
vim.fn.system({ 'git', 'config', '--global', 'url."https://".insteadOf', 'git://' })

--
-- Plugins
local plugins ={
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },
  { "nvim-treesitter/nvim-treesitter",build =":TSUpdate"},
{
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ["l"] = "open",
          ["h"] = "close_node",
          ["<CR>"] = "noop",
          ["<BS>"] = "noop",
          ["u"] = "navigate_up", -- ← put it here if you want it filesystem-only
        },
      },
    },
  },
},

{
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
    },
    'nvim-telescope/telescope-file-browser.nvim',
  },
  config = function()
    require('telescope').setup({
      defaults = {
        file_ignore_patterns = {
          -- Folders
          "Videos/", "Media/", "Movies/", "Personal/",

          -- File types
          "%.mp4$", "%.mkv$", "%.webm$", "%.mp3$", "%.flac$", "%.wav$",
          -- "%.jpg$", "%.png$", "%.jpeg$", "%.gif$", "%.svg$",
          -- "%.zip$", "%.tar$", "%.gz$", "%.rar$",
        },
      },
      extensions = {
        file_browser = {
          theme = "dropdown",
          hijack_netrw = true,
        },
      },
    })
    require("telescope").load_extension("fzf")
    require("telescope").load_extension("file_browser")
  end,
},
-- Mason LSP manager
  { "williamboman/mason.nvim", build = ":MasonUpdate", config = true },
  { "williamboman/mason-lspconfig.nvim", dependencies = { "williamboman/mason.nvim" }, config = true },

--THEMES
  { "catppuccin/nvim", name = "catppuccin", priority = 1000, },
  { "folke/tokyonight.nvim" },
  { "ellisonleao/gruvbox.nvim"},
  { "EdenEast/nightfox.nvim" },
  { "rose-pine/neovim", name = "rose-pine" }

}--PLUGINS-END

local opts = { }
require("lazy").setup(plugins ,opts)
--
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "clangd",                   -- C/C++
    "pyright",                  -- Python
    "lua_ls",                   -- Lua
    "ts_ls",                 -- JS/TS (still use this name for Mason)
    "html",                     -- HTML
    "cssls",                    -- CSS
    "jsonls",                   -- JSON
    "yamlls",                   -- YAML
    "bashls",                   -- Bash
    "marksman",                 -- Markdown
    "dockerls",                 -- Dockerfile
    "vimls",                    -- Vimscript
    "gopls",                    -- Go
    "rust_analyzer",            -- Rust
    "jdtls",                    -- Java
  }
})
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local servers = {
  clangd = {},
  pyright = {},
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
      },
    },
  },
  ts_ls = {},
  html = {},
  cssls = {},
  jsonls = {},
  yamlls = {},
  bashls = {},
  marksman = {},
  dockerls = {},
  vimls = {},
  gopls = {},
  rust_analyzer = {},
  jdtls = {},
}

for name, opts in pairs(servers) do
  lspconfig[name].setup({
    capabilities = capabilities,
    settings = opts.settings or {},
  })
end
--

-- Completion
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(), -- trigger completion
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- confirm selection
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }
})

--INITIALIZE-TELESCOPE
local builtin = require("telescope.builtin")
--INITIALIZE-TREESITTER
local config = require("nvim-treesitter.configs")
config.setup({
    ensure_installed = {
      -- core systems + C family
      "c", "cpp","asm", "lua", "make", "cmake", "bash",
      -- scripting & automation
      "python", "ruby", "perl",
      -- web dev
      "html", "css", "javascript", "typescript", "json", "yaml",
      -- markdown and docs
      "markdown", "markdown_inline", "vim", "vimdoc",
      -- configs and data
      "toml", "ini", "dockerfile", "gitignore",
      -- extras you might explore later
      "rust", "go", "java"
    },
    highlight={enable = true},
    indent   ={enable = true},
})
