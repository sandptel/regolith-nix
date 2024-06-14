{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  pkg-config,
  xcbutilxrm,
  xorg,
  ...
}:

stdenv.mkDerivation {
pname= "i3xrocks";
version="v1.0";

src= fetchFromGitHub{
owner= "regolith-linux";
repo="i3xrocks";
rev="r3_1";
sha256="a8RwSoZElGwqkxnRtn/FeNMzXeS8PnfXhMQpYSuYD0I=";
};

buildInputs=[
    autoconf
    automake   
pkg-config
xcbutilxrm
xorg.xcbutil
  ];

buildPhase = ''
    ./autogen.sh
    ./configure
    make 
  '';

  installPhase = ''
    make install DESTDIR=$out/bin
  '';
  

}