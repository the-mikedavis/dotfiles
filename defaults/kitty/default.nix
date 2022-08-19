{
  font = {
    name = "JetBrains Mono";
    size = 13;
  };
  settings = {
    disable_ligatures = "never";
    window_padding_width = "38";
    cursor_blink_interval = "0";
    enable_audio_bell = "no";
    visual_bell_duration = "0.0";
    window_alert_on_bell = "no";
    bell_on_tab = "no";
    term = "xterm-kitty";
    allow_remote_control = "yes";
    # Use MacOS's Option key (on the left-hand-side of the keyboard) as
    # Alt.
    macos_option_as_alt = "left";
    # defaults to 1
    # background_opacity = "0.98";
    # ---
    # colors
    background = "#282828";
    foreground = "#ebdbb2";
    cursor = "#928374";
    selection_foreground = "#928374";
    selection_background = "#3c3836";
    color0 = "#282828";
    color8 = "#928374";
    color1 = "#cc241d";
    color9 = "#fb4934";
    color2 = "#98971a";
    color10 = "#b8bb26";
    color3 = "#d79921";
    color11 = "#fabd2d";
    color4 = "#458588";
    color12 = "#83a598";
    color5 = "#b16286";
    color13 = "#d3869b";
    color6 = "#689d6a";
    color14 = "#8ec07c";
    color7 = "#a89984";
    color15 = "#a79889";
  };
  keybindings = {
    "ctrl+c" = "copy_and_clear_or_interrupt";
    "shift+left" = "previous_tab";
    "shift+right" = "next_tab";
    "ctrl+shift+enter" = "new_window_with_cwd";
  };
}
