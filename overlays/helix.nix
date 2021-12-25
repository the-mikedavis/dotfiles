{ fetchFromGitHub, lib, rustPlatform, makeWrapper }:

# a derivation of helix based on my fork
rustPlatform.buildRustPackage rec {
  pname = "helix";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "the-mikedavis";
    repo = pname;
    rev = "bfd51c8f26261859c70e9bfccb46ae66feb77cd9";
    fetchSubmodules = true;
    sha256 = "sha256-Ujr48FLN2+qqx1Wsm/92j2FfEBWm5EMo9w7/nnIVTv0=";
  };

  cargoSha256 = "sha256-owU8iUX96c0/x3end5fzZ7qmTgsvjGgw9D46dW94czo=";

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
