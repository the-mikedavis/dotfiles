{ fetchFromGitHub, lib, rustPlatform, makeWrapper, runCommand, yj }:

# a derivation of helix based on my fork
let
  src = fetchFromGitHub {
    owner = "the-mikedavis";
    repo = "helix";
    rev = "83827d797e33e23f2c8d4cb5ecdc122ad79ef8fe";

    # when building from a new rev, this value clashes first with lib.fakeSha256, then the
    # cargoSha256 after that
    #
    sha256 = "sha256-Y4IUFm2FJYZQoLNMsaz7seyeBI5IYrSvWzNyAzqNXpE=";
    # sha256 = lib.fakeSha256;
  };

  languages-json = runCommand "languages-toml-to-json" {} ''
    ${yj}/bin/yj -t < ${src}/languages.toml > $out
  '';
  config = builtins.fromJSON (builtins.readFile (builtins.toPath languages-json));
  isGitGrammar = (grammar:
    builtins.hasAttr "source" grammar && builtins.hasAttr "git" grammar.source
    && builtins.hasAttr "rev" grammar.source);
  gitGrammars = builtins.filter isGitGrammar config.grammar;
  mapGrammar = grammar: {
    name = grammar.name;
    source = fetchGit {
      url = grammar.source.git;
      rev = grammar.source.rev;
      allRefs = true;
    };
  };
  grammars = builtins.map mapGrammar gitGrammars;

  grammarLinks = builtins.foldl' (acc: grammar: ''
    ln -s ${grammar.source} $out/lib/runtime/grammars/sources/${grammar.name}
    ${acc}'') "\n" grammars;
in rustPlatform.buildRustPackage rec {
  inherit src;

  pname = "helix";
  version = "0.6.0.5-tmd";

  cargoSha256 = "sha256-KYu8s9d8DbU3oGvu/hhYCW0T5GWsEcB1uqnuXXxaAlA=";
  # cargoSha256 = lib.fakeSha256;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    mkdir -p $out/lib
    cp -r runtime $out/lib
    mkdir -p $out/lib/runtime/grammars/sources

    ${grammarLinks}

    HELIX_RUNTIME=$out/lib/runtime $out/bin/hx --build-grammars
  '';

  postFixup = ''
    wrapProgram $out/bin/hx --set HELIX_RUNTIME $out/lib/runtime
  '';

  # HACK:
  # Turn off tests - we need at least the rust grammar built to run tests
  # successfully after #1659. This could be fixed in theory: nix can build
  # the grammars just fine itself, and that might even make the postInstall
  # step much cleaner. So just build the grammars in a separate derivation
  # and then drop them in in the postUnpack phase.
  doCheck = false;

  meta = with lib; {
    description = "A post-modern modal text editor";
    homepage = "https://helix-editor.com";
    license = licenses.mpl20;
    mainProgram = "hx";
  };
}
