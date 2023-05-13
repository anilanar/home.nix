let
  DP1 = "DP-1";
  DP2 = "DP-2";
  HDMI = "HDMI-0";
  lg-4k = {
    "${DP2}" =
      "00ffffffffffff001e6d077736a703000b1e0104b53c22789e3e31ae5047ac270c50542108007140818081c0a9c0d1c08100010101014dd000a0f0703e803020650c58542100001a286800a0f0703e800890650c58542100001a000000fd00383d1e8738000a202020202020000000fc004c472048445220344b0a20202001830203197144900403012309070783010000e305c000e3060501023a801871382d40582c450058542100001e565e00a0a0a029503020350058542100001a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000029";
  };
  benq = {
    "${HDMI}" =
      "00ffffffffffff0009d1ce78455400002618010380351e782e6b35a455559f270c5054a56b80d1c081c081008180a9c0b30001010101023a801871382d40582c4500132b2100001e000000ff003539453032353136534c300a20000000fd00324c1e5311000a202020202020000000fc0042656e5120474c323436300a20017e020322f14f90050403020111121314060715161f2309070765030c00100083010000023a801871382d40582c4500132b2100001f011d8018711c1620582c2500132b2100009f011d007251d01e206e285500132b2100001e8c0ad08a20e02d10103e9600132b21000018000000000000000000000000000000000000000000e7";
  };
  sony-tv = {
    "${HDMI}" =
      "00ffffffffffff004dd9034b0101010101180103806a3c780a0dc9a05747982712484c2108008180a9c0714fb3000101010101010101023a801871382d40582c450027564200001e011d007251d01e206e28550027564200001e000000fc00534f4e592054560a2020202020000000fd00303e0e460f000a20202020202001a902032ff0531f101405130420223c3e121603071115020601260d0707150750830f000068030c001000b82d0fe200fb023a80d072382d40102c458027564200001e011d00bc52d01e20b828554027564200001e011d8018711c1620582c250027564200009e011d80d0721c1620102c258027564200009e00000000000000007a";
  };
in {
  outputs = {
    inherit DP1;
    inherit DP2;
    inherit HDMI;
  };
  profiles = {
    "1_home_single" = {
      fingerprint = lg-4k // benq;
      config = {
        "${DP2}" = {
          enable = true;
          primary = true;
          rate = "60.00";
          mode = "3840x2160";
          position = "0x0";
          dpi = 160;
        };
        "${HDMI}" = { enable = false; };
      };
    };
    "2_home_double" = {
      fingerprint = lg-4k // benq;
      config = {
        "${DP2}" = {
          enable = true;
          primary = true;
          rate = "60.00";
          mode = "3840x2160";
          position = "3840x0";
          dpi = 160;
          scale = {
            x = 1;
            y = 1;
          };
        };
        "${HDMI}" = {
          enable = true;
          primary = false;
          mode = "1920x1080";
          position = "0x0";
          rate = "60.00";
          dpi = 91;
          scale = {
            x = 2;
            y = 2;
          };
        };
      };
    };
    "3_home_tv" = {
      fingerprint = lg-4k // sony-tv;
      config = {
        "${DP2}" = {
          enable = true;
          primary = true;
          rate = "60.00";
          mode = "3840x2160";
          position = "3840x0";
          dpi = 160;
          scale = {
            x = 1;
            y = 1;
          };
        };
        "${HDMI}" = {
          enable = true;
          primary = false;
          mode = "1920x1080";
          position = "0x0";
          dpi = 46;
          scale = {
            x = 2;
            y = 2;
          };
        };
      };
    };
    "4_home_tv_mirror" = {
      fingerprint = lg-4k // sony-tv;
      config = {
        "${DP2}" = {
          enable = true;
          primary = true;
          rate = "60.00";
          mode = "3840x2160";
          position = "0x0";
          dpi = 160;
          scale = {
            x = 1;
            y = 1;
          };
        };
        "${HDMI}" = {
          enable = true;
          primary = false;
          rate = "60.00";
          mode = "1920x1080";
          position = "0x0";
          dpi = 46;
          scale = {
            x = 2;
            y = 2;
          };
        };
      };
    };
    "5_tv_single" = {
      fingerprint = sony-tv;
      config = {
        "${HDMI}" = {
          enable = true;
          primary = true;
          rate = "60.00";
          mode = "1920x1080";
          position = "0x0";
          dpi = 46;
          scale = {
            x = 1;
            y = 1;
          };
        };
      };
    };
  };
}
