{ fetchFromGitHub, lib, rustPlatform, makeWrapper }:

# a derivation of helix based on my fork
rustPlatform.buildRustPackage rec {
  pname = "helix";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "the-mikedavis";
    repo = pname;
    rev = "20b6b4a3930115e3e8c11ec4c1727c12d8ea7956";
    fetchSubmodules = true;
    sha256 = "sha256-ckrHeKINpQQWSW8MIRxd7Y34WcH4bwCn0SSwZe24xMI=";
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
