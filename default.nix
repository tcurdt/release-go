{ pkgs ? (
    let
      inherit (builtins) fetchTree fromJSON readFile;
      inherit ((fromJSON (readFile ./flake.lock)).nodes) nixpkgs gomod2nix;
    in
    import (fetchTree nixpkgs.locked) {
      overlays = [
        (import "${fetchTree gomod2nix.locked}/overlay.nix")
      ];
    }
  )
, buildGoApplication ? pkgs.buildGoApplication
}:

buildGoApplication {
  pname = "release-go";
  version = "__VERSION__";
  pwd = ./.;
  src = ./.;
  modules = ./gomod2nix.toml;

  # ldflags = [ "-s" "-w" "-X github.com/tcurdt/release-go/util.Version=${version}" ];

  # postInstall = ''
  #   install -Dm644 ${dist}/init/caddy.service ${dist}/init/caddy-api.service -t $out/lib/systemd/system

  #   substituteInPlace $out/lib/systemd/system/caddy.service --replace "/usr/bin/caddy" "$out/bin/caddy"
  #   substituteInPlace $out/lib/systemd/system/caddy-api.service --replace "/usr/bin/caddy" "$out/bin/caddy"

  #   $out/bin/caddy manpage --directory manpages
  #   installManPage manpages/*

  #   installShellCompletion --cmd caddy \
  #     --bash <($out/bin/caddy completion bash) \
  #     --fish <($out/bin/caddy completion fish) \
  #     --zsh <($out/bin/caddy completion zsh)
  # '';
}
