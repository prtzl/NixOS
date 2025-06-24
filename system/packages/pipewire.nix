{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ qpwgraph ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    extraConfig.pipewire.samplerate = {
      "context.properties" = {
        "log.level" = 2;

        "default.clock.rate" = 44100;
        "default.clock.allowed-rates" = [ 44100 48000 88200 96000 ];

        "default.clock.quantum" = 512; # ~10.64mn latency
        "default.clock.min" = 32;
        "default.clock.max-quantum" = 4096;
        "default.clock.quantum-limit" = 4096;
        "clock.power-of-two-quantum" = true; # more efficient
      };
    };
  };

  services.pulseaudio.enable = false;
}
