-- Autocomplete configuration
local cmp = require'cmp'

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
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'orgmode' },
        { name = 'dap' },
    })
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

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
