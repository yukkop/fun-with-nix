  import XMonad
  import XMonad.Config.Xfce
  main = xmonad xfceConfig
         { terminal = "kitty"
         , modMask = mod4Mask -- optional: use Win key instead of Alt as MODi key
         }
