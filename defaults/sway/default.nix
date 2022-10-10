{ pkgs }:
let
  nixos-logo-gruvbox-wallpaper = pkgs.fetchFromGitHub {
    owner = "lunik1";
    repo = "nixos-logo-gruvbox-wallpaper";
    rev = "c94a15202a1498e6d828dde570e6f24b6f4f922b";
    sha256 = "12any5ns0cimjdf7f8qi8xsygnrpagkas3zhvwhag8264xg8ljmj";
  };
in
{
  wrapperFeatures.gtk = true;
  config = {
    bars = [ ];
    modes = { };
    keybindings = { };
    # Mod1=<Alt>, Mod4=<Super>
    modifier = "Mod4";
  };
  extraConfig = /* bash */ ''
    set $mod Mod4
    # set default desktop layout (default is tiling)
    # workspace_layout tabbed <stacking|tabbed>

    # Configure border style <normal|1pixel|pixel xx|none|pixel>
    default_border pixel 5
    # for_window [class=".*"] border pixel 0
    default_floating_border normal

    # Hide borders
    hide_edge_borders none

    # setup clipman for clipboard history
    exec wl-paste -t text --watch clipman store
    exec wl-paste -p -t text --watch clipman store -P --histpath="~/.local/share/clipman-primary.json"
    bindsym $mod+z exec clipman pick -t wofi

    # change borders
    bindsym $mod+u border none
    bindsym $mod+y border pixel 5
    bindsym $mod+n border normal

    # brightness
    bindsym XF86MonBrightnessDown exec "${pkgs.brightnessctl} set 2%-"
    bindsym XF86MonBrightnessUp exec "${pkgs.brightnessctl} set +2%"

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

    bindsym $mod+b exec "GDK_BACKEND=wayland firefox"
    # bindsym $mod+b exec "qutebrowser"

    exec --no-startup-id volumeicon

    bindsym $mod+Ctrl+m exec ${pkgs.wofi-emoji}/bin/wofi-emoji

    # Screen brightness controls
    # bindsym XF86MonBrightnessUp exec "xbacklight -inc 10; notify-send 'brightness up'"
    # bindsym XF86MonBrightnessDown exec "xbacklight -dec 10; notify-send 'brightness down'"

    # screenshot binding
    bindsym $mod+Shift+p --release exec --no-startup-id grim -g "$(slurp)" ~/Pictures/$(date +%Y-%m-%d_%H-%M-%S)_grim.png

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
    # set $mousemove "/home/michael/.config/fish/w-focus-middle.fish"
    # sway has a built-in for it!
    mouse_warping container

    # swaymsg -t get_tree can help find the app_ids (wayland) and class-s (x)
    bindsym Ctrl+1 [app_id="kitty"] focus
    # bindsym Ctrl+2 [app_id="qutebrowser"] focus
    bindsym Ctrl+2 [app_id="firefox"] focus
    bindsym Ctrl+3 [class="Slack"] focus
    bindsym Ctrl+4 [class="discord"] focus
    bindsym Ctrl+5 [app_id="chrome-open.spotify.com__-Default"] focus
    # bindsym Ctrl+5 [app_id="Chromium-browser"] focus
    bindsym Ctrl+6 [class="1Password"] focus
    # bindsym Ctrl+8 [class="Element"] focus

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
    # bindsym $mod+c exec --no-startup-id wl-copy

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
    # assign [class="Thunderbird"] $ws1
    # assign [class="Pale moon"] $ws2
    # assign [class="Pcmanfm"] $ws3
    # assign [class="Skype"] $ws5

    # Open specific applications in floating mode
    for_window [title="alsamixer"] floating enable border pixel 1
    for_window [class="calamares"] floating enable border normal
    for_window [class="Clipgrab"] floating enable
    for_window [title="File Transfer*"] floating enable
    for_window [class="fpakman"] floating enable
    for_window [class="Galculator"] floating enable border pixel 1
    for_window [class="GParted"] floating enable border normal
    for_window [title="i3_help"] floating enable sticky enable border normal
    for_window [class="Lightdm-settings"] floating enable
    for_window [class="Lxappearance"] floating enable sticky enable border normal
    for_window [class="Manjaro-hello"] floating enable
    for_window [class="Manjaro Settings Manager"] floating enable border normal
    for_window [title="MuseScore: Play Panel"] floating enable
    for_window [class="Nitrogen"] floating enable sticky enable border normal
    for_window [class="Oblogout"] fullscreen enable
    for_window [class="octopi"] floating enable
    for_window [title="About Pale Moon"] floating enable
    for_window [class="Pamac-manager"] floating enable
    for_window [class="Pavucontrol"] floating enable
    for_window [class="qt5ct"] floating enable sticky enable border normal
    for_window [class="Qtconfig-qt4"] floating enable sticky enable border normal
    for_window [class="Simple-scan"] floating enable border normal
    for_window [class="(?i)System-config-printer.py"] floating enable border normal
    for_window [class="Skype"] floating enable border normal
    for_window [class="Timeset-gui"] floating enable border normal
    for_window [class="(?i)virtualbox"] floating enable border normal
    for_window [class="Xfburn"] floating enable

    # switch to workspace with urgent window automatically
    for_window [urgent=latest] focus

    # disable chromium shortcuts inhibitor
    for_window [app_id="^chrome-.*"] shortcuts_inhibitor disable

    # reload the configuration file
    bindsym $mod+Shift+r reload

    bindsym $mod+r mode "resize"
    mode "resize" {
      # These bindings trigger as soon as you enter the resize mode
      bindsym j move down 20 px
      bindsym k move up 20 px
      bindsym l move right 20 px
      bindsym h move left 20 px

      bindsym Shift+j resize grow height 10 px or 10 ppt
      bindsym Shift+k resize shrink height 10 px or 10 ppt
      bindsym Shift+l resize grow width 10 px or 10 ppt
      bindsym Shift+h resize shrink width 10 px or 10 ppt

      # exit resize mode: Enter or Escape
      bindsym Return mode "default"
      bindsym Escape mode "default"
    }

    # Set shut down, restart and locking features
    bindsym $mod+0 mode "$mode_system"
    set $mode_system (l)ock, (e)xit, switch_(u)ser, (s)uspend, (h)ibernate, (r)eboot, (Shift+s)hutdown
    mode "$mode_system" {
      bindsym l exec --no-startup-id i3exit lock, mode "default"
        bindsym s exec --no-startup-id i3exit suspend, mode "default"
        bindsym u exec --no-startup-id i3exit switch_user, mode "default"
        bindsym e exec --no-startup-id i3exit logout, mode "default"
        bindsym h exec --no-startup-id i3exit hibernate, mode "default"
        bindsym r exec --no-startup-id i3exit reboot, mode "default"
        bindsym Shift+s exec --no-startup-id i3exit shutdown, mode "default"

    # exit system mode: "Enter" or "Escape"
        bindsym Return mode "default"
        bindsym Escape mode "default"
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
    exec --no-startup-id ${pkgs.swayidle} -w timeout 300 'swaylock -f -c 000000' timeout 600 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' before-sleep 'swaylock -f -c 000000'

    set $bar_hl_color #C6643D

    bar {
      swaybar_command ${pkgs.waybar}/bin/waybar
    }

    # Theme colors
    # class                 border  backgr. text          indic.   child_border
    client.focused          #556064 #556064 #80FFF9       #FDF6E3
    client.focused_inactive #2F3D44 #2F3D44 $bar_hl_color #454948
    client.unfocused        #2F3D44 #2F3D44 $bar_hl_color #454948
    client.urgent           #CB4B16 #FDF6E3 $bar_hl_color #268BD2
    client.placeholder      #000000 #0c0c0c #ffffff       #000000

    client.background       #2B2C2B

    # Set inner/outer gaps
    gaps inner 50
    gaps outer 30

    # Smart gaps (gaps used if only more than one container on the workspace)
    smart_gaps on

    # Smart borders (draw borders around container only if it is not the only container on this workspace)
    # on|no_gaps (on=always activate and no_gaps=only activate if the gap size to the edge of the screen is 0)
    smart_borders on

    # Press $mod+Shift+g to enter the gap mode. Choose o or i for modifying outer/inner gaps. Press one of + / - (in-/decrement for current workspace) or 0 (remove gaps for current workspace). If you also press Shift with these keys, the change will be global for all workspaces.
    set $mode_gaps Gaps: (o) outer, (i) inner
    set $mode_gaps_outer Outer Gaps: +|-|0 (local), Shift + +|-|0 (global)
    set $mode_gaps_inner Inner Gaps: +|-|0 (local), Shift + +|-|0 (global)
    bindsym $mod+Shift+g mode "$mode_gaps"

    mode "$mode_gaps" {
      bindsym o      mode "$mode_gaps_outer"
        bindsym i      mode "$mode_gaps_inner"
        bindsym Return mode "default"
        bindsym Escape mode "default"
    }
    mode "$mode_gaps_inner" {
      bindsym plus  gaps inner current plus 5
        bindsym minus gaps inner current minus 5
        bindsym 0     gaps inner current set 0

        bindsym Shift+plus  gaps inner all plus 5
        bindsym Shift+minus gaps inner all minus 5
        bindsym Shift+0     gaps inner all set 0

        bindsym Return mode "default"
        bindsym Escape mode "default"
    }
    mode "$mode_gaps_outer" {
      bindsym plus  gaps outer current plus 5
        bindsym minus gaps outer current minus 5
        bindsym 0     gaps outer current set 0

        bindsym Shift+plus  gaps outer all plus 5
        bindsym Shift+minus gaps outer all minus 5
        bindsym Shift+0     gaps outer all set 0

        bindsym Return mode "default"
        bindsym Escape mode "default"
    }

    input type:touchpad {
      tap enabled
      natural_scroll enabled
      # pointer_accel 0.5
    }

    input "1267:12454:ELAN0406:00_04F3:30A6_Touchpad" {
      tap disabled
    }

    input "type:keyboard" {
      #xkb_options compose:lalt,caps:none
      xkb_options caps:none
      xkb_layout "us"
      #xkb_variant "dvp"
      repeat_delay 200
    }

    input "5426:623:Razer_Razer_Blade_Keyboard" {
      xkb_options compose:lalt,caps:escape
      xkb_layout "us"
      xkb_variant "dvp"
    }

    output eDP-1 {
      pos 0 0
      bg ${nixos-logo-gruvbox-wallpaper}/png/gruvbox-dark-rainbow.png fill
    }

    output DP-2 {
      pos 2160 875
      bg ${nixos-logo-gruvbox-wallpaper}/png/gruvbox-dark-rainbow.png fill
    }

    output HDMI-A-2 {
      pos 0 0
      transform 270
      bg ${nixos-logo-gruvbox-wallpaper}/png/gruvbox-dark-rainbow.png fill
    }
  '';
}
