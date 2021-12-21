{ fetchFromGitHub, lib, rustPlatform, makeWrapper }:

# a derivation of helix based on my fork
rustPlatform.buildRustPackage rec {
  pname = "helix";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "the-mikedavis";
    repo = pname;
    rev = "509028f77cf401531e32bf88f44df0b8039d7fe8";
    fetchSubmodules = true;
    sha256 = "sha256-pyx5eFNwBoBapbJXRSa6rUFMzkumqKi87lbT3xLd/7c=";
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
