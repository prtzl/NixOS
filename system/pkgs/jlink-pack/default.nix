{
  stdenv
, fetchurl
, fontconfig
, freetype
, lib
, libICE
, libSM
, udev
, libX11
, libXcursor
, libXext
, libXfixes
, libXrandr
, libXrender
}:

stdenv.mkDerivation rec {
  name = "segger-jlink";
  version = "762a";
  
  src = fetchurl {
    url = "https://www.segger.com/downloads/jlink/JLink_Linux_V${version}_x86_64.tgz";
    sha256 = "sha256-dRFTpqkiu5s9OKAUMF2EeqFsUsw7gz/WddXlc6lu2d4=";
    netrcPhase = ''
      curlOpts="-X POST -F accept_license_agreement=accepted -F submit=Download+software $curlOpts"
    '';
  };

  rpath = lib.makeLibraryPath [
    fontconfig
    freetype
    libICE
    libSM
    udev
    libX11
    libXcursor
    libXext
    libXfixes
    libXrandr
    libXrender
  ] + ":${stdenv.cc.cc.lib}/lib64";

  phases = [ "installPhase" "fixupPhase" ];

  executables = "JFlashExe JFlashLiteExe JFlashSPICLExe JFlashSPIExe JLinkConfigExe JLinkExe JLinkGDBServerCLExe JLinkGDBServerExe JLinkGUIServerExe JLinkLicenseManagerExe JLinkRegistrationExe JLinkRemoteServerCLExe JLinkRemoteServerExe JLinkRTTClientExe JLinkRTTLoggerExe JLinkRTTViewerExe JLinkSTM32Exe JLinkSWOViewerCLExe JLinkSWOViewerExe JMemExe JRunExe JTAGLoadExe";
  folder = "JLink_Linux_V${version}_x86_64";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,lib/udev/rules.d}
    tar -xvf $src -C $out
    for exe in ${executables}; do
      ln -s $out/${folder}/$exe $out/bin
    done
    ln -s $out/${folder}/99-jlink.rules $out/lib/udev/rules.d
    runHook postInstall
  '';

  postFixup = ''
    for exe in ${executables}; do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$out/${folder}/$exe" \
        --set-rpath ${rpath}:$out/${folder} "$out/${folder}/$exe"
    done

    for file in $(find $out/${folder} -maxdepth 1 -name '*.so*'); do
      patchelf --set-rpath ${rpath}:$out/${folder} $file
    done
  '';

  meta = with lib; {
    description = "Segger JLink Software Pack";
    homepage = https://www.segger.com/downloads/jlink/;
    license = licenses.unfree;
    maintainers = with stdenv.lib.maintainers; [ prtzl ];
    platforms = [ "x86_64-linux" ];
  };
}
