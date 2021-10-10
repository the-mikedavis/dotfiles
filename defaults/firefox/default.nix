{ pkgs }:
let
  user-chrome = pkgs.fetchurl {
    url = "https://gist.githubusercontent.com/GrantCuster/fb8631e711b8595084f7a551c6fb44ee/raw/73e9ebd70fa1afea36d5b4965aa8dc3ffbc0d2dd/userChrome.css";
    sha256 = "1a5wap0dngryqa7mwcwxprn2x5qb3avhy601lzbs873z70ghga3x";
  };
in
{
  package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
    forceWayland = true;
  };
  profiles = {
    default = {
      id = 0;
      isDefault = true;
      name = "default";
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "layers.acceleration.force-enabled" = true;
        "gfx.webrender.all" = true;
        "gfx.webrender.enabled" = true;
        "layout.css.backdrop-filter.enabled" = true;
        "svg.context-properties.content.enabled" = true;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.urlbar.suggest.quicksuggest" = false;
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.suggest.topsites" = false;
        "browser.urlbar.autoFill" = false;
        "browser.urlbar.quicksuggest.enabled" = false;
      };
      
      userChrome = builtins.readFile user-chrome;
    };
  };
}
