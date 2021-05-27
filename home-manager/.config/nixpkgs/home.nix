{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # fish shell
  programs.fish.enable = true;

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
  home.stateVersion = "21.03";

  home.packages = with pkgs; [
    curl
    neofetch
    swaylock
    swayidle
    wl-clipboard
    docker-compose
    grim
    wf-recorder
    dnsutils
    traceroute
    nmap
    ipcalc
    discord
    slack
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
    extraConfig.core.editor = "kak";
    ignores = [ "*.swp" "*.swo" ".projections.json" "*.elixir_ls/" ];
    userName = "Michael Davis";
    userEmail = "mcarsondavis@gmail.com";
    signing = {
      key = "25D3AFE4BA2A0C49";
      signByDefault = true;
    };
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
  font pango:monospace 10
  mode dock
  hidden_state hide
  position top
  status_command /nix/store/mzafm8qk4cl9i7wb64im401whxmvy4pb-i3status-2.13/bin/i3status
  swaybar_command /nix/store/2kmbrsbmrls4f9xppig66mdrv5hxhnp3-sway-1.5/bin/swaybar
  workspace_buttons yes
  strip_workspace_numbers no
  tray_output primary
  colors {
    background #000000
    statusline #ffffff
    separator #666666
    focused_workspace #4c7899 #285577 #ffffff
    active_workspace #333333 #5f676a #ffffff
    inactive_workspace #333333 #222222 #888888
    urgent_workspace #2f343a #900000 #ffffff
    binding_mode #2f343a #900000 #ffffff
  }
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

input \"1452:613:Apple_Inc._Magic_Trackpad_2\" {
  tap enabled
  natural_scroll enabled
  # pointer_accel 0.5
}

input \"type:keyboard\" {
  xkb_options compose:lalt,caps:none
  xkb_layout \"us\"
  xkb_variant \"dvp\"
  repeat_delay 200
}

#output DP-2 {
#  pos 0 0
#  bg /home/michael/.backgrounds/highway.jpg fill
#}
#
#output HDMI-A-2 {
#  pos 3840 -875
#  transform 90
#  bg /home/michael/.backgrounds/red-mountain.jpg fill
#}
    ";
  };

  programs.kitty = {
    enable = true;
    extraConfig = "
map shift+left previous_tab
map shift+right next_tab
    ";
    font = {
      name = "JetBrains Mono";
      package = pkgs.jetbrains-mono;
      #size = 10;
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
  };

  services.gpg-agent = {
    enable = true;
    #defaultCacheTtl = 1800;
    enableSshSupport = true;
  };
}
