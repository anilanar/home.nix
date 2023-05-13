pkgs:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "xidlehook-caffeinate";
  version = "0.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "rschmukler";
    repo = "caffeinate";
    rev = version;
    sha256 = "sha256-dzAZX240XrzUpUxHxo3kxgaXo70CqBPoE++0kpzE1xQ=";
  };

  cargoHash = "sha256-G3Z3T677WwQ0ijAjeViChdfw4B2B3N1zWVVwaRSedL0=";
}
