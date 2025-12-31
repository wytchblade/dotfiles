return {
  cmd = {
    'julia',
    '--project=@nvim-lspconfig',  -- use the same env you installed LanguageServer.jl into
    '--startup-file=no',
    '--history-file=no',
    '-e',
    [[
      using LanguageServer, Pkg, SymbolServer;
      depot_path = get(ENV, "JULIA_DEPOT_PATH", "");
      project_path = Base.current_project(pwd());
      server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path, depot_path);
      server.runlinter = true;
      run(server);
    ]]
  },

  filetypes = { 'julia' },

  -- detects project root automatically
  root_dir = function(fname)
    return vim.fs.root(fname, { 'Project.toml', '.git' }) or vim.fn.getcwd()
  end,

  -- optional capabilities / settings
  settings = {
    julia = {
      lint = { missingrefs = true, call = true, iter = true, lazy = true },
      format = { indent = 2 },
    },
  },
}
