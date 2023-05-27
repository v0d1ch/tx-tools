
{ txToolsProject 
, system ? builtins.currentSystem
, pkgs
, cardano-node
}:
let
  nativePkgs = txToolsProject.hsPkgs;
in
rec { };
}
