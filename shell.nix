{ pkgs ? import <nixpkgs> {} }:
let android-nixpkgs = (pkgs.callPackage (import (builtins.fetchGit {url = "https://github.com/tadfisher/android-nixpkgs.git";})) {channel = "stable";});

in pkgs.mkShell {
  buildInputs = with pkgs; [
    #basics
    flutter git
    #linux build
    at-spi2-core.dev clang cmake dbus.dev flutter gtk3 libdatrie libepoxy.dev util-linux.dev libselinux libsepol libthai libxkbcommon ninja pcre pcre2.dev pkg-config xorg.libXdmcp xorg.libXtst
    #android build
    (android-nixpkgs.sdk (sdkPkgs: with sdkPkgs; [cmdline-tools-latest build-tools-32-0-0 tools patcher-v4 platform-tools platforms-android-31 system-images-android-31-default-x86-64 emulator])) jdk8 unzip
    #web build
    chromium
  ];
  #declaring FLUTTER_ROOT
  FLUTTER_ROOT = pkgs.flutter;
  #libepoxy workaround
  LD_LIBRARY_PATH = "${pkgs.libepoxy}/lib";
  #web chrome and dart-sdk workaround
  CHROME_EXECUTABLE = "chromium";
  shellHook = ''
    if ! [ -d $HOME/.cache/flutter/ ]
    then
    mkdir $HOME/.cache/flutter/
    fi
    ln -f -s ${pkgs.flutter}/bin/cache/dart-sdk $HOME/.cache/flutter/
  '';
}
