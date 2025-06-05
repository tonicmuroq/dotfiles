-- options
vim.opt.fileencoding = "UTF-8"
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.updatetime = 300
vim.opt.background = "dark"
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.smartcase = true
vim.opt.mouse = ""
vim.opt.signcolumn = "yes"
vim.opt.pumheight = 15
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true
vim.opt.timeoutlen = 300
vim.opt.list = true

-- stupid diagnostic
---@diagnostic disable-next-line: missing-fields
vim.opt.listchars = {
  nbsp = "+",
  tab = "  ",
  trail = "-",
}
vim.opt.clipboard = "unnamed"

-- keymaps
vim.keymap.set("i", "jk", "<Esc>", { desc = "jk to <Esc>" })
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
vim.keymap.set(
  "n",
  "<Esc>",
  "<cmd>nohlsearch<cr>",
  { desc = "Clear search highlights when press <Esc> in normal mode" }
)

-- autocmds
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank()
  end,
  desc = "Highlight on yank",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go,make,gitconfig",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.expandtab = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "html,css,javascript,typescript,typescriptreact,scss,json,yaml,lua,c,cpp,java",
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  command = "set fo-=c fo-=r fo-=o",
  desc = "do not auto commenting new lines",
})

vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  signs = true,
  float = true,
})

-- plugins

-- init lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- setup lazy.nvim and all the plugins
require("lazy").setup({
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local builtin = require("telescope.builtin")
      local themes = require("telescope.themes")

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
              ["<C-[>"] = actions.close,
            },
          },
          dynamic_preview_title = true,
        },
        extensions = {
          ["fzf"] = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          ["ui-select"] = {
            themes.get_dropdown(),
          },
        },
      })
      telescope.load_extension("fzf")
      telescope.load_extension("live_grep_args")
      telescope.load_extension("ui-select")

      vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "Find [F]iles" })
      vim.keymap.set("n", "<leader>g", builtin.live_grep, { desc = "Live [G]rep" })
      vim.keymap.set("n", "<leader>o", builtin.oldfiles, { desc = "Old [O]pened files" })
      vim.keymap.set("n", "<leader>bb", builtin.buffers)
      vim.keymap.set("n", "<leader>rg", builtin.grep_string)
      vim.keymap.set("n", "<leader>xx", builtin.diagnostics)
      vim.keymap.set("n", "<leader>co", builtin.lsp_document_symbols)
      vim.keymap.set("n", "<leader>xb", function()
        builtin.diagnostics({ bufnr = 0 })
      end)
      vim.keymap.set("n", "gd", builtin.lsp_definitions)
      vim.keymap.set("n", "gt", builtin.lsp_type_definitions)
      vim.keymap.set("n", "gr", builtin.lsp_references)
      vim.keymap.set("n", "gi", builtin.lsp_implementations)
    end,
  },
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({
        triggers = { "<leader>" },
      })
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup({
        view = {
          adaptive_size = true,
        },
        update_focused_file = {
          enable = true,
        },
        git = {
          enable = true,
        },
      })
    end,
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "NvimTree" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        modules = {},
        ensure_installed = {},
        auto_install = true,
        sync_install = false,
        ignore_install = {},
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "j-hui/fidget.nvim",
        opts = {
          notification = {
            window = {
              winblend = 0,
            },
          },
        },
      },
      {
        "folke/neodev.nvim",
        opts = {},
      },
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
          map("K", vim.lsp.buf.hover, "Hover Documentation")

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }))
            end, "[T]oggle Inlay [H]ints")
          end
        end,
      })
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    version = "v1.32.0",
    dependencies = {
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      {
        "mason-org/mason.nvim",
        config = true,
      },
    },
    config = function()
      local servers = {
        lua_ls = {},
        bashls = {},
        clangd = {
          cmd = { "clangd", "--function-arg-placeholders=0", "--offset-encoding=utf-16" },
        },
        cssls = {},
        gopls = {},
        html = {},
        jsonls = {},
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "off",
                diagnosticSeverityOverrides = {
                  reportUnusedFunction = "off",
                },
              },
            },
          },
        },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              imports = {
                granularity = {
                  group = "crate",
                  enforce = true,
                },
              },
              checkOnSave = {
                command = "clippy",
              },
              completion = {
                callable = {
                  snippets = "add_parentheses",
                },
                postfix = {
                  enable = false,
                },
              },
              workspace = {
                symbol = {
                  search = {
                    kind = "all_symbols",
                  },
                },
              },
            },
          },
        },
        taplo = {},
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },
        ts_ls = {},
      }

      local ensure_installed = vim.tbl_keys(servers or {})

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

      require("neodev").setup()
      local lspconfig = require("lspconfig")

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = ensure_installed,
        automatic_installation = true,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            lspconfig[server_name].setup(server)
          end,
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    lazy = false,
    keys = {
      {
        "<leader>w",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = {
          proto = true,
        }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        go = { "goimports", "gofumpt" },
        javascript = { { "prettierd", "prettier" } },
        typescript = { "prettier" },
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")

      cmp.setup({
        completion = { completeopt = "menu,menuone,noinsert" },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "vsnip" },
          { name = "path" },
          { name = "buffer",  keyword_length = 4 },
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          expandable_indicator = true,
          format = lspkind.cmp_format({
            mode = "symbol_text",
            max_width = 200,
            symbol_map = { Copilot = "" },
          }),
        },
        window = {
          completion = {
            border = 'rounded',
            scrollbar = true,
            winhighlight = 'Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None',
          },
          documentation = {
            border = 'rounded',
            winhighlight = 'Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None',
          },
        },
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = { ensure_installed = { "delve" } },
      },
      {
        "leoluz/nvim-dap-go",
        opts = {},
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
      "rcarriga/nvim-dap-ui",
      {
        "jay-babu/mason-nvim-dap.nvim",
        cmd = { "DapInstall", "DapUninstall" },
        opts = {
          automatic_installation = true,
          handlers = {},
          ensure_installed = { "python", "delve" },
        },
      },
    },
    keys = {
      { "<leader>d",  "",                                                                                   desc = "+debug",                 mode = { "n", "v" } },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end,                                    desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end,                                             desc = "Continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end,                                        desc = "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end,                                                desc = "Go to Line (No Execute)" },
      { "<leader>di", function() require("dap").step_into() end,                                            desc = "Step Into" },
      { "<leader>dj", function() require("dap").down() end,                                                 desc = "Down" },
      { "<leader>dk", function() require("dap").up() end,                                                   desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end,                                             desc = "Run Last" },
      { "<leader>do", function() require("dap").step_out() end,                                             desc = "Step Out" },
      { "<leader>dO", function() require("dap").step_over() end,                                            desc = "Step Over" },
      { "<leader>dp", function() require("dap").pause() end,                                                desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end,                                          desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end,                                              desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end,                                            desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end,                                     desc = "Widgets" },
    },
    config = function()
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
      local dap_icons = {
        Stopped             = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
        Breakpoint          = { " ", "DiagnosticInfo" },
        BreakpointCondition = { " ", "DiagnosticInfo" },
        BreakpointRejected  = { " ", "DiagnosticError" },
        LogPoint            = { ".>", "DiagnosticInfo" },
      }
      for name, sign in pairs(dap_icons) do
        vim.fn.sign_define(
          "Dap" .. name,
          {
            text = sign[1],
            texthl = sign[2],
            linehl = sign[3],
            numhl = sign[3],
          }
        )
      end
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
    keys = {
      { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI" },
      { "<leader>de", function() require("dapui").eval() end,     desc = "Eval",  mode = { "n", "v" } },
    },
    opts = {},
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup(opts)

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
        vim.opt.mouse = "a"
      end

      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
        vim.opt.mouse = ""
      end

      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
        vim.opt.mouse = ""
      end
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
    },
    config = function()
      require("lualine").setup({
        options = {
          theme = "onedark",
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },
  {
    "b0o/incline.nvim",
    config = function()
      local helpers = require("incline.helpers")
      local devicons = require("nvim-web-devicons")
      require("incline").setup {
        window = {
          padding = 0,
          margin = { horizontal = 0 },
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if filename == "" then
            filename = "[No Name]"
          end
          local ft_icon, ft_color = devicons.get_icon_color(filename)
          local modified = vim.bo[props.buf].modified
          return {
            ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or "",
            " ",
            { filename, gui = modified and "bold,italic" or "bold" },
            " ",
            guibg = "#44406e",
          }
        end,
      }
    end,
    event = "VeryLazy",
  },
  {
    "hedyhli/outline.nvim",
    config = function()
      vim.keymap.set("n", "<leader>l", "<cmd>Outline<cr>", { desc = "Toggle Outline" })
      require("outline").setup()
    end,
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = "nvim-tree/nvim-web-devicons",
    keys = {
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>",            desc = "Toggle Pin" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>",          desc = "Delete Other Buffers" },
      { "<S-h>",      "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev Buffer" },
      { "<S-l>",      "<cmd>BufferLineCycleNext<cr>",            desc = "Next Buffer" },
      { "[B",         "<cmd>BufferLineMovePrev<cr>",             desc = "Move buffer prev" },
      { "]B",         "<cmd>BufferLineMoveNext<cr>",             desc = "Move buffer next" },
    },
    config = function()
      require("bufferline").setup({
        options = {
          show_buffer_close_icons = false,
          always_show_bufferline = true,
          offsets = {
            {
              filetype = "NvimTree",
              text = "NvimTree File Explorer",
              text_align = "left",
              separator = true,
            }
          },
        },
        highlights = {
          buffer_selected = {
            bold = true,
            italic = false,
          },
        },

      })
      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    config = function()
      require("dashboard").setup({
        shortcut_type = 'letter',
        config = {
          week_header = {
            enable = true,
          },
          disable_move = false,
        },
      })
    end,
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
    },
  },
  { "stevearc/dressing.nvim" },
  { "lifepillar/pgsql.vim" },
  { "uarun/vim-protobuf" },
  { "maralla/gomod.vim" },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = "copilot.lua",
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    opts = {
      provider = "copilot",
    },
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
      "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua",        -- for providers='copilot'
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            use_absolute_path = true,
          },
        },
      },
      {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        compile = false,
        undercurl = false,
        commentStyle = { italic = false },
        functionStyle = {},
        keywordStyle = { italic = false },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false,
        dimInactive = false,
        terminalColors = true,
        colors = {
          palette = {
            peachRed = "#E46876",
            sakuraPink = "#E46876",
          },
          theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
        },
        theme = "wave",
        overrides = function(colors)
          return {
            ["@string.special.url"] = { fg = colors.theme.syn.special1, undercurl = false },
            ["@variable.builtin"] = { fg = colors.theme.syn.special2, italic = false },
          }
        end,
        background = {
          dark = "wave",
          light = "lotus",
        },
      })
      vim.cmd.colorscheme("kanagawa")
    end,
  },
})
