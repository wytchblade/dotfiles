return {
    "neovim/nvim-lspconfig",
    config = function()
        -- vim.lsp.enable("julials")
        vim.lsp.enable("luals")
        -- vim.lsp.enable("basedpyright")
        vim.lsp.enable("tsserver")
        vim.lsp.enable("yamlls")
        vim.lsp.enable("texlab")
    end,
}








