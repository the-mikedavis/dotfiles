{ fetchFromGitHub, lib, rustPlatform, makeWrapper }:

# a derivation of helix based on my fork
rustPlatform.buildRustPackage rec {
  pname = "helix";
  version = "0.6.0.1-tmd";

  src = fetchFromGitHub {
    owner = "the-mikedavis";
    repo = pname;
    rev = "23a37037a23222e6fa990ba0c9d5537a9d1e7c80";

    # when building from a new rev, this value clashes first with lib.fakeSha256, then the
    # cargoSha256 after that
    #
    sha256 = "sha256-2loAsmSAZzadWGUTGu/GQvEMwPP4+YzYMYJQ1voYxX4=";
    # sha256 = lib.fakeSha256;
  };

  cargoSha256 = "sha256-y7bciYVv2bwvLr5UUcOIgh/qcQmv/ZSgakTmOmVFG5Q=";
  # cargoSha256 = lib.fakeSha256;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    mkdir -p $out/lib
    cp -r runtime $out/lib
  '';
  postFixup = ''
    wrapProgram $out/bin/hx --set HELIX_RUNTIME $out/lib/runtime
  '';

  # HAXXX -
  # Turn off tests: we need at least the rust grammar built to run tests
  # successfully after #1659. I should be able to fix this within my
  # own dotfiles because I use nix 2.6, but this is not easy to fix in
  # nix < 2.6 because `builtins.fromTOML` has bug that fails to parse
  # languages.toml.
  doCheck = false;

  meta = with lib; {
    description = "A post-modern modal text editor";
    homepage = "https://helix-editor.com";
    license = licenses.mpl20;
    mainProgram = "hx";
  };
}
