{ fetchFromGitHub, lib, rustPlatform, makeWrapper }:

# a derivation of helix based on my fork
rustPlatform.buildRustPackage rec {
  pname = "helix";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "the-mikedavis";
    repo = pname;
    rev = "911758f105391ca49e4e7b4289d21d524f8c3cd1";
    fetchSubmodules = true;
    sha256 = "sha256-mfeYhTP3ZWGUO4czDIkzZcYK16pX3JZNToYYv4LJ7cY=";
  };

  cargoSha256 = "sha256-9zNdF7rPp4e6PtkdSyFC1upUEq24oU/XheknZoK+iMc=";

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
