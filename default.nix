{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "release-go";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "tcurdt";
    repo = "release-go";
    rev = "v${version}";
    hash = "sha256-Ai4uvLkl4e4Z6x1wZb5BzpLvWhxHhg4D1QpCdSjwQ5I=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.commit=${src.rev}"
    "-X=main.date=1970-01-01T00:00:00Z"
    "-X=main.treeState=false"
    "-X=main.builtBy=goreleaser"
  ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/tcurdt/release-go";
    license = licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with maintainers; [ ];
    mainProgram = "release-go";
  };
}
