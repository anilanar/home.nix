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
      version = "11.6.0";
      sha256 = "0lhrw24ilncdczh90jnjx71ld3b626xpk8b9qmwgzzhby89qs417";
    }

    {
      name = "prettier-vscode";
      publisher = "esbenp";
      version = "8.0.1";
      sha256 = "017lqpmzjxq5f1zr49akcm9gfki0qq8v7pj7gks6a3szjdx16mnl";
    }
    {
      name = "codestream";
      publisher = "CodeStream";
      version = "11.0.12";
      sha256 = "01r95accxvh1zpppdczgic2abcmx0jr3nrca6mi2n4ilg3d6a8ll";
    }
    {
      name = "copilot";
      publisher = "GitHub";
      version = "1.1.1959";
      sha256 = "1hk26hjdqm90hnbpr8vxs3jcgkh2jwn1fi1blv289a3kb5phkrhf";
    }
  ])
