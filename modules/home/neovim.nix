# neovim + nixd
{
  pkgs,
  self,
  hostName,
  flakeAttr,
  ...
}:

let
  # nixd autocomplete module path
  hostOptions = ''(builtins.getFlake \"${self}\").${flakeAttr}.${hostName}.options'';
  systemOptionsKey = if flakeAttr == "darwinConfigurations" then "nix-darwin" else "nixos";
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraConfig = ''
      set clipboard=unnamedplus
      set number relativenumber
      set expandtab tabstop=2 shiftwidth=2
      set ignorecase smartcase
      set scrolloff=5
      set undofile
      set mouse=a

      nnoremap <Esc><Esc> :nohlsearch<CR>
    '';

    initLua = ''
      vim.lsp.config("nixd", {
        cmd = { "${pkgs.nixd}/bin/nixd" },
        filetypes = { "nix" },
        root_markers = { "flake.nix", ".git" },
        settings = {
          nixd = {
            nixpkgs = { expr = "import ${self.inputs.nixpkgs} { }" },
            formatting = { command = { "${pkgs.nixfmt}/bin/nixfmt" } },
            options = {
              ["${systemOptionsKey}"] = { expr = "${hostOptions}" },
              ["home-manager"] = { expr = "${hostOptions}.home-manager.users.type.getSubOptions []" }
            },
          },
        },
      })
      vim.lsp.enable("nixd")

      vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "LSP format" })
    '';
  };
}
