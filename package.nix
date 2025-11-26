{
  lib,
  stdenv,
  fetchurl,
  makeDesktopItem,
  p7zip,
  wine,
}:
stdenv.mkDerivation {
  pname = "Voices of the Void";
  version = "0.9.0b_0004";
  src = fetchurl {
    url = "https://archive.votv.zip/VDMR/a09b_0004.7z";
    hash = "sha256-hkdCssr4GgNxfzyT0bWjx8ys0p2WgNQsQJR9s3insoM=";
  };
  buildInputs = [ p7zip ];

  buildPhase = ''
    runHook preBuild

    echo -e "#!${stdenv.shell}

    WINEPREFIX=\$HOME/.local/share/VotV ${lib.getExe wine}  $out/VotV.exe" > ./votv
    chmod +x ./votv

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r WindowsNoEditor/* $out/
    mkdir -p $out/bin
    cp ./votv $out/bin/votv
    mkdir -p $out/share
    ln -s "$desktopItem/share/applications" $out/share/

    runHook postInstall
  '';

  desktopItem = makeDesktopItem {
    name = "Voices of the Void";
    desktopName = "Voices of the Void";
    icon = fetchurl {
      url = "https://votv.dev/assets/body/logo.png";
      hash = "sha256-pEv5DMgCjNNXBvsNf8/hPiFMPeR0fz5OXLsOcBDWWao=";
    };
    exec = "votv";
    categories = [ "Game" ];
  };

  meta = {
    homepage = "https://votv.dev/";
    description = "An early-access indie horror simulation video game";
    maintainers = with lib.maintainers; [ notarin ];
    platforms = lib.platforms.linux;
    mainProgram = "votv";
  };
}
