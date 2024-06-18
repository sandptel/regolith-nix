{ pkgs, ...}:

pkgs.stdenv.mkDerivation {
pname= "i3xrocks";
version="v1.0";

src= pkgs.fetchFromGitHub{
owner= "regolith-linux";
repo="i3xrocks";
rev="r3_1";
sha256="a8RwSoZElGwqkxnRtn/FeNMzXeS8PnfXhMQpYSuYD0I=";
};

buildInputs=with pkgs;[
    autoconf
    automake   
pkg-config
xcbutilxrm
xorg.xcbutil
  ];

buildPhase = ''
    ./autogen.sh
    ./configure
     mkdir -p $out/share
     make install DESTDIR=$out/share
   cp -r $out/share/usr/local/bin $out
  '';

  installPhase = ''
   
  '';
  
  meta = {
    mainProgram = "i3xrocks";
    description = "A fork of i3blocks that can read Xresources. ";
    homepage = "https://github.com/regolith-linux/i3xrocks";
    license = pkgs.lib.licenses.gpl3Plus;
  };

}
