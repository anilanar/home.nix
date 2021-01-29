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
      name = "EditorConfig";
      publisher = "EditorConfig";
      version = "0.16.4";
      sha256 = "0fa4h9hk1xq6j3zfxvf483sbb4bd17fjl5cdm3rll7z9kaigdqwg";
    }
    {
      name = "gitlens";
      publisher = "eamodio";
      version = "11.1.3";
      sha256 = "1x9bkf9mb56l84n36g3jmp3hyfbyi8vkm2d4wbabavgq6gg618l6";
    }
    {
      name = "prettier-vscode";
      publisher = "esbenp";
      version = "5.8.0";
      sha256 = "0h7wc4pffyq1i8vpj4a5az02g2x04y7y1chilmcfmzg2w42xpby7";
    }
    {
      name = "codestream";
      publisher = "CodeStream";
      version = "10.4.1";
      sha256 = "0l8n1rv4rpzy58i0n2pyd16l6iaib0w8ik5wk0kp9bw5l2vbqb09";
    }
  ])
