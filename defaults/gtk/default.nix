{ pkgs }:
{
  theme = {
    name = "gruvbox-dark";
    package = pkgs.gruvbox-dark-gtk;
  };
  gtk3.bookmarks = [ "file:///home/michael/Downloads" ];
}
