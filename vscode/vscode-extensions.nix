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
    version = "1.24.1";
    sha256 = "00gq6mqqwqipc6d7di2x9mmi1lya11vhkkww9563avchavczb9sv";
  });
  eslint = (vscode-utils.extensionFromVscodeMarketplace {
    name = "vscode-eslint";
    publisher = "dbaeumer";
    version = "2.2.6";
    sha256 = "0m16wi8slyj09r1y5qin9xsw4pyhfk3mj6rs5ghydfnppb45w9np";
  });
  stylelint = (vscode-utils.extensionFromVscodeMarketplace {
    name = "vscode-stylelint";
    publisher = "stylelint";
    version = "1.2.3";
    sha256 = "0k1p9lzgcmdas23d33wm0x3n72kq0xicijzali167gdgnxbfvknf";
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
    version = "2022.10.1719";
    sha256 = "0pz2b6hbqwvj8x3jfzlgrqfi15nian8l47czsrzq0jx68sh315n2";
  });
  prettier = (vscode-utils.extensionFromVscodeMarketplace {
    name = "prettier-vscode";
    publisher = "esbenp";
    version = "9.9.0";
    sha256 = "1zba2k51ylpzz47r74kdr2adp669xw19a866gw0wndcigkhcrgk2";
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
  zipfs = (vscode-utils.extensionFromVscodeMarketplace {
    name = "vscode-zipfs";
    publisher = "arcanis";
    version = "3.0.0";
    sha256 = "0wvrqnsiqsxb0a7hyccri85f5pfh9biifq4x2bllpl8mg79l5m68";
  });
  tailwind = (vscode-utils.extensionFromVscodeMarketplace {
    name = "vscode-tailwindcss";
    publisher = "bradlc";
    version = "0.9.1";
    sha256 = "088y3fvnb4414pksnrrv1hjnvhp36d5p2qz9wclwma07mrsjcpb5";
  });
  github = (vscode-utils.extensionFromVscodeMarketplace {
    name = "vscode-pull-request-github";
    publisher = "GitHub";
    version = "0.53.2022101718";
    sha256 = "10cpd2y1yjjx16nq329mwgzma99j3vxaa9xj1wapfmlpq0wcy00j";
  });
  k8s = (vscode-utils.extensionFromVscodeMarketplace {
    name = "vscode-kubernetes-tools";
    publisher = "ms-kubernetes-tools";
    version = "1.3.7";
    sha256 = "sha256-B9koR8TQk7NA/u29LxS4KPjXWAT/kmVVP9BbzGxFNdQ=";
  });
  bridge-to-k8s = (vscode-utils.extensionFromVscodeMarketplace {
    name = "mindaro";
    publisher = "mindaro";
    version = "1.0.120220125";
    sha256 = "nIRqW00v7nCyWemFf5IcCD6GiS7dB/OJrw9lEpaYl24=";
  });
  yaml = (vscode-utils.extensionFromVscodeMarketplace {
    name = "vscode-yaml";
    publisher = "redhat";
    version = "1.11.10112022";
    sha256 = "0i53n9whcfpds9496r4pa27j3zmd4jc1kpkf4m4rfxzswwngg47x";
  });
  file-downloader = (vscode-utils.extensionFromVscodeMarketplace {
    name = "file-downloader";
    publisher = "mindaro-dev";
    version = "1.0.11";
    sha256 = "buzdn9DyWdabkDdFPbRkr6RU3cueHzueeOIGrYxkZ64=";
  });
  docker = (vscode-utils.extensionFromVscodeMarketplace {
    name = "vscode-docker";
    publisher = "ms-azuretools";
    version = "1.22.1";
    sha256 = "1ix363fjxi9g450rs3ghx44z3hppvasf0xpzgha93m90djd7ai52";
  });
}
