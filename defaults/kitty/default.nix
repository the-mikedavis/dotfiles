{
  font = {
    name = "JetBrains Mono";
    size = 13;
  };
  shellIntegration.enableFishIntegration = true;
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
    # 100MB of saved history accessible in the pager (Ctrl-H)
    scrollback_pager_history_size = "100";
    # Use MacOS's Option key (on the left-hand-side of the keyboard) as
    # Alt.
    macos_option_as_alt = "left";
  };
  keybindings = {
    "ctrl+c" = "copy_and_clear_or_interrupt";
    "shift+left" = "previous_tab";
    "shift+right" = "next_tab";
    "ctrl+shift+enter" = "new_window_with_cwd";
  };
}
