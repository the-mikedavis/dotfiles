import XMonad

import XMonad.Actions.DynamicWorkspaces
import XMonad.Actions.CycleWS
import XMonad.Actions.FloatKeys
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.FloatNext
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.NamedScratchpad
import XMonad.Layout
import XMonad.Layout.Accordion
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Spacing
import XMonad.Util.Loggers
import XMonad.Util.NamedWindows (getName)
import XMonad.Util.Font
import XMonad.Util.Run
import Graphics.X11.ExtraTypes.XF86

import qualified Data.Map as M

myTerminal = "alacritty"

xmproc = "killall xmobar 2>/dev/null; xmobar -x 0 /home/michael/.config/xmobar/xmobar.config"

myBorderWidth = 2
myNormalBorderColor = "#BFBFBF"
myFocusedBorderColor = "#89DDFF"

modm = mod4Mask

gaps = spacingRaw True (Border 15 15 15 15) True (Border 8 8 8 8) True -- gaps (border / window spacing)

myLayout = sizeTall ||| Accordion
  where
    sizeTall = ResizableTall 1 (3 / 100) (1 / 2) []

myCustomKeybindings conf@(XConfig {XMonad.modMask = modMask}) =
  [ ((modMask, xK_r), spawn "xmonad --recompile && xmonad --restart")
  ]

myKeys x = M.union (M.fromList (myCustomKeybindings x)) (keys def x)

main :: IO ()
main = do
  xmproc <- spawn xmproc
  xmonad desktopConfig
         { borderWidth = myBorderWidth
         , normalBorderColor = myNormalBorderColor
         , focusedBorderColor = myFocusedBorderColor
         , terminal = myTerminal
         , startupHook = spawn "feh --bg-fill /home/michael/Pictures/big-sur-dark.jpg"
         , layoutHook = avoidStruts $ gaps $ smartBorders $ myLayout
         , modMask = modm
         , keys = myKeys
         }
