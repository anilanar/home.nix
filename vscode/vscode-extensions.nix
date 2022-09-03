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
    version = "2.2.3";
    sha256 = "0sl9d85wbac3h79a5y5mcv0rhcz8azcamyiiyix0b7klcr80v56d";
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
    version = "12.0.4";
    sha256 = "1s1wrrp5i7cqm8c4x67c9b19mf1sjpcxklyl58rfsnmjbrlnazsg";
  });
  prettier = (vscode-utils.extensionFromVscodeMarketplace {
    name = "prettier-vscode";
    publisher = "esbenp";
    version = "9.3.0";
    sha256 = "1w6whr6h5v7i16f3j1kahs02mk7w2jplr5rrnsjwyszvcy6hz644";
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
    version = "2.3.0";
    sha256 = "IddDJvdDWQ/DdG2J6gCFZG644TkAUsoQmg08ktowMxA=";
  });
  tailwind = (vscode-utils.extensionFromVscodeMarketplace {
    name = "vscode-tailwindcss";
    publisher = "bradlc";
    version = "0.7.7";
    sha256 = "qRMTK7cEch+Y+sjXh9tQPEIMznpDmHVp/9b1XLzp8CE=";
  });
  github = (vscode-utils.extensionFromVscodeMarketplace {
    name = "vscode-pull-request-github";
    publisher = "GitHub";
    version = "0.39.2022031015";
    sha256 = "jz/aI4LkdH92hIYmEki+Ijn9bMZAsoLdRFOY0AJMLXk=";
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
    version = "1.6.0";
    sha256 = "OHzZl3G4laob7E3cgvZJ2EcuPGBf3CfEZ8/4SYNnfog=";
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
    version = "1.22.0";
    sha256 = "+cY9uLQ4oIk7V/4uCNc6BdIAQCXvPPGeqd0apbDjDos=";
  });
}
