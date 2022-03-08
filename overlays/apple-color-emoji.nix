{ lib }:
let
  pname = "apple-color-emoji";
  version = "55ef43bbeca8adfedc2f5db833ae85e8266b6157";
in
builtins.fetchurl {
  name = "${pname}-${version}";
  url = "https://github.com/samuelngs/apple-emoji-linux/releases/download/latest/AppleColorEmoji.ttf";
  # sha256 = lib.fakeSha256;
  sha256 = "sha256:0dg0d6x5l74lmyhgn0d7ilz7gb1wkf0r50c418xv870xam1csl0g";
}
