{ fetchFromGitHub, lib, rustPlatform, makeWrapper }:

# a derivation of helix based on my fork
rustPlatform.buildRustPackage rec {
  pname = "helix";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "the-mikedavis";
    repo = pname;
    rev = "0a25a148c0ac9cd7d5867f98a6b4a64d7a92b016";
    fetchSubmodules = true;
    sha256 = "sha256-fP28iLx1SE/Ip/Z9YRlPJnRKDAryOZjDajTORvkRPVY=";
    # sha256 = lib.fakeSha256;
  };

  cargoSha256 = "sha256-YKUBirMFdJXm9E6y99Zm+jtIxrc2yaubksJ+ZVYacfk=";
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
