{ pkgs }:
let
  theme = {
    name = "gruvbox-dark";
    package = pkgs.gruvbox-dark-gtk;
  };
in
{
  inherit theme;
  gtk4.theme = theme;
  gtk3.bookmarks = [ "file:///home/michael/Downloads" ];
}
