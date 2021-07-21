{ pkgs, config, ... }:

let
  xmobarConfig = pkgs.writeText "xmobar-config" ''
    Config {
        position = TopP 200 400,
        font = "xft:JetBrains Mono:size=10,Noto Color Emoji:size=10",
        bgColor = "#000000",
        fgColor = "#ffffff",
        lowerOnStart = False,
        overrideRedirect = False,
        allDesktops = True,
        persistent = True,
        commands = [
            Run Weather "EDDL" ["-t", "<tempC>°C"] 18000,
            Run MultiCpu ["-t","Cpu: <autovbar>","-L","30","-H","60","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC","-w","3"] 10,
            Run Memory ["-t","Mem: <usedratio>%","-H","8192","-L","4096","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,
            -- TODO: Switch to EU date format
            Run Date "%a %_d %b %H:%M" "date" 10,
            -- Sound volume
            Run Volume "default" "Master" [] 10,
            -- Spotify controls
            -- Run Mpris2 "Player" [] 10,
            -- Required by xmonad for active window/workspace
            Run StdinReader
        ],
        sepChar = "%",
        alignSep = "}{",
        template = "%StdinReader% } { %multicpu% %memory%          <fc=#b2b2ff>%default:Master%</fc>      <fc=#FFFFCC>%EDDL% | %date%</fc>"
    }
  '';

  xmonadConfig = pkgs.writeText "xmonad-config" ''
    import XMonad
    import XMonad.Config.Desktop
    import XMonad.Layout.IndependentScreens
    import XMonad.Layout.Spacing
    import XMonad.Layout.NoBorders
    import XMonad.Hooks.DynamicLog
    import XMonad.Hooks.ManageHelpers
    import XMonad.Hooks.EwmhDesktops
    import XMonad.Hooks.ManageDocks
    import qualified XMonad.StackSet as W
    import XMonad.Util.Cursor
    import XMonad.Util.Run(spawnPipe, unsafeSpawn)
    import XMonad.Util.Spotify(mediaKeys)
    import XMonad.Util.EZConfig(additionalKeys)
    import XMonad.Util.ALSA(volumeKeys)

    import System.IO  

    main = do
        screenCount <- countScreens
        xmprocs <- mapM (\i -> spawnPipe $ "xmobar ${xmobarConfig} -x " ++ show i) [0..screenCount-1]
        -- When in need to temporarily disable xmobar
        -- xmprocs <- (mempty :: IO [Handle])
        xmonad $ conf xmprocs
    conf xmprocs = docks $ desktopConfig
            { borderWidth = 6
            , normalBorderColor = "#595959"
            , focusedBorderColor = "#cf6e00"
            , terminal = "${pkgs.kitty}/bin/kitty"
            , layoutHook = avoidStruts $ smartSpacing 8 $ smartBorders $ layoutHook desktopConfig 
                           ||| noBorders Full
            -- , handleEventHook = (handleEventHook desktopConfig) <+> fullscreenEventHook
            , modMask = mod4Mask
            , keys = (mediaKeys . volumeKeys) <$> keys desktopConfig
            , focusFollowsMouse = False
            , clickJustFocuses = True
            , workspaces = withScreens 2 ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
            , logHook = (logHook desktopConfig) >> mapM_ (\handle -> dynamicLogWithPP $ xmobarPP
                         { ppOutput = hPutStrLn handle
                         , ppTitle = xmobarColor "green" "" . shorten 50
                         , ppLayout = const ""
                         }) xmprocs
            -- (isFullscreen --> doFullFloat) <+> ?
            , manageHook = manageHook desktopConfig
            } `additionalKeys` (myKeys xmprocs)
    myKeys xmprocs =
         [
         -- workspaces are distinct by screen
          ((m .|. mod4Mask, k), windows $ onCurrentScreen f i)
               | (i, k) <- zip (workspaces' (conf xmprocs)) [xK_1 .. xK_9]
               , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
         ]
         ++
         [
         -- swap screen order
         ((m .|. mod4Mask, key), screenWorkspace sc >>= flip whenJust (windows . f))
               | (key, sc) <- zip [xK_w, xK_e] [1,0]
               , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
  '';
in {
  home.packages = with pkgs; [ xmobar ];

  xsession.windowManager.xmonad = {
    enable = true;
    config = xmonadConfig;
    enableContribAndExtras = true;
    extraPackages = haskellPackages: [
      haskellPackages.xmonad-spotify
      haskellPackages.xmonad-volume
    ];
  };
}
