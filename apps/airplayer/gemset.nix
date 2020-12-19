{
  airplay = {
    dependencies = ["CFPropertyList" "celluloid" "cuba" "dnssd" "log4r" "micromachine" "mime-types" "net-http-digest_auth" "net-ptth" "reel-rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r92w1wbc7r40gqp99nigq65id59iy4dwv3sjj3h1s2z4z3s6g87";
      type = "gem";
    };
    version = "1.0.3";
  };
  airplayer = {
    dependencies = ["airplay" "celluloid" "celluloid-io" "cuba" "http" "mime-types" "nio4r" "rack" "reel" "reel-rack" "ruby-progressbar" "thor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s30xpcbgvcm184f5kv0sz7b0gf50j2q26x4xjhd11sz56qgkfr3";
      type = "gem";
    };
    version = "1.1.0";
  };
  celluloid = {
    dependencies = ["timers"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lpa97m7f4p5hgzaaa47y1d5c78n8pp4xd8qb0sn5llqd0klkd9b";
      type = "gem";
    };
    version = "0.15.2";
  };
  celluloid-io = {
    dependencies = ["celluloid" "nio4r"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02h4lf14wqdm1b22xdzcrpjc57h23cjx774rghnxc32q8c6wgls7";
      type = "gem";
    };
    version = "0.15.0";
  };
  CFPropertyList = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dsp3zjlhvx8f911na8nvi6c0m6v7ddddl2inv6rv730wssdk4xn";
      type = "gem";
    };
    version = "2.2.8";
  };
  cuba = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11wqbjgl96yfadcava1gv6j7jz8z5jrz6ngjmh9pag2bk0940hmc";
      type = "gem";
    };
    version = "3.1.1";
  };
  dnssd = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d15jrydwk9ax3j4awcm8xwcqzx8fv0j23q44ag41k7xigfzd9xs";
      type = "gem";
    };
    version = "2.0.1";
  };
  http = {
    dependencies = ["http_parser.rb"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vw10xxs0i7kn90lx3b2clfkm43nb59jjph902bafpsaarqsai8d";
      type = "gem";
    };
    version = "0.5.0";
  };
  "http_parser.rb" = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15nidriy0v5yqfjsgsra51wmknxci2n2grliz78sf9pga3n0l7gi";
      type = "gem";
    };
    version = "0.6.0";
  };
  log4r = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ri90q0frfmigkirqv5ihyrj59xm8pq5zcmf156cbdv4r4l2jicv";
      type = "gem";
    };
    version = "1.1.10";
  };
  micromachine = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0g5g6dnrrfpnvc8yxqyykbgdpjmsp350xc4gz8k8g0g9phab3bql";
      type = "gem";
    };
    version = "1.0.4";
  };
  mime-types = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16nissnb31wj7kpcaynx4gr67i7pbkzccfg8k7xmplbkla4rmwiq";
      type = "gem";
    };
    version = "2.4.3";
  };
  net-http-digest_auth = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1psz5w4n96d3hl24xc5ldkihazlykwgvry6c111rk3yviw24cya0";
      type = "gem";
    };
    version = "1.2.1";
  };
  net-ptth = {
    dependencies = ["celluloid-io" "http_parser.rb" "rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bz0iji52v458wwlva1zszl3kikl7yy3kfbs62s641hp66zn40cr";
      type = "gem";
    };
    version = "0.0.17";
  };
  nio4r = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17lm816invs85rihkzb47csj3zjywjpxlfv2zba2z63ji2gzv1jx";
      type = "gem";
    };
    version = "1.1.1";
  };
  rack = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ds3gh8m5gy0d2k4g12k67qid7magg1ia186872yq22ham7sgr2a";
      type = "gem";
    };
    version = "1.5.5";
  };
  reel = {
    dependencies = ["celluloid" "celluloid-io" "http" "http_parser.rb" "websocket_parser"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0n20bszzv3ybdn2zibhagrrjjbxqs3l2l76di4q1igi6q6g0dsxz";
      type = "gem";
    };
    version = "0.4.0";
  };
  reel-rack = {
    dependencies = ["rack" "reel"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a95ycvb9wxzjs90f5c07nicwbpkynk7kh8bi7kix7w9jcc1qcjb";
      type = "gem";
    };
    version = "0.1.0";
  };
  ruby-progressbar = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k77i0d4wsn23ggdd2msrcwfy0i376cglfqypkk2q77r2l3408zf";
      type = "gem";
    };
    version = "1.10.1";
  };
  thor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xbhkmyhlxwzshaqa7swy2bx6vd64mm0wrr8g3jywvxy7hg0cwkm";
      type = "gem";
    };
    version = "1.0.1";
  };
  timers = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0x3vnkxy3bg9f6v1nhkfqkajr19glrzkmqd5a1wy8hrylx8rdfrv";
      type = "gem";
    };
    version = "1.1.0";
  };
  websocket_parser = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yfijqnahjfqji9887r8mzgvmzji98yd817jzng99c3hnyymiyvv";
      type = "gem";
    };
    version = "1.0.0";
  };
}