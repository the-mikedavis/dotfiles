{ config, pkgs, ... }:
let
  nixos-logo-gruvbox-wallpaper = pkgs.fetchFromGitHub {
    owner = "lunik1";
    repo = "nixos-logo-gruvbox-wallpaper";
    rev = "c94a15202a1498e6d828dde570e6f24b6f4f922b";
    sha256 = "12any5ns0cimjdf7f8qi8xsygnrpagkas3zhvwhag8264xg8ljmj";
  };
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # fish shell
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "ddeb28a7b6a1f0ec6dae40c636e5ca4908ad160a";
          sha256 = "0c5i7sdrsp0q3vbziqzdyqn4fmp235ax4mn4zslrswvn8g3fvdyh";
        };
      }
    ];
    functions = {
      nfic = "git clone git@github.com:NFIBrokerage/$argv";
      latestcommitmessage = "git log -1 --format=%s";
      next_tag = ''
      set -l current_tag_match (git tag --sort=version:refname | tail -n 1 | string match -r 'v(\d+)')
      set -l current_version_number (echo $current_tag_match[2])
      set -l next_version_number (echo $current_version_number + 1 | bc)
      git tag -s -a "v$next_version_number" -m $argv
      '';
    };
    shellAliases = {
      c = "cd";
      e = "exa";
      g = "git";
      dc = "docker-compose";
    };
  };

  programs.gh = {
    enable = true;
    editor = "kak";
    gitProtocol = "ssh";
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "michael";
  home.homeDirectory = "/home/michael";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";

  programs.exa.enable = true;
  programs.command-not-found.enable = true;

  home.packages = with pkgs; [
    curl
    neofetch
    docker-compose
    dnsutils
    traceroute
    nmap
    ipcalc
    discord
    slack
    stow
    jetbrains-mono
    xdg-utils
    swaylock
    swayidle
    wl-clipboard
    grim
    wf-recorder
    wdisplays
    wofi
    bc
    chromium
  ];

  programs.kakoune = {
    enable = true;
    config = {
      autoReload = "yes";
      colorScheme = "gruvbox";
      indentWidth = 2;
      numberLines.enable = true;
      wrapLines.enable = true;
      showWhitespace.enable = true;
      hooks = [
        {
          name = "WinCreate";
          option = "[^*]*";
          commands = "
          add-highlighter window/ column 81 default,rgb:404040
          add-highlighter global/ regex \\h+$ 0:Error
          ";
        }
      ];
    };
    extraConfig = "
evaluate-commands %sh{
  plugins=\"$kak_config/plugins\"
  mkdir -p \"$plugins\"
  [ ! -e \"$plugins/plug.kak\" ] && \
    git clone -q https://github.com/andreyorst/plug.kak.git \"$plugins/plug.kak\"
  printf \"%s\\n\" \"source '$plugins/plug.kak/rc/plug.kak'\"
}
plug \"andreyorst/plug.kak\" noload

#require-module kitty

alias global g git

# make x extend the selection down, X extend up
def -params 1 extend-line-down %{
  exec \"<a-:>%arg{1}X\"
}

def -params 1 extend-line-up %{
  exec \"<a-:><a-;>%arg{1}K<a-;>\"
  try %{
    exec -draft ';<a-K>\\n<ret>'
    exec X
  }
  exec '<a-;><a-X>'
}

map global normal x ':extend-line-down %val{count}<ret>'
map global normal X ':extend-line-up %val{count}<ret>'

plug \"occivink/kakoune-sudo-write\"

plug \"delapouite/kakoune-buffers\" %{
    map global normal \\' ': enter-buffers-mode<ret>' -docstring 'buffers'
    map global normal <a-'> ': enter-user-mode -lock buffers<ret>' -docstring 'buffers (lock)'
}

plug \"lePerdu/kakboard\" %{
    hook global WinCreate .* %{ kakboard-enable }
}
    ";
  };

  programs.git = {
    enable = true;
    aliases = {
      git = "!exec git";
      g = "!exec git";
      t = "tag --sort=version:refname";
      sha = "rev-parse HEAD";
      st = "status";
      b = "branch";
      ci = "commit";
      cia = "commit -a";
      co = "checkout";
      unstage = "reset HEAD --";
      ph = "push";
      pl = "pull";
      d = "diff";
      f = "fetch";
      branch-name = "rev-parse --abbrev-ref HEAD";
      pub = "!git push -u origin $(git branch-name)";
      lt = "!git tag --sort=version:refname | tail -n 1";
    };
    extraConfig = {
      core.editor = "kak";
      hub.protocol = "ssh";
      pull.rebase = "false";
      init.defaultBranch = "main";
      push.followTags = "true";
      push.default = "simple";
      tag.gpgSign = "true";
    };
    ignores = [ "*.swp" "*.swo" ".projections.json" "*.elixir_ls/" ];
    userName = "Michael Davis";
    userEmail = "mcarsondavis@gmail.com";
    signing = {
      key = "25D3AFE4BA2A0C49";
      signByDefault = true;
    };
  };

  programs.waybar = {
    enable = true;
  };

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config.bars = [];
    extraConfig = "
# Set mod key (Mod1=<Alt>, Mod4=<Super>)
set $mod Mod4

# set default desktop layout (default is tiling)
# workspace_layout tabbed <stacking|tabbed>

# Configure border style <normal|1pixel|pixel xx|none|pixel>
default_border pixel 1
# for_window [class=\".*\"] border pixel 0
default_floating_border normal

# Hide borders
hide_edge_borders none

# change borders
bindsym $mod+u border none
bindsym $mod+y border pixel 1
bindsym $mod+n border normal

# brightness
bindsym XF86MonBrightnessDown exec \"brightnessctl set 2%-\"
bindsym XF86MonBrightnessUp exec \"brightnessctl set +2%\"

# volume
bindsym XF86AudioRaiseVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ +1%'
bindsym XF86AudioLowerVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ -1%'
bindsym XF86AudioMute exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'

# Font for window titles. Will also be used by the bar unless a different font
# is used in the bar {} block below.
font xft:URWGothic-Book 11

# Use Mouse+$mod to drag floating windows
floating_modifier $mod

# start a terminal
bindsym $mod+Return exec kitty

# kill focused window
bindsym $mod+Control+c kill

# start program launcher
bindsym $mod+d exec wofi --show drun --allow-images

# launch categorized menu
bindsym $mod+z exec --no-startup-id morc_menu

bindsym $mod+b exec \"GDK_BACKEND=wayland firefox\"

################################################################################################
## sound-section - DO NOT EDIT if you wish to automatically upgrade Alsa -> Pulseaudio later! ##
################################################################################################

exec --no-startup-id volumeicon
bindsym $mod+Ctrl+m exec terminal -e 'alsamixer'
#exec --no-startup-id pulseaudio
#exec --no-startup-id pa-applet
#bindsym $mod+Ctrl+m exec pavucontrol

################################################################################################

# Screen brightness controls
# bindsym XF86MonBrightnessUp exec \"xbacklight -inc 10; notify-send 'brightness up'\"
# bindsym XF86MonBrightnessDown exec \"xbacklight -dec 10; notify-send 'brightness down'\"

# Start Applications
bindsym $mod+Ctrl+b exec terminal -e 'bmenu'
bindsym $mod+F2 exec palemoon
bindsym $mod+F3 exec pcmanfm
# bindsym $mod+F3 exec ranger
bindsym $mod+Shift+F3 exec pcmanfm_pkexec
bindsym $mod+F5 exec terminal -e 'mocp'
# bindsym $mod+Ctrl+t exec --no-startup-id picom -b
# bindsym $mod+Ctrl+Shift+t exec --no-startup-id pkill picom
bindsym $mod+Shift+d --release exec \"killall dunst; exec notify-send 'restart dunst'\"
# bindsym Print exec --no-startup-id i3-scrot
# bindsym $mod+Print --release exec --no-startup-id i3-scrot -w
# bindsym $mod+Shift+p --release exec --no-startup-id i3-scrot -s
# bindsym $mod+Shift+p --release exec --no-startup-id \"escrotum -s '~/Pictures/%Y-%m-%d-%H%M%S_$wx$h_scrot.png'\"
# bindsym $mod+Shift+h exec xdg-open /usr/share/doc/manjaro/i3_help.pdf
bindsym $mod+Ctrl+x --release exec --no-startup-id xkill
bindsym $mod+Shift+p --release exec --no-startup-id grim -g \"$(slurp)\" ~/Pictures/$(date +%Y-%m-%d_%H-%M-%S)_grim.png

# focus_follows_mouse no

# change focus
bindsym $mod+j focus down
bindsym $mod+k focus up
bindsym $mod+l focus right
bindsym $mod+h focus left

# alternatively, you can use the cursor keys:
bindsym $mod+Left focus left
bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right

# move focused window
bindsym $mod+Shift+j move down
bindsym $mod+Shift+k move up
bindsym $mod+Shift+l move right
bindsym $mod+Shift+h move left

# focus windows
# see https://bbs.archlinux.org/viewtopic.php?id=135241
# set $mousemove \"/home/michael/.config/fish/w-focus-middle.fish\"
# sway has a built-in for it!
mouse_warping container
# swaymsg -t get_tree can help find the app_ids (wayland) and class-s (x)
bindsym Ctrl+1 [app_id=\"kitty\"] focus
bindsym Ctrl+2 [app_id=\"firefox\"] focus
bindsym Ctrl+3 [class=\"Slack\"] focus
bindsym Ctrl+4 [class=\"discord\"] focus
bindsym Ctrl+5 [app_id=\"Chromium\"] focus

# alternatively, you can use the cursor keys:
# bindsym $mod+Shift+Left move left
# bindsym $mod+Shift+Down move down
# bindsym $mod+Shift+Up move up
# bindsym $mod+Shift+Right move right

# workspace back and forth (with/without active container)
workspace_auto_back_and_forth yes
# bindsym $mod+b workspace back_and_forth
bindsym $mod+Shift+b move container to workspace back_and_forth; workspace back_and_forth

# split orientation
# bindsym $mod+h split h;exec notify-send 'tile horizontally'
# bindsym $mod+v split v;exec notify-send 'tile vertically'
# bindsym $mod+q split toggle


# toggle fullscreen mode for the focused container
bindsym $mod+f fullscreen toggle

# change container layout (stacked, tabbed, toggle split)
bindsym $mod+s layout stacking
bindsym $mod+w layout tabbed
bindsym $mod+e layout toggle split

# toggle tiling / floating
bindsym $mod+Shift+space floating toggle

# change focus between tiling / floating windows
bindsym $mod+space focus mode_toggle

# toggle sticky
bindsym $mod+Shift+s sticky toggle

# focus the parent container
# bindsym $mod+a focus parent

# move the currently focused window to the scratchpad
bindsym $mod+Shift+minus move scratchpad

# Show the next scratchpad window or hide the focused scratchpad window.
# If there are multiple scratchpad windows, this command cycles through them.
bindsym $mod+minus scratchpad show

#navigate workspaces next / previous
bindsym $mod+Ctrl+Right workspace next
bindsym $mod+Ctrl+Left workspace prev

# simulate command for a, c, and v
# cmd+a does ctrl+a
# bindsym $mod+a exec --no-startup-id xdotool key --clearmodifiers ctrl+a
# bindsym $mod+v exec --no-startup-id xdotool key --clearmodifiers ctrl+v
bindsym $mod+c exec --no-startup-id wl-copy

# Workspace names
# to display names or symbols instead of plain workspace numbers you can use
# something like: set $ws1 1:mail
#                 set $ws2 2:
set $ws1 1
set $ws2 2
set $ws3 3
set $ws4 4
set $ws5 5
set $ws6 6
set $ws7 7
set $ws8 8

# switch to workspace
bindsym $mod+1 workspace $ws1
bindsym $mod+2 workspace $ws2
bindsym $mod+3 workspace $ws3
bindsym $mod+4 workspace $ws4
bindsym $mod+5 workspace $ws5
bindsym $mod+6 workspace $ws6
bindsym $mod+7 workspace $ws7
bindsym $mod+8 workspace $ws8

# Move focused container to workspace
bindsym $mod+Ctrl+1 move container to workspace $ws1
bindsym $mod+Ctrl+2 move container to workspace $ws2
bindsym $mod+Ctrl+3 move container to workspace $ws3
bindsym $mod+Ctrl+4 move container to workspace $ws4
bindsym $mod+Ctrl+5 move container to workspace $ws5
bindsym $mod+Ctrl+6 move container to workspace $ws6
bindsym $mod+Ctrl+7 move container to workspace $ws7
bindsym $mod+Ctrl+8 move container to workspace $ws8

# Move to workspace with focused container
bindsym $mod+Shift+1 move container to workspace $ws1; workspace $ws1
bindsym $mod+Shift+2 move container to workspace $ws2; workspace $ws2
bindsym $mod+Shift+3 move container to workspace $ws3; workspace $ws3
bindsym $mod+Shift+4 move container to workspace $ws4; workspace $ws4
bindsym $mod+Shift+5 move container to workspace $ws5; workspace $ws5
bindsym $mod+Shift+6 move container to workspace $ws6; workspace $ws6
bindsym $mod+Shift+7 move container to workspace $ws7; workspace $ws7
bindsym $mod+Shift+8 move container to workspace $ws8; workspace $ws8

# Open applications on specific workspaces
# assign [class=\"Thunderbird\"] $ws1
# assign [class=\"Pale moon\"] $ws2
# assign [class=\"Pcmanfm\"] $ws3
# assign [class=\"Skype\"] $ws5

# Open specific applications in floating mode
for_window [title=\"alsamixer\"] floating enable border pixel 1
for_window [class=\"calamares\"] floating enable border normal
for_window [class=\"Clipgrab\"] floating enable
for_window [title=\"File Transfer*\"] floating enable
for_window [class=\"fpakman\"] floating enable
for_window [class=\"Galculator\"] floating enable border pixel 1
for_window [class=\"GParted\"] floating enable border normal
for_window [title=\"i3_help\"] floating enable sticky enable border normal
for_window [class=\"Lightdm-settings\"] floating enable
for_window [class=\"Lxappearance\"] floating enable sticky enable border normal
for_window [class=\"Manjaro-hello\"] floating enable
for_window [class=\"Manjaro Settings Manager\"] floating enable border normal
for_window [title=\"MuseScore: Play Panel\"] floating enable
for_window [class=\"Nitrogen\"] floating enable sticky enable border normal
for_window [class=\"Oblogout\"] fullscreen enable
for_window [class=\"octopi\"] floating enable
for_window [title=\"About Pale Moon\"] floating enable
for_window [class=\"Pamac-manager\"] floating enable
for_window [class=\"Pavucontrol\"] floating enable
for_window [class=\"qt5ct\"] floating enable sticky enable border normal
for_window [class=\"Qtconfig-qt4\"] floating enable sticky enable border normal
for_window [class=\"Simple-scan\"] floating enable border normal
for_window [class=\"(?i)System-config-printer.py\"] floating enable border normal
for_window [class=\"Skype\"] floating enable border normal
for_window [class=\"Timeset-gui\"] floating enable border normal
for_window [class=\"(?i)virtualbox\"] floating enable border normal
for_window [class=\"Xfburn\"] floating enable

# switch to workspace with urgent window automatically
for_window [urgent=latest] focus

# reload the configuration file
bindsym $mod+Shift+r reload

# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
# bindsym $mod+Shift+r restart

# exit i3 (logs you out of your X session)
bindsym $mod+Shift+e exec \"i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'\"

# Set shut down, restart and locking features
bindsym $mod+0 mode \"$mode_system\"
set $mode_system (l)ock, (e)xit, switch_(u)ser, (s)uspend, (h)ibernate, (r)eboot, (Shift+s)hutdown
mode \"$mode_system\" {
  bindsym l exec --no-startup-id i3exit lock, mode \"default\"
    bindsym s exec --no-startup-id i3exit suspend, mode \"default\"
    bindsym u exec --no-startup-id i3exit switch_user, mode \"default\"
    bindsym e exec --no-startup-id i3exit logout, mode \"default\"
    bindsym h exec --no-startup-id i3exit hibernate, mode \"default\"
    bindsym r exec --no-startup-id i3exit reboot, mode \"default\"
    bindsym Shift+s exec --no-startup-id i3exit shutdown, mode \"default\"

# exit system mode: \"Enter\" or \"Escape\"
    bindsym Return mode \"default\"
    bindsym Escape mode \"default\"
}

# Lock screen
# bindsym $mod+9 exec --no-startup-id blurlock

# Autostart applications
exec --no-startup-id /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
# exec --no-startup-id nitrogen --restore; sleep 1; picom -b
exec --no-startup-id nm-applet
exec --no-startup-id xfce4-power-manager
exec --no-startup-id pamac-tray
exec --no-startup-id clipit
# exec --no-startup-id blueman-applet
# exec_always --no-startup-id sbxkb
# exec --no-startup-id start_conky_maia
# exec --no-startup-id start_conky_green

# exec --no-startup-id xautolock -time 10 -locker swaylock
# exec --no-startup-id xautolock -time 10 -notify 5 -notifier '/usr/lib/xsecurelock/until_nonidle /usr/lib/xsecurelock/dimmer' -locker xsecurelock
exec swayidle -w \\
  timeout 300 'swaylock -f -c 000000' \\
  timeout 600 'swaymsg \"output * dpms off\"' \\
       resume 'swaymsg \"output * dpms on\"' \\
  before-sleep 'swaylock -f -c 000000'

exec --no-startup-id ydotoold

exec_always --no-startup-id ff-theme-util
exec_always --no-startup-id fix_xcursor
# exec_always --no-startup-id $HOME/.config/polybar/launch.sh
exec_always --no-startup-id ntfd

# Color palette used for the terminal ( ~/.Xresources file )
# Colors are gathered based on the documentation:
# https://i3wm.org/docs/userguide.html#xresources
# Change the variable name at the place you want to match the color
# of your terminal like this:
# [example]
# If you want your bar to have the same background color as your
# terminal background change the line 362 from:
# background #14191D
# to:
# background $term_background
# Same logic applied to everything else.
# set_from_resource $term_background background
# set_from_resource $term_foreground foreground
# set_from_resource $term_color0     color0
# set_from_resource $term_color1     color1
# set_from_resource $term_color2     color2
# set_from_resource $term_color3     color3
# set_from_resource $term_color4     color4
# set_from_resource $term_color5     color5
# set_from_resource $term_color6     color6
# set_from_resource $term_color7     color7
# set_from_resource $term_color8     color8
# set_from_resource $term_color9     color9
# set_from_resource $term_color10    color10
# set_from_resource $term_color11    color11
# set_from_resource $term_color12    color12
# set_from_resource $term_color13    color13
# set_from_resource $term_color14    color14
# set_from_resource $term_color15    color15

set $bar_hl_color #C6643D

# Start i3bar to display a workspace bar (plus the system information i3status if available)
#bar {
#  i3bar_command i3bar
#    status_command i3status
#    position bottom

### please set your primary output first. Example: 'xrandr --output eDP1 --primary'
##	tray_output primary
##	tray_output eDP1

#    bindsym button4 nop
#    bindsym button5 nop
##   font xft:URWGothic-Book 11
#    strip_workspace_numbers yes

#    colors {
#      background $term_background
#        statusline #F9FAF9
#        separator  #454947

#    #                      border  backgr.        text
#        focused_workspace  #F9FAF9 $bar_hl_color  #292F34
#        active_workspace   #595B5B #353836        #FDF6E3
#        inactive_workspace #595B5B #222D31        #EEE8D5
#        binding_mode       #16a085 #2C2C2C        #F9FAF9
#        urgent_workspace   #16a085 #FDF6E3        #E5201D
#    }
#}

bar {
  swaybar_command ${pkgs.waybar}/bin/waybar
}

# hide/unhide i3status bar
# bindsym $mod+m bar mode toggle

# Theme colors
# class                 border  backgr. text          indic.   child_border
client.focused          #556064 #556064 #80FFF9       #FDF6E3
client.focused_inactive #2F3D44 #2F3D44 $bar_hl_color #454948
client.unfocused        #2F3D44 #2F3D44 $bar_hl_color #454948
client.urgent           #CB4B16 #FDF6E3 $bar_hl_color #268BD2
client.placeholder      #000000 #0c0c0c #ffffff       #000000

client.background       #2B2C2B

#############################
### settings for i3-gaps: ###
#############################

# Set inner/outer gaps
gaps inner 50
gaps outer 30

# Additionally, you can issue commands with the following syntax. This is useful to bind keys to changing the gap size.
# gaps inner|outer current|all set|plus|minus <px>
# gaps inner all set 10
# gaps outer all plus 5

# Smart gaps (gaps used if only more than one container on the workspace)
smart_gaps on

# Smart borders (draw borders around container only if it is not the only container on this workspace)
# on|no_gaps (on=always activate and no_gaps=only activate if the gap size to the edge of the screen is 0)
smart_borders on

# Press $mod+Shift+g to enter the gap mode. Choose o or i for modifying outer/inner gaps. Press one of + / - (in-/decrement for current workspace) or 0 (remove gaps for current workspace). If you also press Shift with these keys, the change will be global for all workspaces.
set $mode_gaps Gaps: (o) outer, (i) inner
set $mode_gaps_outer Outer Gaps: +|-|0 (local), Shift + +|-|0 (global)
set $mode_gaps_inner Inner Gaps: +|-|0 (local), Shift + +|-|0 (global)
bindsym $mod+Shift+g mode \"$mode_gaps\"

mode \"$mode_gaps\" {
  bindsym o      mode \"$mode_gaps_outer\"
    bindsym i      mode \"$mode_gaps_inner\"
    bindsym Return mode \"default\"
    bindsym Escape mode \"default\"
}
mode \"$mode_gaps_inner\" {
  bindsym plus  gaps inner current plus 5
    bindsym minus gaps inner current minus 5
    bindsym 0     gaps inner current set 0

    bindsym Shift+plus  gaps inner all plus 5
    bindsym Shift+minus gaps inner all minus 5
    bindsym Shift+0     gaps inner all set 0

    bindsym Return mode \"default\"
    bindsym Escape mode \"default\"
}
mode \"$mode_gaps_outer\" {
  bindsym plus  gaps outer current plus 5
    bindsym minus gaps outer current minus 5
    bindsym 0     gaps outer current set 0

    bindsym Shift+plus  gaps outer all plus 5
    bindsym Shift+minus gaps outer all minus 5
    bindsym Shift+0     gaps outer all set 0

    bindsym Return mode \"default\"
    bindsym Escape mode \"default\"
}

input type:touchpad {
  tap enabled
  natural_scroll enabled
  # pointer_accel 0.5
}

input \"1267:12454:ELAN0406:00_04F3:30A6_Touchpad\" {
  tap disabled
}

input \"type:keyboard\" {
  xkb_options compose:lalt,caps:none
  xkb_layout \"us\"
  #xkb_variant \"dvp\"
  repeat_delay 200
}

input \"5426:623:Razer_Razer_Blade_Keyboard\" {
  xkb_options compose:lalt,caps:escape
  xkb_layout \"us\"
  xkb_variant \"dvp\"
}

output eDP-1 {
  pos 0 0
}

output DP-2 {
  pos 0 0
  bg ${nixos-logo-gruvbox-wallpaper}/png/gruvbox-dark-rainbow.png fill
}

output HDMI-A-2 {
  pos 3840 -875
  transform 90
  bg ${nixos-logo-gruvbox-wallpaper}/png/gruvbox-dark-rainbow.png fill
}
    ";
  };

  programs.kitty = {
    enable = true;
    extraConfig = "
map shift+left previous_tab
map shift+right next_tab
    ";
    font = {
      name = "JetBrains Mono Light";
      # size = 10;
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
      color15 = "#928374";
    };
  };

  programs.firefox = {
    enable = true;
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
        };
        # NOTE this is the blurredfox theme of
        # https://github.com/manilarome/blurredfox
        # LICENSE is as follows:
        #
        # MIT License
        #
        # Copyright (c) 2020 Gerome Matilla
        #
        # Permission is hereby granted, free of charge, to any person obtaining a copy
        # of this software and associated documentation files (the "Software"), to deal
        # in the Software without restriction, including without limitation the rights
        # to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        # copies of the Software, and to permit persons to whom the Software is
        # furnished to do so, subject to the following conditions:
        #
        # The above copyright notice and this permission notice shall be included in all
        # copies or substantial portions of the Software.
        #
        # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        # IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        # FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        # AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        # LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        # OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
        # SOFTWARE.

        userChrome = ''
        /* colors/blurred.css */
        :root {
          /* All the CSS variables here are global */
          /* These applies to all colorschemes */

          /* If windows - `-moz-win-glass`, if macOS - `-moz-mac-vibrancy-dark` */
          --bf-moz-appearance: -moz-win-glass !important;

          --bf-backdrop-blur: 6px;

          --bf-sidebar-searchbar-radius: 6px;

          --bf-accent-bg: #4C5FF9CC;
          --bf-blank-page-bg: #252525;

          --bf-urlbar-hightlight-bg: var(--bf-accent-bg);
          --bf-urlbar-radius: 9px;
          --bf-urlbar-results-font-size: 12pt;
          --bf-urlbar-results-font-weight: 550;
          --bf-urlbar-font-size: 12pt;
          --bf-urlbar-font-weight: 500;
          --bf-urlbar-switch-tab-color: #6498EF;
          --bf-urlbar-bookmark-color: #53E2AE;

          --bf-navbar-padding: 6px;

          --bf-tab-selected-bg: #77777788;
          --bf-tab-font-size: 11pt;
          --bf-tab-font-weight: 400;
          --bf-tab-height: 36px;
          --bf-tab-border-radius: 6px;
          --bf-tab-soundplaying-bg: #985EFFCC;

          --toolbar-bgcolor: transparent !important;
          --urlbar-separator-color: transparent !important;
        }

        /* Light Mode */
        :root:-moz-lwtheme-darktext {
          --bf-main-window: transparent;
          --bf-bg: #F2F2F266;
          --bf-color: #0A0A0A;

          --bf-hover-bg: #1A1A1A33;
          --bf-active-bg: #1A1A1A66;

          --bf-icon-color: #0A0A0A;
          --bf-tab-toolbar-bg: #F2F2F2AA;
          --bf-tab-selected-bg: #00000022;
          --bf-navbar-bg: var(--bf-bg);
          --bf-urlbar-bg: var(--bf-bg);
          --bf-urlbar-active-bg: var(--bf-bg);
          --bf-urlbar-focused-color: var(--bf-color);

          --bf-sidebar-bg: var(--bf-bg);
          --bf-sidebar-color: var(--bf-color);

          --bf-menupopup-bg: #F2F2F2AA;
          --bf-menupopup-color: var(--bf-color);
        }

        /* Dark Mode */
        :root:-moz-lwtheme-brighttext {
          --bf-main-window: transparent;
          --bf-bg: #00000066;
          --bf-color: #F2F2F2;

          --bf-hover-bg: #F2F2F233;
          --bf-active-bg: #F2F2F266;

          --bf-icon-color: #F2F2F2;
          --bf-tab-toolbar-bg: #000000AA;
          --bf-tab-selected-bg: #F2F2F210;
          --bf-navbar-bg: var(--bf-bg);
          --bf-urlbar-bg: var(--bf-bg);
          --bf-urlbar-active-bg: var(--bf-bg);
          --bf-urlbar-focused-color: var(--bf-color);

          --bf-sidebar-bg: var(--bf-bg);
          --bf-sidebar-color: var(--bf-color);

          --bf-menupopup-bg: #000000AA;
          --bf-menupopup-color: var(--bf-color);
        }

        /* parts/arrow-panel.css */
        /*
        ░█▀█░█▀▄░█▀▄░█▀█░█░█░█▀█░█▀█░█▀█░█▀▀░█░░
        ░█▀█░█▀▄░█▀▄░█░█░█▄█░█▀▀░█▀█░█░█░█▀▀░█░░
        ░▀░▀░▀░▀░▀░▀░▀▀▀░▀░▀░▀░░░▀░▀░▀░▀░▀▀▀░▀▀▀

        The dropdown menus
        */

        .panel-arrowcontent {
          padding: 0 !important;
          margin: 0 !important;
        }

        toolbarseparator {
          display: none !important;
        }

        box.panel-arrowbox {
          display: none;
        }

        box.panel-arrowcontent {
          border-radius: 8px !important;
          border: none !important;
        }

        /* parts/context-menu.css */
        /*
        ░█▀▀░█▀█░█▀█░▀█▀░█▀▀░█░█░▀█▀░█▄█░█▀▀░█▀█░█░█
        ░█░░░█░█░█░█░░█░░█▀▀░▄▀▄░░█░░█░█░█▀▀░█░█░█░█
        ░▀▀▀░▀▀▀░▀░▀░░▀░░▀▀▀░▀░▀░░▀░░▀░▀░▀▀▀░▀░▀░▀▀▀

        Right-click menu
        */

        menupopup,
        popup,
        popup > menu > menupopup,
        menupopup > menu > menupopup {
          border: 0 !important;
          border-radius: 4px !important;
          padding: 2px 0 2px 0  !important;
        }

        menupopup:-moz-lwtheme-darktext,
        menupopup:-moz-lwtheme-brighttext,
        popup:-moz-lwtheme-darktext,
        popup:-moz-lwtheme-brighttext,
        popup > menu > menupopup:-moz-lwtheme-darktext,
        popup > menu > menupopup:-moz-lwtheme-brighttext,
        menupopup > menu > menupopup:-moz-lwtheme-darktext,
        menupopup > menu > menupopup:-moz-lwtheme-brighttext {
          -moz-appearance: none !important;
          background: var(--bf-menupopup-bg) !important;
          color: var(--bf-menupopup-color) !important;
        }

        menupopup menuseparator {
        /*   -moz-appearance: none !important; */
          margin: 2px 0 2px 0 !important;
          padding: 0 !important;
          border-top: none !important;
          border-color: transparent !important;
        }

        menupopup menuseparator:-moz-lwtheme-darktext,
        menupopup menuseparator:-moz-lwtheme-brighttext {
          -moz-appearance: none !important;
          background: #525A6D  !important;
        }

        /* parts/customization-window.css */
        /*
        ░█▀▀░█░█░█▀▀░▀█▀░█▀█░█▄█░▀█▀░▀▀█░█▀█░▀█▀░▀█▀░█▀█░█▀█░█░█░▀█▀░█▀█░█▀▄░█▀█░█░█
        ░█░░░█░█░▀▀█░░█░░█░█░█░█░░█░░▄▀░░█▀█░░█░░░█░░█░█░█░█░█▄█░░█░░█░█░█░█░█░█░█▄█
        ░▀▀▀░▀▀▀░▀▀▀░░▀░░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀░▀░░▀░░▀▀▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░▀░▀▀░░▀▀▀░▀░▀

        The customization window
        */

        #customization-container {
        }

        #customization-container:-moz-lwtheme-darktext,
        #customization-container:-moz-lwtheme-brighttext {
          background: var(--bf-bg) !important;
        }

        .customizationmode-button {
          padding: 5px !important;
          border-radius: 6px !important;
        }

        .customizationmode-button:-moz-lwtheme-darktext,
        .customizationmode-button:-moz-lwtheme-brighttext {
          color: var(--bf-color) !important;;
        }

        .customizationmode-button:hover {
          padding: 5px !important;
          border-radius: 6px !important;
        }

        .customizationmode-button label {
        }

        /* parts/findbar.css */
        /*
        ░█▀▀░▀█▀░█▀█░█▀▄░█▀▄░█▀█░█▀▄
        ░█▀▀░░█░░█░█░█░█░█▀▄░█▀█░█▀▄
        ░▀░░░▀▀▀░▀░▀░▀▀░░▀▀░░▀░▀░▀░▀

        The findbar
        */

        #browser #appcontent #tabbrowser-tabbox findbar,
        #browser #appcontent #tabbrowser-tabbox tabpanels {
          -moz-appearance: none !important;
          border: none !important;
        }

        #browser #appcontent #tabbrowser-tabbox findbar:-moz-lwtheme-darktext,
        #browser #appcontent #tabbrowser-tabbox findbar:-moz-lwtheme-brighttext,
        #browser #appcontent #tabbrowser-tabbox tabpanels:-moz-lwtheme-darktext,
        #browser #appcontent #tabbrowser-tabbox tabpanels:-moz-lwtheme-brighttext {
          background: transparent !important;
        }

        #browser #appcontent #tabbrowser-tabbox findbar {
        }

        #browser #appcontent #tabbrowser-tabbox findbar:-moz-lwtheme-darktext,
        #browser #appcontent #tabbrowser-tabbox findbar:-moz-lwtheme-brighttext {
          background-color: var(--bf-bg) !important;
        }

        .findbar-find-previous,
        .findbar-find-next {
          margin: 0 !important;
          border: none !important;
        }

        #browser #appcontent #tabbrowser-tabbox .findbar-find-fast {
        }

        #browser #appcontent #tabbrowser-tabbox .findbar-find-fast:not([status="notfound"]):-moz-lwtheme-darktext,
        #browser #appcontent #tabbrowser-tabbox .findbar-find-fast:not([status="notfound"]):-moz-lwtheme-brighttext {
          background-color: var(--bf-bg) !important;
        }

        /* parts/main-window.css */
        /*
        ░▀█▀░█▀▄░█▀█░█▀█░█▀▀░█▀█░█▀█░█▀▄░█▀▀░█▀█░█▀▀░█░█
        ░░█░░█▀▄░█▀█░█░█░▀▀█░█▀▀░█▀█░█▀▄░█▀▀░█░█░█░░░░█░
        ░░▀░░▀░▀░▀░▀░▀░▀░▀▀▀░▀░░░▀░▀░▀░▀░▀▀▀░▀░▀░▀▀▀░░▀░

        Main window
        */
        #main-window {
          font-kerning: normal;
          border: none !important;
        }

        /* Add transparency to light and dark color schemes */
        #main-window:-moz-lwtheme-brighttext,
        #main-window:-moz-lwtheme-darktext {
          background: var(--bf-main-window) !important;
          -moz-appearance: var(--bf-moz-appearance) !important;
        }

        /*
        ░█▀▀░█▀█░█▀█░▀█▀
        ░█▀▀░█░█░█░█░░█░
        ░▀░░░▀▀▀░▀░▀░░▀░

        I'm not sure if this does something
        */

        * {
          -webkit-font-smoothing: antialiased;
          -moz-osx-font-smoothing: grayscale;
          text-rendering: optimizeLegibility;
          font-variant-ligatures: none;
          font-kerning: normal;
        }


        /* parts/sidebar.css */
        /*
        ░█▀▀░▀█▀░█▀▄░█▀▀░█▀▄░█▀█░█▀▄
        ░▀▀█░░█░░█░█░█▀▀░█▀▄░█▀█░█▀▄
        ░▀▀▀░▀▀▀░▀▀░░▀▀▀░▀▀░░▀░▀░▀░▀

        Sidebar
        */

        #sidebar-box {
        }

        #sidebar-box:-moz-lwtheme-darktext,
        #sidebar-box:-moz-lwtheme-brighttext {
          --sidebar-background-color: var(--bf-sidebar-bg) !important;
          --sidebar-text-color: var(--bf-sidebar-color) !important;
        }

        #sidebar,
        .sidebar-panel {
          background: transparent !important;
        }

        /* Sidebar searchbar */
        #sidebar-search-container #search-box {
          border: none !important;
          padding: 6px !important;
          border-radius: var(--bf-sidebar-searchbar-radius) !important;
        }


        /* parts/tabbar.css */
        /*
        ░▀█▀░█▀█░█▀▄░█▀▄░█▀█░█▀▄
        ░░█░░█▀█░█▀▄░█▀▄░█▀█░█▀▄
        ░░▀░░▀░▀░▀▀░░▀▀░░▀░▀░▀░▀

        The tabs container
        */

        /* Move tab bar beneath the url bar */
        #titlebar {
          /*
          Set the value to 3 to move the tabbar below the navbar
          */
          -moz-box-ordinal-group: 1 !important;
        }

        #titlebar::after {
          border-bottom: 0 !important;
        }

        .toolbar-items {
        }

        /* Transparent tabs */
        .toolbar-items:-moz-lwtheme-darktext,
        .toolbar-items:-moz-lwtheme-brighttext {
          background-color: transparent !important;
          -moz-appearance: var(--bf-moz-appearance) !important;
        }

        /*   Set minimum height for tab bar */
        #tabbrowser-tabs {
          /* --tab-min-height: 0; */
          margin: 6px 5px 6px 5px;
        }

        /* Compact mode */
        :root[uidensity="compact"] #tabbrowser-tabs {
          margin: 0 !important;
        }

        /* Hide solo tab */
        /*
        #tabbrowser-tabs tab[first-visible-tab="true"][last-visible-tab="true"]:only-of-type {
          visibility: collapse;
        }
        */

        /* Hide New Tab Button immediately next to solo tab */
        /*
        #tabbrowser-tabs tab[first-visible-tab="true"][last-visible-tab="true"]:only-of-type + toolbarbutton {
          visibility: collapse;
        }
        */

          /* Stretch Tabs */
        .tabbrowser-tab[fadein]:not([pinned]) {
          max-width: none !important;
        }

        .tab-background {
          border: none !important;
        }

        .tab-background:-moz-lwtheme-darktext,
        .tab-background:-moz-lwtheme-brighttext {
          background: transparent !important;
          -moz-appearance: var(--bf-moz-appearance) !important;
        }

        .tab-background[selected="true"] {
          background: var(--bf-tab-selected-bg) !important;
        }

        .tab-background:not[visuallyselected] {
          background: var(--bf-tab-selected-bg) !important;
          opacity: 0.5 !important;
        }

        /* Remove the all the "lines" in tab sides */
        /*
        .tabbrowser-tab::after,
        .tabbrowser-tab::before {
          border-left: none !important;
        }
        */

        /* Remove the lines on the side of the selected tab */
        .tabbrowser-tab[beforeselected-visible="true"]::after,
        .tabbrowser-tab[beforeselected-visible="true"]::before,
        .tabbrowser-tab[selected="true"]::after,
        .tabbrowser-tab[selected="true"]::before {
          border-left: none !important;
        }

        /* Style all the lines before and after selected tab */
        .tabbrowser-tab::after,
        .tabbrowser-tab::before {
          border-width: 1px !important;
        }

        .tabbrowser-arrowscrollbox {
          margin-inline-start: 4px !important;
          margin-inline-end: 0 !important;
        }

        .tab-text {
          font-weight: var(--bf-tab-font-weight);
          font-size: var(--bf-tab-font-size) !important;
        }

        /* Center all content */
        .tab-content {
          justify-content: center;
          align-items: center;
          margin-top: -1px;
          min-width: 100% !important;
          padding: 0 10px !important;
        }

        /* A way to center the label and icon while
        the close button is positioned to the far right */
        .tab-content::before{
          content: "";
          display: -moz-box;
          -moz-box-flex: 1
        }

        /* Tab close button */
        .tab-close-button {
          opacity: 1 !important;
        }

        /* Prevent tab icons size breaking */
        .tab-icon-image, .tab-icon-sound,
        .tab-throbber, .tab-throbber-fallback,
        .tab-close-button {
          min-width: 16px;
        }

        /* Adjust tab label width */
        .tab-label-container {
          min-width: 3px !important;
        }

        /* If tab close button is not present, don't force favicon to the center */
        #tabbrowser-tabs[closebuttons="activetab"] .tabbrowser-tab:not([selected="true"]) .tab-throbber,
        #tabbrowser-tabs[closebuttons="activetab"] .tabbrowser-tab:not([selected="true"]) .tab-throbber-fallback,
        #tabbrowser-tabs[closebuttons="activetab"] .tabbrowser-tab:not([selected="true"]):not([busy]) .tab-icon-image,
        #tabbrowser-tabs[closebuttons="activetab"] .tabbrowser-tab:not([selected="true"]):not([image]) .tab-label-container {
          margin-left: 0 !important;
        }

        /* Tab icon */
        hbox.tab-content .tab-icon-image {
          display: initial !important;
        }

        /* Show the icon of pinned tabs */
        hbox.tab-content[pinned=true] .tab-icon-image {
          display: initial !important;
        }

        /* Hide text of pinned tabs */
        hbox.tab-content[pinned=true] .tab-text {
          display: none !important;
        }

        /*   Hide the blue line on top of tab */
        .tab-line {
          display: none !important;
        }

        .tab-bottom-line {
        }

        .tabbrowser-tab {
          border-radius: var(--bf-tab-border-radius) !important;
          border-width: 0;
          height: var(--bf-tab-height) !important;
          overflow: hidden;
          margin-top: 0 !important;
          margin-bottom: 0 !important;
        }

        :root[uidensity="compact"] .tabbrowser-tab {
          border-radius: 0 !important;
        }

        .tabbrowser-tab:hover {
          box-shadow: 0 1px 4px rgba(0,0,0,.05);
        }

        /* Set color scheme */
        .tabbrowser-tab:hover:-moz-lwtheme-darktext,
        .tabbrowser-tab:hover:-moz-lwtheme-brighttext {
          background: var(--bf-hover-bg) !important;
        }

        /*   Audio playing background */
        .tabbrowser-tab[soundplaying="true"] {
          background-color: var(--bf-tab-soundplaying-bg) !important;
        }

        #tabbrowser-tabs {
        }

        /*   Audio Icon */
        .tab-icon-sound {
        }

        /* Center pinned tab stack(Contains icon) if #tabbrowser-tabs[positionpinnedtabs=true] */
        #tabbrowser-tabs[positionpinnedtabs=true] .tabbrowser-tab[pinned=true] .tab-stack {
          position: relative !important;
          top: 50% !important;
          transform: translateY(-50%) !important;
        }


        .private-browsing-indicator {
          display: block;
          background: transparent;
        }

        /* Remove hover effects on tab bar buttons */
        #TabsToolbar {
          --toolbarbutton-active-background: transparent !important;
          --toolbarbutton-hover-background: transparent !important;
          -moz-appearance: none !important;
        }

        /* Left to Right Alignment of tabs toolbar */
        /* #TabsToolbar {
          direction: rtl;
        }

        #tabbrowser-tabs {
          direction: ltr;
        }
        */

        /* parts/toolbar.css */
        /*
        ░▀█▀░█▀█░█▀█░█░░░█▀▄░█▀█░█▀▄
        ░░█░░█░█░█░█░█░░░█▀▄░█▀█░█▀▄
        ░░▀░░▀▀▀░▀▀▀░▀▀▀░▀▀░░▀░▀░▀░▀

        Contains navbar, urlbar, and etc.
        */

        .browser-toolbar {
        }

        .browser-toolbar:-moz-lwtheme-darktext,
        .browser-toolbar:-moz-lwtheme-brighttext {
          background: var(--bf-tab-toolbar-bg) !important;
        }

        toolbar {
          background-image: none !important;
        }

        toolbar#nav-bar {
          padding: var(--bf-navbar-padding) !important;

          /* Remove horizontal line on navbar */
          box-shadow: none !important;
          border-top: none !important;
        }

        /* Set color schemes for #nav-bar */
        toolbar#nav-bar:-moz-lwtheme-darktext,
        toolbar#nav-bar:-moz-lwtheme-brighttext {
          background: var(--bf-navbar-bg) !important;
        }

        toolbarbutton {
          box-shadow: none !important;
          margin-left: 2px !important;
        }

        .toolbarbutton-1 {
        }

        /* Set color schemes for #nav-bar */
        .toolbarbutton-1:-moz-lwtheme-darktext,
        .toolbarbutton-1:-moz-lwtheme-brighttext {
          --toolbarbutton-hover-background: var(--bf-hover-bg) !important;
          --toolbarbutton-active-background: var(--bf-active-bg) !important;
        }

        #searchbar {
          border: none !important;
        }

        /* Set color scheme */
        #searchbar:-moz-lwtheme-darktext,
        #searchbar:-moz-lwtheme-brighttext {
          background: var(--bf-bg) !important;
        }

        .searchbar-textbox {
          font-weight: 700 !important;
        }

        #navigator-toolbox,
        toolbaritem {
          border: none !important;
        }

        #navigator-toolbox::after {
          border-bottom: 0 !important;
        }

        .toolbarbutton-text {
        }

        /* Set color scheme */
        .toolbarbutton-text:-moz-lwtheme-darktext,
        .toolbarbutton-text:-moz-lwtheme-brighttext {
          color: var(--bf-icon-color)  !important;
        }

        /* Back button */
        #back-button > .toolbarbutton-icon {
          --backbutton-background: transparent !important;
          border: none !important;
          -moz-appearance: var(--bf-moz-appearance) !important;
        }

        /* parts/urlbar.css */
        /*
        ░█░█░█▀▄░█░░░█▀▄░█▀█░█▀▄
        ░█░█░█▀▄░█░░░█▀▄░█▀█░█▀▄
        ░▀▀▀░▀░▀░▀▀▀░▀▀░░▀░▀░▀░▀

        URL bar
        */

        /* URL bar max-width and centered hack */
        #urlbar {
          max-width: 70% !important;
          margin: 0 15% !important;

          /* URL bar and toolbar height */
          --urlbar-height: 36px !important;
          --urlbar-toolbar-height: 40px !important;
        }

        /* URL bar and toolbar height if compact mode */
        :root[uidensity="compact"] #urlbar {
          --urlbar-height: 30px !important;
          --urlbar-toolbar-height: 34px !important;
        }

        #urlbar-input:focus {
        }

        /* Set color scheme */
        #urlbar-input:focus:-moz-lwtheme-darktext,
        #urlbar-input:focus:-moz-lwtheme-brighttext {
          color: var(--bf-urlbar-focused-color) !important;
        }

        #urlbar-background {
          border-radius: var(--bf-urlbar-radius) !important;
          border: none !important
        }

        /* Set color scheme */
        #urlbar-background:-moz-lwtheme-darktext,
        #urlbar-background:-moz-lwtheme-brighttext {
          background: var(--bf-urlbar-bg) !important;
        }

        .urlbar-icon:not([disabled]):hover,
        .urlbar-icon-wrapper:not([disabled]):hover {
        }

        /* Set color scheme */
        .urlbar-icon:not([disabled]):hover:-moz-lwtheme-darktext,
        .urlbar-icon:not([disabled]):hover:-moz-lwtheme-brighttext,
        .urlbar-icon-wrapper:not([disabled]):hover:-moz-lwtheme-darktext,
        .urlbar-icon-wrapper:not([disabled]):hover:-moz-lwtheme-brighttext {
          background: var(--bf-hover-bg) !important;
        }

        .urlbar-icon[open],
        .urlbar-icon-wrapper[open],
        .urlbar-icon:not([disabled]):hover:active,
        .urlbar-icon-wrapper:hover:active {
        }

        /* Set color scheme */
        .urlbar-icon[open]:-moz-lwtheme-darktext,
        .urlbar-icon[open]:-moz-lwtheme-brighttext,
        .urlbar-icon-wrapper[open]:-moz-lwtheme-darktext,
        .urlbar-icon-wrapper[open]:-moz-lwtheme-brighttext,
        .urlbar-icon:not([disabled]):hover:active:-moz-lwtheme-darktext,
        .urlbar-icon:not([disabled]):hover:active:-moz-lwtheme-brighttext,
        .urlbar-icon-wrapper:hover:active:-moz-lwtheme-darktext,
        .urlbar-icon-wrapper:hover:active:-moz-lwtheme-brighttext {
          background: var(--bf-hover-bg) !important;
        }

        .urlbar-icon-wrapper[open] > .urlbar-icon,
        .urlbar-icon-wrapper > .urlbar-icon:hover,
        .urlbar-icon-wrapper > .urlbar-icon:hover:active {
        }

        /* Set color scheme */
        .urlbar-icon-wrapper[open] > .urlbar-icon:-moz-lwtheme-darktext,
        .urlbar-icon-wrapper[open] > .urlbar-icon:-moz-lwtheme-brighttext,
        .urlbar-icon-wrapper > .urlbar-icon:hover:-moz-lwtheme-darktext,
        .urlbar-icon-wrapper > .urlbar-icon:hover:-moz-lwtheme-brighttext,
        .urlbar-icon-wrapper > .urlbar-icon:hover:active:-moz-lwtheme-darktext,
        .urlbar-icon-wrapper > .urlbar-icon:hover:active:-moz-lwtheme-brighttext{
          background: var(--bf-hover-bg) !important;
        }

        #urlbar[breakout-extend="true"]:not([open="true"]) > #urlbar-background {
          box-shadow: none !important;
          display: none !important;
          -moz-appearance: var(--bf-moz-appearance) !important;
        }

        #urlbar[open="true"] > #urlbar-background {
        }

        /* Set color scheme */
        #urlbar[open="true"] > #urlbar-background:-moz-lwtheme-darktext,
        #urlbar[open="true"] > #urlbar-background:-moz-lwtheme-brighttext {
          background: var(--bf-urlbar-active-bg) !important;
          backdrop-filter: blur(var(--bf-backdrop-blur)) !important;
        }

        .urlbar-icon {
        }

        /* Set color scheme */
        .urlbar-icon:-moz-lwtheme-darktext,
        .urlbar-icon:-moz-lwtheme-brighttext {
          color: var(--bf-icon-color) !important;
        }

        .urlbar-icon > image {
          fill: #ff00ff !important;
          color: #ff00ff !important;
        }

        .urlbarView-favicon,
        .urlbarView-type-icon {
          display: none !important;
        }

        .urlbarView-row[type="bookmark"] > span {
          color: var(--bf-urlbar-bookmark-color) !important;
        }

        .urlbarView-row[type="switchtab"] > span .urlbarView-url {
          color: var(--bf-urlbar-switch-tab-color) !important;
        }

        #urlbar-results {
          font-weight: var(--bf-urlbar-results-font-weight);
          font-size: var(--bf-urlbar-results-font-size) !important;
        }

        /* Hover background color */
        .urlbarView-row-inner:hover {
          background: var(--bf-accent-bg) !important;
        }

        .urlbarView-url, .search-panel-one-offs-container {
          font-weight: var(--bf-urlbar-results-font-weight);
          font-size: var(--bf-urlbar-font-size) !important;
        }

        #urlbar-input {
          font-size: var(--bf-urlbar-font-size) !important;
          font-weight: var(--bf-urlbar-font-weight)!important;
          text-align: center !important;
        }

        /* Urlbar buttons */
        .urlbar-icon,
        .urlbar-page-action {
          border-radius: 6px;
        }

        /* URL bar hightlight color */
        ::-moz-selection {
          background-color: var(--bf-urlbar-hightlight-bg) !important;
        }

        /* Bookmark button - Star button */
        #star-button {
        }

        #star-button:hover:not(.no-hover):not([open=true]) {
        }

        /* Set color scheme */
        #star-button:hover:not(.no-hover):not([open=true]):-moz-lwtheme-darktext,
        #star-button:hover:not(.no-hover):not([open=true]):-moz-lwtheme-brighttext {
          background: var(--bf-hover-bg) !important;
        }

        #star-button:hover:active:not(.no-hover),
        #star-button[open=true] {
        }

        /* Set color scheme */
        #star-button:hover:active:not(.no-hover):-moz-lwtheme-darktext,
        #star-button:hover:active:not(.no-hover):-moz-lwtheme-brighttext,
        #star-button[open=true]:-moz-lwtheme-darktext,
        #star-button[open=true]:-moz-lwtheme-brighttext {
          background: var(--bf-hover-bg) !important;
        }

        /* Tracking */
        #tracking-protection-icon-container {
          border-radius: 6px;
          margin: 2px;
        }

        /* Identity */
        #identity-box {
          border-radius: 6px;
          margin: 2px;
        }

        #identity-box:hover:not(.no-hover):not([open=true]),
        #tracking-protection-icon-container:hover:not(.no-hover):not([open=true]) {
        }

        #identity-box:hover:not(.no-hover):not([open=true]):-moz-lwtheme-darktext,
        #identity-box:hover:not(.no-hover):not([open=true]):-moz-lwtheme-brighttext,
        #tracking-protection-icon-container:hover:not(.no-hover):not([open=true]):-moz-lwtheme-darktext,
        #tracking-protection-icon-container:hover:not(.no-hover):not([open=true]):-moz-lwtheme-brighttext {
          background: var(--bf-hover-bg) !important;
        }

        #identity-box:hover:active:not(.no-hover),
        #identity-box[open=true],
        #tracking-protection-icon-container:hover:active:not(.no-hover),
        #tracking-protection-icon-container[open=true] {
        }

        #identity-box:hover:active:not(.no-hover):-moz-lwtheme-darktext,
        #identity-box:hover:active:not(.no-hover):-moz-lwtheme-brighttext,
        #identity-box[open=true]:-moz-lwtheme-darktext,
        #identity-box[open=true]:-moz-lwtheme-brighttext,
        #tracking-protection-icon-container:hover:active:not(.no-hover):-moz-lwtheme-darktext,
        #tracking-protection-icon-container:hover:active:not(.no-hover):-moz-lwtheme-brighttext,
        #tracking-protection-icon-container[open=true]:-moz-lwtheme-darktext,
        #tracking-protection-icon-container[open=true]:-moz-lwtheme-brighttext {
          background: var(--bf-hover-bg) !important;
        }

        /* parts/window-controls.css */
        /*
        ░█░█░▀█▀░█▀█░█▀▄░█▀█░█░█░█▀▄░█░█░▀█▀░▀█▀░█▀█░█▀█░█▀▀
        ░█▄█░░█░░█░█░█░█░█░█░█▄█░█▀▄░█░█░░█░░░█░░█░█░█░█░▀▀█
        ░▀░▀░▀▀▀░▀░▀░▀▀░░▀▀▀░▀░▀░▀▀░░▀▀▀░░▀░░░▀░░▀▀▀░▀░▀░▀▀▀

        The control buttons. Contains, close, minimize, and maximize buttons
        */

        #autohide-context {
          display: none !important;
        }

        #window-controls[hidden="true"] {
          display: none !important;
        }

        #window-controls[hidden="false"] {
          display: inline-flex !important;
        }

        /* Hide titlebar-buttonbox if there's single tab */
        /*
        :root[tabsintitlebar][sizemode="maximized"] #titlebar .titlebar-buttonbox-container {
          display: none !important;
        }
        */
        '';
        userContent = ''
        @import url('userChrome.css');

        /* Removes the white loading page */
        /* url(about:newtab), url(about:home) */
        @-moz-document url(about:blank) {
          html:not(#ublock0-epicker), html:not(#ublock0-epicker) body, #newtab-customize-overlay {
            background: var(--bf-bg) !important;
          }
        }

        /* Sets up minimal scrollbar */
        :root {
          scrollbar-width: thin !important;
          scrollbar-color: rgb(161, 161, 161) transparent !important;
        }

        /*  Sets up minimal incognito scrollbar */
        @-moz-document url(about:privatebrowsing) {
          :root{
            scrollbar-width: thin !important;
            scrollbar-color: rgb(161, 161, 161) transparent !important;
          }
        }
        '';
        extraConfig = ''
        user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
        user_pref("layers.acceleration.force-enabled", true);
        user_pref("gfx.webrender.all", true);
        user_pref("gfx.webrender.enabled", true);
        user_pref("svg.context-properties.content.enabled", true);
        user_pref("layout.css.backdrop-filter.enabled", true);
        '';
      };
    };
  };

  services.gpg-agent = {
    enable = true;
    #defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
    chromium.enableWideVine = true;
  };

  gtk = {
    enable = true;
    theme = {
      name = "gruvbox-dark";
      package = pkgs.gruvbox-dark-gtk;
    };
  };
}
