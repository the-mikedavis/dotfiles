{ fetchFromGitHub, lib, rustPlatform, makeWrapper }:

# a derivation of helix based on my fork
rustPlatform.buildRustPackage rec {
  pname = "helix";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "the-mikedavis";
    repo = pname;
    rev = "5a488665b6294d65ef9ab53e0993a575dc4bf673";
    fetchSubmodules = true;
    sha256 = "sha256-7UBQgAiTyZWRVUSh94j3vYGSM4u6wmCxjXuFPF+/6MA=";
  };

  cargoSha256 = "sha256-cwEX+758YoADpGxFvXC/q+h1pzzdPnFEVcvnAfPrxTs=";

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
