_final: prev: {
  tree-sitter = prev.callPackage ./tree-sitter.nix { };
  apple-color-emoji = prev.callPackage ./apple-color-emoji.nix { };
}
