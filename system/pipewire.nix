{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ qjackctl ];
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    config.pipewire = {
      "context.properties" = {
        "link.max-buffers" = 32;
        "log.level" = 2;
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 32;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 32;
        "core.daemon" = true;
        "core.name" = "pipewire-0";
      };
    };
    media-session.config.alsa-monitor = {
      rules = [
        {
          # SMSL SU-9 : out, Focusrite iTrack Solo : in/out
          matches = [{ "node.name" = "alsa_output.usb-SMSL_SMSL_USB_AUDIO*"; } { "node.name" = "alsa_output.usb-Focusrite_iTrack_Solo*"; } { "node.name" = "alsa_input.usb-Focusrite_iTrack_Solo*"; }];
          actions = {
            update-props = {
              "audio.format" = "S32LE";
              "audio.rate" = 96000; # for USB soundcards it should be twice your desired rate
              "api.alsa.period-size" = 32; # defaults to 1024, tweak by trial-and-error
              "api.alsa.disable-batch" = false; # generally, USB soundcards use the batch mode
            };
          };
        }
      ];
    };
  };

  sound.enable = true;
  hardware.pulseaudio.enable = false;
}

