pkgs:
pkgs.buildGoModule rec {
  pname = "turborepo";
  version = "1.6.3";

  src = "${
      pkgs.fetchFromGitHub {
        owner = "vercel";
        repo = "turbo";
        rev = "v${version}";
        sha256 = "csapIeVB0FrLnmtUmLrRe8y54xmK50X30CV476DXEZI=";
      }
    }/cli";

  vendorSha256 = "Kx/CLFv23h2TmGe8Jwu+S3QcONfqeHk2fCW1na75c0s=";
  nativeBuildInputs = with pkgs; [ protobuf protoc-gen-go protoc-gen-go-grpc ];

  preBuild = ''
    make compile-protos
  '';

  doCheck = false;
}
