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

