{ compiler ? "ghc8107"

, system ? builtins.currentSystem

, haskellNix

, iohk-nix

, CHaP

, nixpkgs ? iohk-nix.nixpkgs

}:
let
  pkgs = import nixpkgs {
    inherit system;
    overlays = [
      haskellNix.overlay
      iohk-nix.overlays.crypto
    ];
  };

  hsPkgs = pkgs.haskell-nix.project {
    # TODO: probably should use flake.nix inputs.self here
    src = pkgs.haskell-nix.haskellLib.cleanGit {
      name = "tx-tools";
      src = ./..;
    };
    projectFileName = "cabal.project";
    compiler-nix-name = compiler;

    inputMap = { "https://input-output-hk.github.io/cardano-haskell-packages" = CHaP; };

    modules = [
      ({ pkgs, lib, ... }:
        {
          packages.cardano-crypto-class.components.library.pkgconfig = lib.mkForce [ [ pkgs.libsodium-vrf pkgs.secp256k1 ] ];
          packages.cardano-crypto-praos.components.library.pkgconfig = lib.mkForce [ [ pkgs.libsodium-vrf ] ];
        }
      )
    ];
  };
in
{
  inherit compiler pkgs hsPkgs;
}
