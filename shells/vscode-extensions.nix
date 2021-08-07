{ vscode-utils, vscode-extensions, ... }: {
  nix = vscode-extensions.bbenoist.Nix;
  vim = vscode-extensions.vscodevim.vim;
  eslint = (vscode-utils.extensionFromVscodeMarketplace {
    name = "vscode-eslint";
    publisher = "dbaeumer";
    version = "2.1.23";
    sha256 = "1wqcnbj1ckifxfw951sfhq2vyliac10i9101mk46jli36mihkjgi";
  });
  stylelint = (vscode-utils.extensionFromVscodeMarketplace {
    name = "vscode-stylelint";
    publisher = "stylelint";
    version = "0.86.0";
    sha256 = "06wvrm4n39zv1qvzv4askw5329dnjnfmg6qrcdbywmafxjpkk30x";
  });
  nixfmt = (vscode-utils.extensionFromVscodeMarketplace {
    name = "nixfmt-vscode";
    publisher = "brettm12345";
    version = "0.0.1";
    sha256 = "07w35c69vk1l6vipnq3qfack36qcszqxn8j3v332bl0w6m02aa7k";
  });
  editorConfig = (vscode-utils.extensionFromVscodeMarketplace {
    name = "EditorConfig";
    publisher = "EditorConfig";
    version = "0.16.4";
    sha256 = "0fa4h9hk1xq6j3zfxvf483sbb4bd17fjl5cdm3rll7z9kaigdqwg";
  });
  gitlens = (vscode-utils.extensionFromVscodeMarketplace {
    name = "gitlens";
    publisher = "eamodio";
    version = "11.6.0";
    sha256 = "0lhrw24ilncdczh90jnjx71ld3b626xpk8b9qmwgzzhby89qs417";
  });

  prettier = (vscode-utils.extensionFromVscodeMarketplace {
    name = "prettier-vscode";
    publisher = "esbenp";
    version = "8.0.1";
    sha256 = "017lqpmzjxq5f1zr49akcm9gfki0qq8v7pj7gks6a3szjdx16mnl";
  });
  codestream = (vscode-utils.extensionFromVscodeMarketplace {
    name = "codestream";
    publisher = "CodeStream";
    version = "11.0.12";
    sha256 = "01r95accxvh1zpppdczgic2abcmx0jr3nrca6mi2n4ilg3d6a8ll";
  });
  copilot = (vscode-utils.extensionFromVscodeMarketplace {
    name = "copilot";
    publisher = "GitHub";
    version = "1.1.1959";
    sha256 = "1hk26hjdqm90hnbpr8vxs3jcgkh2jwn1fi1blv289a3kb5phkrhf";
  });
  ts-auto-return = (vscode-utils.extensionFromVscodeMarketplace {
    name = "vscode-ts-auto-return-type";
    publisher = "ebrithil30";
    version = "1.1.0";
    sha256 = "13q0h47jpaqg3hwr9y4wi1x79w54fiyjxgd40mgng7aakg2nj9zk";
  });
  haskell = (vscode-utils.extensionFromVscodeMarketplace {
    name = "haskell";
    publisher = "haskell";
    version = "1.5.1";
    sha256 = "1y3c09m0dcx21kksxydmys9d040571chfh7yc7qsa33p4ha522jj";
  });
  language-haskell = (vscode-utils.extensionFromVscodeMarketplace {
    name = "language-haskell";
    publisher = "justusadam";
    version = "3.4.0";
    sha256 = "0ab7m5jzxakjxaiwmg0jcck53vnn183589bbxh3iiylkpicrv67y";
  });
}