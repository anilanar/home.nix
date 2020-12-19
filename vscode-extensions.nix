{ pkgs, ... }:

(with pkgs.vscode-extensions;
[ bbenoist.Nix vscodevim.vim ]
++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
  {
    name = "nixfmt-vscode";
    publisher = "brettm12345";
    version = "0.0.1";
    sha256 = "07w35c69vk1l6vipnq3qfack36qcszqxn8j3v332bl0w6m02aa7k";
    }
    {
    name = "editorconfig";
    publisher = "editorconfig";
    version = "0.14.5";
    sha256 = "1bp6x5ha6vz0y7yyk4xsylp7d4z8qv20ybfbr3qqajnf61rzdbkg";
    }
    {
    name = "gitlens";
    publisher = "eamodio";
    version = "10.2.1";
    sha256 = "1bh6ws20yi757b4im5aa6zcjmsgdqxvr1rg86kfa638cd5ad1f97";

    }
    {
    name = "prettier-vscode";
    publisher = "esbenp";
    version = "4.4.0";
    sha256 = "16iaz8y0cihqlkiwgxgvcyzick8m3xwqsa3pzjdcx5qhx73pykby";
    }
    ])
