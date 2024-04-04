return {
  -- Add telescope-fzf-native
  {
    "telescope.nvim",
    dependencies = {
      {
        "desdic/telescope-rooter.nvim",
        config = function()
          require("telescope").setup({
            extensions = {
              rooter = {
                enabled = true,
                patterns = { ".git", ".project" },
                debug = false,
              },
            },
          })
          require("telescope").load_extension("rooter")
        end,
      },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        config = function()
          require("telescope").load_extension("live_grep_args")
        end,
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- Override a keymap to search relative to the current buffer
      -- stylua: ignore
      {
        "<leader>fc",
        function() require("telescope.builtin").find_files({ cwd = require("telescope.utils").buffer_dir(), hidden = true }) end,
        desc = "Find files (current buffer dir)",
      },
      {
        "<leader><space>",
        function()
          require("telescope.builtin").find_files()
        end,
        desc = "Find Files (root dir)",
      },
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files()
        end,
        desc = "Find Files (root dir)",
      },
      {
        "<leader>fh",
        function()
          require("telescope.builtin").find_files({ hidden = true })
        end,
        desc = "Find Files with Hidden (root dir)",
      },
      {
        "<leader>fi",
        function()
          require("telescope.builtin").find_files({ no_ignore = true })
        end,
        desc = "Find Files with Ignored (root dir)",
      },
      {
        "<leader>/",
        function()
          require("telescope").extensions.live_grep_args.live_grep_args()
        end,
        desc = "Live Grep Args (root dir)",
      },
      {
        "<leader>sg",
        function()
          require("telescope").extensions.live_grep_args.live_grep_args()
        end,
        desc = "Live Grep Args (root dir)",
      },
      {
        "<leader>sG",
        function()
          require("telescope").extensions.live_grep_args.live_grep_args({
            cwd = require("telescope.utils").buffer_dir(),
          })
        end,
        desc = "Live Grep Args (current buffer dir)",
      },
    },
    -- change some options
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
    config = function(_, opts)
      require("telescope").setup(opts)
    end,
  },
  -- Use <tab> for completion and snippets (supertab)
  -- first: disable default <tab> and <s-tab> behavior in LuaSnip
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
  -- then: setup supertab in cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- this way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
  },
  {
    "folke/flash.nvim",
    opts = {
      modes = {
        char = {
          jump_labels = true,
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "java",
        "go",
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "typescript-language-server",
        "marksman",
        "intelephense",
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      { "<leader>e", "<cmd>Neotree focus<cr>", { desc = "Focus Neotree" } },
      -- ^ Focus instead of toggle
    },
    opts = {
      commands = {
        copy_absolute_path = function(state)
          local node = state.tree:get_node() -- node in focus when keybind is pressed
          local absolute_path = node.path
          vim.print(absolute_path)
          vim.fn.setreg("+", absolute_path)
        end,
      },
      window = {
        mappings = {
          ["<M-c>"] = "copy_absolute_path",
        },
      },
    },
  },
  {
    "folke/flash.nvim",
    opts = {
      search = {
        mode = "fuzzy",
      },
    },
  },
}
