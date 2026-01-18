-- BASIC SETTINGS

-- Tabs
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.smarttab = true
vim.opt.autoindent = true

-- Line numbering
vim.opt.number = true
-- vim.opt.relativenumber = true

-- Mouse and clipboard
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Appearance
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"

-- Useful things
vim.opt.undofile = true
vim.opt.scrolloff = 8
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Spell check
vim.opt.spell = true
vim.opt.spelllang = { 'en', 'ru' }

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- PLUGINS

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- Status bar and icons
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("lualine").setup({
          options = {
            theme = "auto",
            component_separators = '|',
            section_separators = '',
          },
        })
      end,
    },
    
    -- One Dark theme
    {
      "navarasu/onedark.nvim",
      lazy = false,
      priority = 1000,
      config = function()
        require('onedark').setup {
          style = 'darker'
        }
        require('onedark').load()
      end,
    },
    
    -- Comments (gcc for line, gbc for block)
    {
      "numToStr/Comment.nvim",
      config = function()
        require("Comment").setup()
      end,
    },
    
    -- Autopair brackets
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = function()
        require("nvim-autopairs").setup({})
      end,
    },
    
    -- Colors highlighting
    {
      "NvChad/nvim-colorizer.lua",
      config = function()
        require("colorizer").setup({
          user_default_options = {
            names = false,
          },
        })
      end,
    },
    
    -- File manager
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      cmd = "Neotree",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      },
      keys = {
        -- Assign Leader+e to open/close the tree
        { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
      },
      config = function()
        require("neo-tree").setup({
          close_if_last_window = true, -- Close Neovim if the tree is the last window left
          filesystem = {
            filtered_items = {
              visible = true, -- Show hidden files (.gitignore, etc.) in gray
              hide_dotfiles = false,
              hide_gitignored = false,
            },
            follow_current_file = {
              enabled = true, -- Automatically find an open file in the tree
            },
          },
        })
      end,
    },
    
    -- Buffer tabs at the top
    {
      "akinsho/bufferline.nvim",
      version = "*",
      dependencies = "nvim-tree/nvim-web-devicons",
      config = function()
        require("bufferline").setup({
          options = {
            -- Close buffer on right click
            right_mouse_command = "bdelete! %d", 
            -- Show the closing cross only if the buffer is changed
            show_close_icon = false,
            show_buffer_close_icons = true,
            -- Divider style (slanted, like in Powerline)
            separator_style = "slant", 
            -- We show diagnostics (errors) directly in the tab
            diagnostics = "nvim_lsp",
            
            -- Move tabs to the right if a file tree is open
            offsets = {
              {
                filetype = "neo-tree",
                text = "File Explorer",
                text_align = "center",
                separator = true,
              }
            },
          },
        })
      end,
    },
    
    -- Start screen
    {
      "goolord/alpha-nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        -- Logo
        dashboard.section.header.val = {
            "                                                     ",
            "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
            "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
            "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
            "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
            "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
            "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
            "                                                     ",
        }

        -- Menu buttons
        dashboard.section.buttons.val = {
          dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
          dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
          dashboard.button("g", "  Find text", ":Telescope live_grep<CR>"),
          dashboard.button("e", "  File Explorer", ":Neotree toggle<CR>"),
          dashboard.button("q", "󰈆  Quit", ":qa<CR>"),
        }

        alpha.setup(dashboard.opts)
      end,
    },
    
    -- Git icons in the left column (added, removed, modified)
    {
      "lewis6991/gitsigns.nvim",
      config = function()
        require("gitsigns").setup({
          current_line_blame = true, -- Shows "author, 2 years ago" to the right of the current line
          current_line_blame_opts = {
            delay = 500, -- Delay before display (to prevent flickering)
          },
        })
      end,
    },

    -- Powerful Git client (commands :Git, :Gdiff, etc.)
    {
      "tpope/vim-fugitive",
    },
    
    -- Telescope
    {
      "nvim-telescope/telescope.nvim",
      -- tag = "0.1.6", -- Stable version
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        local builtin = require("telescope.builtin")
        -- Configure hotkeys
        vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" }) -- Search for files
        vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Find Text" }) -- Search for text (requires ripgrep)
        vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" }) -- Search for open buffers
        vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find Help" }) -- Search for help
      end,
    },
    
    -- Syntax highlighting
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate", -- Update parsers when updating the plugin
      config = function()
        require("nvim-treesitter.config").setup({
          -- List of languages ​​for which parsers should be downloaded
          ensure_installed = { 
            "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", -- Neovim base
            "cpp", "java", "go", "python", "javascript", "html", "css" -- Add the languages ​​you write in here!
          },
          
          -- Automatically install the parser when opening a new file type
          auto_install = true,

          highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
          },
          indent = {
            enable = true,
          },
        })
      end,
    },
    
    -- Rainbow Parentheses
    {
      "HiPhish/rainbow-delimiters.nvim",
      event = "BufRead",
      config = function()
      end,
    },

    -- ==========================================
    -- LSP & AUTOCOMPLETION
    -- ==========================================
    
    -- 1. Mason (Language Server Installer)
    {
      "williamboman/mason.nvim",
      dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
      },
      config = function()
        require("mason").setup()
        require("mason-lspconfig").setup({
          -- Automatically install servers for these languages
          ensure_installed = { 
            "lua_ls",  -- Lua (for configuring Neovim)
            "clangd",  -- C++
            "gopls",   -- Go
            "pyright", -- Python
            "jdtls",   -- Java (Java 17+ required on your system!)
          }, 
        })
      end,
    },

    -- 2. LSP Config (Setting up server connections)
    {
      "neovim/nvim-lspconfig",
      config = function()
        local lspconfig = require("lspconfig")
        -- Adding autocompletion (cmp) capabilities to servers
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- A function that is triggered when an LSP is connected to a buffer
        local on_attach = function(client, bufnr)
          local opts = { buffer = bufnr, silent = true }
          
          -- Code navigation hotkeys (like in the IDE)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- Go to declaration
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- Go to definition (the most important!)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- Documentation in a pop-up window
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts) -- Show implementation
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- Rename
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- Actions (Code Action)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts) -- Where used (References)        
        end

        -- List of servers to launch
        local servers = { "clangd", "gopls", "pyright", "jdtls", "lua_ls" }
        
        for _, server in ipairs(servers) do
          lspconfig[server].setup({
            on_attach = on_attach,
            capabilities = capabilities,
            -- Special settings for Lua
            settings = server == "lua_ls" and {
              Lua = {
                diagnostics = { globals = { "vim" } }, -- To prevent vim from complaining about the global variable
                workspace = { library = vim.api.nvim_get_runtime_file("", true) },
              },
            } or nil,
          })
        end
      end,
    },

    -- 3.  Autocompletion(Cmp)
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
          "hrsh7th/cmp-nvim-lsp", -- Source: LSP
          "hrsh7th/cmp-buffer", -- Source: words from a file
          "hrsh7th/cmp-path", -- Source: file paths
          "L3MON4D3/LuaSnip", -- Snippet engine
          "saadparwaiz1/cmp_luasnip", -- Snippet and cmp bundle
      },
      config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        cmp.setup({
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-k>"] = cmp.mapping.select_prev_item(), -- Up the list
            ["<C-j>"] = cmp.mapping.select_next_item(), -- Down the list
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(), -- Call the menu
            ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Enter to select
            ["<Tab>"] = cmp.mapping(function(fallback)  -- Tab works smart
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback) -- Shift+Tab back
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s" }),
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" }, -- Hints from the language
            { name = "luasnip" }, -- Snippets
          }, {
            { name = "buffer" }, -- Words from the text
            { name = "path" }, -- File paths
          }),
        })
      end,
    },
  },
  
  -- automatically check for plugin updates
  checker = { enabled = true },
})

-- HOTKEYS

-- Clear search highlighting with Leader+Space
vim.keymap.set('n', '<leader><space>', ':nohlsearch<CR>', { silent = true, desc = "Clear highlight" })

-- Search for selected text with //
vim.keymap.set('v', '//', 'y/<C-R>"<CR>', { silent = true, desc = "Search selected text" })

-- Bufferline
vim.keymap.set('n', '<Tab>', ':BufferLineCycleNext<CR>', { silent = true, desc = "Next buffer" })
vim.keymap.set('n', '<S-Tab>', ':BufferLineCyclePrev<CR>', { silent = true, desc = "Prev buffer" })
vim.keymap.set('n', '<leader>x', ':bp|bd #<CR>', { silent = true, desc = "Close buffer" })

