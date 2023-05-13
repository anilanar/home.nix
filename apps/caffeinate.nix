pkgs:
pkgs.rustPlatform.buildRustPackage rec {
  name = "caffeinate";
  version = "0.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "rschmukler";
    repo = "caffeinate";
    rev = version;
    sha256 = "sha256-dzAZX240XrzUpUxHxo3kxgaXo70CqBPoE++0kpzE1xQ=";
  };

  cargoSha256 = "sha256-3sDCZsjZGs1pI9dp19nJt3di3nrjfnG2v2MW71+dUdg=";
}
