{ fetchFromGitHub, lib, rustPlatform, makeWrapper }:

# a derivation of helix based on my fork
rustPlatform.buildRustPackage rec {
  pname = "helix";
  version = "0.6.0.1-tmd";

  src = fetchFromGitHub {
    owner = "the-mikedavis";
    repo = pname;
    rev = "f80f230a17461b141982a8fa43329b7bbe67694a";
    fetchSubmodules = true;
    # when building from a new rev, this value clashes first with lib.fakeSha256, then the
    # cargoSha256 after that
    #
    sha256 = "sha256-7epdriU0AmBCHyi0r0PLoAfHSePJuvFIDerNvTqbb5U=";
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
