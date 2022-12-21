{ pkgs, ... }:

let
  glWrapIntel = { pkg, deps ? [ ] }: pkgs.stdenv.mkDerivation rec {
    pname = pkg.pname + "-glwrap";
    version = pkg.version;
    src = pkg;
    nativeBuildInputs = [ pkg pkgs.nixgl.nixGLIntel ] ++ deps;
    installPhase = ''
      mkdir -p $out/bin
      for d in `find $src -maxdepth 1 -type d ! -path $src | grep -v bin`; do
        ln -s $d $out/$(basename $d)
      done
      for fpath in `find $src/bin -type f`; do
        f=$(basename $fpath)
        fold=$f"_base"
        ln -s $fpath $out/bin/$fold
        touch $out/bin/$f
        chmod +x $out/bin/$f
        echo "${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel $out/bin/$fold" > $out/bin/$f
      done
    '';
  };
in
{
  inherit glWrapIntel;
}
