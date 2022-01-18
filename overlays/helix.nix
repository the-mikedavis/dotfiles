{ fetchFromGitHub, lib, rustPlatform, makeWrapper }:

# a derivation of helix based on my fork
rustPlatform.buildRustPackage rec {
  pname = "helix";
  version = "0.6.0.1-tmd";

  src = fetchFromGitHub {
    owner = "the-mikedavis";
    repo = pname;
    rev = "9620100ef3fb577b619e8b9da44842382d3b5800";
    fetchSubmodules = true;
    # when building from a new rev, this value clashes first with lib.fakeSha256, then the
    # cargoSha256 after that
    #
    sha256 = "sha256-r3YGiQRmS0r28d5DHxRH+62fbcj3J2SonddQlszTI8c=";
    # sha256 = lib.fakeSha256;
  };

  cargoSha256 = "sha256-7oVGK+0oX+CKu4MAUeFJlGqzxcbEuKK73VWwdLcdAek=";
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
