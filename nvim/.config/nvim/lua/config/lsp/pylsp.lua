vim.lsp.config['pylsp'] = {
  -- Command and arguments to start the server.
  cmd = { 'pylsp' },
  -- Filetypes to automatically attach to.
  filetypes = { 'python' },
  -- Sets the "workspace" to the directory where any of these files is found.
  -- Files that share a root directory will reuse the LSP server connection.
  -- Nested lists indicate equal priority, see |vim.lsp.Config|.
   root_markers = {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    '.git',
  }, -- Specific settings to send to the server. The schema is server-defined.
  -- Example: https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
}

vim.lsp.enable('pylsp')
