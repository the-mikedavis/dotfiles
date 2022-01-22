# a butchered version of the tree-sitter installer in nixpkgs,
# pointing at my fork's dirty branch which has all my mods merged
# in, like tag testing and support for filenames in
# 'tree-sitter highlight' HTML output
{ lib
, stdenv
, fetchgit
, fetchFromGitHub
, fetchurl
, writeShellScript
, runCommand
, which
, formats
, rustPlatform
, jq
, nix-prefetch-git
, xe
, curl
, emscripten
, callPackage
, linkFarm

, enableShared ? !stdenv.hostPlatform.isStatic
, enableStatic ? stdenv.hostPlatform.isStatic
, webUISupport ? false
}:

rustPlatform.buildRustPackage rec {
  pname = "tree-sitter";
  version = "0.20.3";

  sha256 = "sha256-I0jHuW9bcaJrp49gHqbWQCPiTtxgMK6hFVlVj3x/zBA=";
  # sha256 = lib.fakeSha256;
  cargoSha256 = "sha256-9qbCQYdpGxPrZMiNmG5ZrqyuYbhSeADaYOgnn+zHDog=";
  # cargoSha256 = lib.fakeSha256;

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter";
    rev = "v${version}";
    inherit sha256;
    fetchSubmodules = true;
  };

  nativeBuildInputs =
    [ which ]
    ++ lib.optionals webUISupport [ emscripten ];

  postPatch = lib.optionalString (!webUISupport) ''
    # remove web interface
    sed -e '/pub mod web_ui/d' \
        -i cli/src/lib.rs
    sed -e 's/web_ui,//' \
        -e 's/web_ui::serve(&current_dir.*$/println!("ERROR: web-ui is not available in this nixpkgs build; enable the webUISupport"); std::process::exit(1);/' \
        -i cli/src/main.rs
  '';

  # Compile web assembly with emscripten. The --debug flag prevents us from
  # minifying the JavaScript; passing it allows us to side-step more Node
  # JS dependencies for installation.
  preBuild = lib.optionalString webUISupport ''
    bash ./script/build-wasm --debug
  '';

  postInstall = ''
    PREFIX=$out make install
    ${lib.optionalString (!enableShared) "rm $out/lib/*.so{,.*}"}
    ${lib.optionalString (!enableStatic) "rm $out/lib/*.a"}
  '';

  # test result: FAILED. 120 passed; 13 failed; 0 ignored; 0 measured; 0 filtered out
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tree-sitter/tree-sitter";
    description = "A parser generator tool and an incremental parsing library";
    longDescription = ''
      Tree-sitter is a parser generator tool and an incremental parsing library.
      It can build a concrete syntax tree for a source file and efficiently update the syntax tree as the source file is edited.

      Tree-sitter aims to be:

      * General enough to parse any programming language
      * Fast enough to parse on every keystroke in a text editor
      * Robust enough to provide useful results even in the presence of syntax errors
      * Dependency-free so that the runtime library (which is written in pure C) can be embedded in any application
    '';
    license = licenses.mit;
  };
}
