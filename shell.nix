{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, stdenv, turtle, pywal, betterlockscreen }:
      mkDerivation {
        pname = "er-wallpaper";
        version = "0.1.0.0";
        src = ./.;
        isLibrary = false;
        isExecutable = true;
        executableHaskellDepends = [ base turtle ];
        homepage = "https://github.com/emmanuelrosa/er-wallpaper";
        description = "A script for changing wallpaper and setting color schemes, for Linux";
        license = stdenv.lib.licenses.mit;

        postConfigure = ''
          substituteInPlace Main.hs \
            --replace _ER_PATH_WAL_ \""${pywal}/bin/wal"\" \
            --replace _ER_PATH_BETTERLOCKSCREEN_ \""${betterlockscreen}/bin/betterlockscreen"\"
        '';
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv
