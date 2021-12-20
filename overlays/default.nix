_final: prev: {
  helix = prev.callPackage ./helix.nix { };
  tree-sitter = prev.callPackage ./tree-sitter.nix { };
}
