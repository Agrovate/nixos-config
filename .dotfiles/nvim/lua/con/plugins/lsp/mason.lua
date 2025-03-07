return {
    {
        "williamboman/mason.nvim",
        config = function()
        require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "pyright",
                    "html",
                    "eslint",
                    "cssls",
                    "vimls",
                    "rust_analyzer"
                }
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({capabilities = capabilities})
            lspconfig.pyright.setup({capabilities = capabilities})
            lspconfig.html.setup({capabilities = capabilities})
            lspconfig.eslint.setup({capabilities = capabilities})
            lspconfig.clangd.setup({capabilities = capabilities})

            vim.keymap.set({ 'n' }, '<leader>ca', vim.lsp.buf.code_action, {}) 
        end
    }
}
