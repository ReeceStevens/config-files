-- Autocomplete configuration
return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
      "rcarriga/cmp-dap",
      "petertriho/cmp-git",
      "tailwind-tools",
      "onsails/lspkind-nvim",
    },
    config = function()
        local cmp = require('cmp')
        cmp.setup {
            snippet = {
                expand = function(args)
                    vim.fn["vsnip#anonymous"](args.body)
                end,
            },
            enabled = function()
              return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
                  or require("cmp_dap").is_dap_buffer()
            end,
            mapping = cmp.mapping.preset.insert({
                ["<Tab>"] = cmp.mapping({
                    c = function()
                        if cmp.visible() then
                            cmp.select_next_item({behavior = cmp.SelectBehavior.Insert})
                        else
                            cmp.complete()
                        end
                    end,
                    i = function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                        else
                            fallback()
                        end
                    end,
                    s = function(fallback)
                        fallback()
                    end,
                }),
                ["<S-Tab>"] = cmp.mapping({
                    c = function()
                        if cmp.visible() then
                            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                        else
                            cmp.complete()
                        end
                    end,
                    i = function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                        else
                            fallback()
                        end
                    end,
                    s = function(fallback)
                        fallback()
                    end,
                }),
                ['<C-g>'] = cmp.mapping(function()
                  vim.api.nvim_feedkeys(vim.fn['copilot#Accept'](
                      vim.api.nvim_replace_termcodes('<Tab>', true, true, true)
                  ), 'n', true)
                end)
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                -- { name = 'vsnip' },
                { name = 'buffer' },
                { name = 'path' },
                { name = 'orgmode' },
                { name = 'dap' },
                { name = 'git' },
                { name = "codecompanion" },
            }),
            experimental = {
              ghost_text = false -- this feature conflict with copilot.vim's preview.
            },
            formatting = {
              format = require("lspkind").cmp_format({
                before = require("tailwind-tools.cmp").lspkind_format
              }),
            },
        }

        -- Completion for DAP repl shells
        cmp.setup.filetype({
        { "dap-repl", "dapui_watches", "dapui_hover" },
        {
          sources = {
            { name = "dap" },
          },
        }
        })

        cmp.setup.filetype('codecompanion', {
          sources = cmp.config.sources({
            { name = 'codecompanion' },
            { name = 'buffer' },
          }),
          completion = {
            autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged },
          },
        })

        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(':', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = 'path' }
          }, {
            { name = 'cmdline' }
          })
        })

    end
  },
}
