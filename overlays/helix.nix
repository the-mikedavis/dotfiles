{ fetchFromGitHub, lib, rustPlatform, makeWrapper }:

# a derivation of helix based on my fork
let
  src = fetchFromGitHub {
    owner = "the-mikedavis";
    repo = "helix";
    rev = "4da7aa0441be8dd7df775cdf3c39be78f7cc7ccd";

    # when building from a new rev, this value clashes first with lib.fakeSha256, then the
    # cargoSha256 after that
    #
    sha256 = "sha256-o021YCSXiGwZH9qZVLICumZhd8tfG5Kry4GWkME7QiU=";
    # sha256 = lib.fakeSha256;
  };
  config = (builtins.fromTOML
    (builtins.readFile "${builtins.toPath src}/languages.toml")).language;
  gitGrammars = builtins.filter (lang:
    builtins.hasAttr "grammar" lang && builtins.hasAttr "source" lang.grammar
    && builtins.hasAttr "git" lang.grammar.source) config;
  grammars = builtins.map (lang: {
    name = lang.name;
    source = fetchGit {
      url = lang.grammar.source.git;
      rev = lang.grammar.source.rev;
      allRefs = true;
    };
  }) gitGrammars;
  grammarLinks = builtins.foldl' (acc: grammar: ''
    ln -s ${
      builtins.toPath grammar.source
    } $out/lib/runtime/grammars/sources/${grammar.name}
    ${acc}'') "\n" grammars;
in rustPlatform.buildRustPackage rec {
  inherit src;

  pname = "helix";
  version = "0.6.0.3-tmd";

  cargoSha256 = "sha256-TzMGITvJ3vWiwtyRu+s1J7v88QskTx1NV1W5yA9Bgww=";
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
