let
  userlike =
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDbp09TLfDZyYezsyuK7JRWEmhICjh7gTsMwAa4FIVpRwuQuMpWrLh1vF5eHzHNIBu3c/wt2gWVrzSxaJWKCIi8yyOdCAN/3ISrWoSU3uBFYaP71UvvyayrPH7f+3QVQkrh+g1EyNnwa+FINYxdsmJuj3yhK35Y7NOe6T/QRF48e/UMocXQzPeLAVlPK/DWirKVOl4xcrwzMClcRUG3Y76HMe2LnGo8+WtbCGgQ4qQPD6151xBw6ERahbQFMR8s9/BC87R/ZnLQmRi+0PDUpD9bnx+4L+Tjdvraif6Y5cVGnqlbLbAfC2vM5gDYYhIZat/NFCgdKFjNUDcOA52J4JK9N9l87WXiZInleDmjYwUwmrzT/6d10wnabfjxJYhJdUTVXw8g1KEkqeoMDfDLmUG5Xl+zueiJbVLsiqoot0MH7rfBLFiR6hWsYB4yhjhmzd3HYkWWa19On6h/OWbS3cFD8KYUR4HwoHZeaAaF71tiaMglIlVQnAQ1Zzg2amYSs8M8eE1GXr0mbbyWXjnv3+RiZYXCgEYd39OtfQHFIHT1bprkrOS+Nh+72tsV8GizXtmeuyRDP6E/6Ajey9NQ4JmlskOo0kQaVY4gHPWOVa8YmjKlrGx35y5cvOymcjNuk33scMhqhVgOOLApfoOW8Y8JH8NTA/dNCURJp3Bgp0WLYQ==";
  personal =
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDG5azctgXKFldK4+z+ExEH6mE+3dwBkM/Xg3mOZ+AsGChZTfuACD3+6pneMuIylwbGsa8OmocO/MWvQHQhN8iTAnDgbFO+q8QR71NbqKr2VfjS5jyNCwaiZM9svuufEiTyRx4SiBvEK3DzXCJWRyTAaLNcdFsK87/DNf0gDu7bfZgs59ynHAD3kCxFDHJstltRf+ZzC1Vg4aw5uxshocEiwWaCAxXl1aapPSkP9E0gNi9FoNq/ZQAJWahXcjRqTlu/Q2E04ZQFRlDHEcu3woR5the4+JS2sIdCaeUHkXou2DyECvH8GMTpZw7Mh6orvdDAppS4XNpCiLzcQtEKH39vuPue2MOPtGn8UIKRFVbBWuDsjw80aj7dSU4Nhg5ikqB3kFPWQfBSYn1eS94FxRUsZhtKQpo5AgToTxpNawBhlROmdWCMzaKIed2hkSYr/dTfIP06POMk3+XQ/Rn7gnnal4tm/uLr0J8I9B+ztUjbti1RkC0lM8rgxzVezp05J8Ca+hoNgw5vFvv00+oP5FWr+Q63FirQRQ+fu+33NfIEEGsBFovzlvCBOM4K7Sn+F02K5MZ6gm//z7b5TYI58RGnWthNxRazf6lSczt92xo5NnAQhMDsFPMePonrI2YdM/iXBQAljqMUrdiN6fQsmJTHotRweQQSExQzQktyXl+bEQ==";
  allKeys = [ userlike personal ];
in { "secret.age".publicKeys = allKeys; }