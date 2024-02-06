{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ qpwgraph ];
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = false;
  };

  environment.etc."pipewire/pipewire.conf.d/pipewire.conf".text = ''
    context.properties = {
      "link.max-buffers" = 64;
      "log.level" = 2;
      "default.clock.rate" = 44100; # all signals are converted to this sample rate, and then back to what device supports
      "default.clock.allowed-rates" = [ 44100 ];
      "default.clock.min-quantum" = 32;
      "default.clock.max-quantum" = 4096;
      "default.clock.quantum" = 1024;
      "defualt.clock.quantum-limit" = 4096;
      "clock.power-of-two-quantum" = true; # more efficient
      "core.daemon" = true;
      "core.name" = "pipewire-0";
    };
  '';

  sound.enable = true;
  hardware.pulseaudio.enable = false;
}

