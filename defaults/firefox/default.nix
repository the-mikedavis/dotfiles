{ pkgs }:
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
        "security.insecure_password.ui.enabled" = false;
        "security.insecure_field_warning.contextual.enabled" = false;
      };
    };
  };
}
