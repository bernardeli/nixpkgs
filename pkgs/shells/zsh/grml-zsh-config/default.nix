{ stdenv, fetchFromGitHub, lib
, zsh, coreutils, inetutils, procps, txt2tags }:

with lib;

stdenv.mkDerivation rec {
  name = "grml-zsh-config-${version}";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "grml";
    repo = "grml-etc-core";
    rev = "v${version}";
    sha256 = "15cr8pv1idshhq5d9sq4smgfl00iz55ji5mrxclsl3a35wg0djnw";
  };

  buildInputs = [ zsh coreutils txt2tags procps ]
    ++ optional stdenv.isLinux [ inetutils ];

  buildPhase = ''
    cd doc
    make
    cd ..
  '';

  installPhase = ''
    install -D -m644 etc/zsh/keephack $out/etc/zsh/keephack
    install -D -m644 etc/zsh/zshrc $out/etc/zsh/zshrc

    install -D -m644 doc/grmlzshrc.5 $out/share/man/man5/grmlzshrc.5
    ln -s grmlzshrc.5.gz $out/share/man/man5/grml-zsh-config.5.gz
  '';

  meta = with stdenv.lib; {
    description = "grml's zsh setup";
    homepage = http://grml.org/zsh/;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ msteen rvolosatovs ];
  };
}
