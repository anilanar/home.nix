{ pkgs }:
with pkgs; {
  nix = (vscode-utils.extensionFromVscodeMarketplace {
    name = "Nix";
    publisher = "bbenoist";
    version = "1.0.1";
    sha256 = "0zd0n9f5z1f0ckzfjr38xw2zzmcxg1gjrava7yahg5cvdcw6l35b";
  });
  vim = (vscode-utils.extensionFromVscodeMarketplace {
    name = "vim";
    publisher = "vscodevim";
    version = "1.21.10";
    sha256 = "0c9m7mc2kmfzj3hkwq3d4hj43qha8a75q5r1rdf1xfx8wi5hhb1n";
  });
  eslint = (vscode-utils.extensionFromVscodeMarketplace {
    name = "vscode-eslint";
    publisher = "dbaeumer";
    version = "2.2.2";
    sha256 = "17j4czb1lxgy62l0rsdf06ld3482cqplxglsh7p4zyp50p4samln";
  });
  stylelint = (vscode-utils.extensionFromVscodeMarketplace {
    name = "vscode-stylelint";
    publisher = "stylelint";
    version = "1.2.1";
    sha256 = "0nq0bz8zyqjwxjg6g8rhkcx4lf75nkbn98dj90s43s0ykcqx0vzw";
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
    version = "11.7.0";
    sha256 = "0apjjlfdwljqih394ggz2d8m599pyyjrb0b4cfcz83601b7hk3x6";
  });
  prettier = (vscode-utils.extensionFromVscodeMarketplace {
    name = "prettier-vscode";
    publisher = "esbenp";
    version = "9.0.0";
    sha256 = "1nak1hg46wxkl0kb0zhc343kq2f4nd5q1fqscb29jybd4qdb8lgn";
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
    version = "1.7.3952";
    sha256 = "1kkgrjvy996hah5ly95vaywfjaibb0lcbf7md8by9r8s97sb2i8w";
  });
  jest = (vscode-utils.extensionFromVscodeMarketplace {
    name = "jestRunIt";
    publisher = "vespa-dev-works";
    version = "0.6.0";
    sha256 = "0i05153n9p4izlspz701qdhmz08wszn4ajliamx72x0r2na3bxcy";
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
  svelte = (vscode-utils.extensionFromVscodeMarketplace {
    name = "svelte-vscode";
    publisher = "svelte";
    version = "105.5.3";
    sha256 = "1pa7san5qz5brnrgrs2ykflrgbq31q5vvy8caj4cxyvvq48s1frb";
  });
  rust = (vscode-utils.extensionFromVscodeMarketplace {
    name = "rust-analyzer";
    publisher = "matklad";
    version = "0.2.853";
    sha256 = "HYq8PuzchMwx0wd3SInitGzhNQe2biw2Njl+xdNuWjk=";
  });
  gherkin = (vscode-utils.extensionFromVscodeMarketplace {
    name = "cucumberautocomplete";
    publisher = "alexkrechik";
    version = "2.15.1";
    sha256 = "R6r4Ar2N7T0CYw25Za3SSx4g7CD21ZS+ZO/D8VRrUTA=";
  });
}
