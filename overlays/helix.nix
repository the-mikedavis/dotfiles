{ fetchFromGitHub, lib, rustPlatform, makeWrapper }:

# a derivation of helix based on my fork
rustPlatform.buildRustPackage rec {
  pname = "helix";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "the-mikedavis";
    repo = pname;
    rev = "852b6033934ba2bc7a3b84309fd666530971ac2f";
    fetchSubmodules = true;
    # when building from a new rev, this value clashes first with lib.fakeSha256, then the
    # cargoSha256 after that
    #
    sha256 = "sha256-gO9ioq5Q0Z7leQYcVqPVKqUSfhAMIyrY0gz7d5yY4uY=";
    # sha256 = lib.fakeSha256;
  };

  cargoSha256 = "sha256-bGJgwayaeOQdDoMZAtNSqijy+66SQboMPCv/gXww0FI=";
  # cargoSha256 = lib.fakeSha256;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    mkdir -p $out/lib
    cp -r runtime $out/lib
  '';
  postFixup = ''
    wrapProgram $out/bin/hx --set HELIX_RUNTIME $out/lib/runtime
  '';

  meta = with lib; {
    description = "A post-modern modal text editor";
    homepage = "https://helix-editor.com";
    license = licenses.mpl20;
    mainProgram = "hx";
  };
}
