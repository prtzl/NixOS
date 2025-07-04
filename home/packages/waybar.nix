{ lib, configName, pkgs, ... }:

let
  # Load base configs, we'll add device specific configs to these
  baseconfig = (builtins.fromJSON (builtins.readFile ./dotfiles/waybar/config));
  basestyle = builtins.readFile ./dotfiles/waybar/style.css;

  batteries = [ "nixtop" ];

  makeBatteries = path: index: {
    battery = {
      bat = "BAT0";
      interval = 60;
      states = {
        warning = 30;
        critical = 15;
      };
      format = "{capacity}%";
      max-length = 25;
    };
  };

  selectedBatteries = batteries;

  batteryConfigNames =
    lib.lists.imap1 (index: name: "battery") selectedBatteries;

  makeBatteryConfigs = configs:
    lib.lists.imap1 (index: name: makeBatteries name index) configs;
  batteryConfigs =
    lib.foldl' (acc: x: acc // x) { } (makeBatteryConfigs selectedBatteries);

  makeBatterieStyle = name: index:
    let color = "#028909";
    in ''
      #battery {
        color: ${color};
      }
    '';
  batteryStyle = builtins.concatStringsSep "\n"
    (lib.lists.imap1 (index: name: makeBatterieStyle name index)
      selectedBatteries);

  # Temperatures
  temps = {
    nixbox = [ "cpu_temp" "gpu_temp" ];
    nixtop = [ "cpu_temp" ];
  };

  makeTemps = path: index:
    let
      icon = if path == "cpu_temp" then
        ""
      else if path == "gpu_temp" then
        "🏭"
      else
        ""; # fallback/default
    in {
      "temperature#${builtins.toString index}" = {
        format = "${icon} {temperatureC}°C";
        hwmon-path = [ "/dev/${path}" ];
        interval = 5;
        tooltip-format = "${path}: {temperatureC}°C";
      };
    };

  selectedTemps = temps.${configName};

  tempConfigNames =
    lib.lists.imap1 (index: name: "temperature#${builtins.toString index}")
    selectedTemps;

  makeTempConfigs = configs:
    lib.lists.imap1 (index: name: makeTemps name index) configs;
  tempConfigs =
    lib.foldl' (acc: x: acc // x) { } (makeTempConfigs selectedTemps);

  makeTempStyle = name: index:
    let
      color = if name == "cpu_temp" then
        "#3ffc81"
      else if name == "gpu_temp" then
        "#982daf"
      else
        "#ffffff"; # fallback/default
    in ''
      #temperature.${builtins.toString index} {
        color: ${color};
      }
    '';
  tempStyle = builtins.concatStringsSep "\n"
    (lib.lists.imap1 (index: name: makeTempStyle name index) selectedTemps);

  # DISKS
  disks = {
    nixbox = [ "/" "/storage" ];
    nixtop = [ "/" ];
    wsl = [ "/" ];
    testbox = [ "/" ];
  };

  makeDisks = path: index: {
    "disk#${builtins.toString index}" = {
      format = "󰋊 {percentage_used}%";
      interval = 5;
      path = "${path}";
      tooltip = true;
      tooltip-format = "{path}: Available {free} of {total}";
      unit = "GB";
    };
  };

  selectedDisks = disks.${configName};

  diskConfigNames =
    lib.lists.imap1 (index: name: "disk#${builtins.toString index}")
    selectedDisks;

  makeDiskConfigs = configs:
    lib.lists.imap1 (index: name: makeDisks name index) configs;
  diskConfigs =
    lib.foldl' (acc: x: acc // x) { } (makeDiskConfigs selectedDisks);

  diskStyle = builtins.concatStringsSep ''
    ,
  '' (lib.lists.imap1 (index: name: "#disk.${builtins.toString index}")
    selectedDisks) + ''
      {
        color: #b58900;
      }
    '';

  ## INTERFACES
  interfaces = {
    nixbox = [ "enp9s0" ];
    nixtop = [ "enp0s31f6" "wlp61s0" ];
    wsl = [ "eth0" ];
    testbox = [ "enp1s0" ];
  };

  makeInterface = name: index: {
    "network#${builtins.toString index}" = {
      interface = "${name}";
      format-wifi = " ";
      format-ethernet = " ";
      format-disconnected = "🚫";
      format-disabled = " ";
      tooltip-format = "{ifname}";
      tooltip-format-wifi = " {essid} ({signalStrength}%) {ipaddr}";
      tooltip-format-ethernet = " {ifname} {ipaddr}";
      tooltip-format-disconnected = "{ifname} disconnected";
      max-length = 200;
      on-click = "nm-connection-editor";
      interval = 5;
    };
  };

  # selectedInterfaces = interfaces.nixtop; # for testing
  selectedInterfaces = interfaces.${configName};

  # Create list of network interfaces
  networkConfigNames =
    lib.lists.imap1 (index: name: "network#${builtins.toString index}")
    selectedInterfaces;

  # Create css block for styling network interfaces
  networkStyle = builtins.concatStringsSep ''
    ,
  '' (lib.lists.imap1 (index: name: "#network.${builtins.toString index}")
    selectedInterfaces) + ''
      {
        color: #800080;
      }
    '';

  # Create attrset of network config option blocks
  makeNetworkConfigs = configs:
    lib.lists.imap1 (index: name: makeInterface name index) configs;
  networkConfigs =
    lib.foldl' (acc: x: acc // x) { } (makeNetworkConfigs selectedInterfaces);

  ## Output configs

  # modues-right has cpu - memory - pulse. Put the "dynamic modules" between first two and last.
  modules-right = let
    original = baseconfig.modules-right;
    # First are tray, language, cpu, and memory;
    firstBase = lib.lists.take 4 original;
    # Leaves with pulse
    secondBase = lib.lists.take 1 (lib.lists.drop 4 original);
  in firstBase ++ tempConfigNames ++ diskConfigNames ++ networkConfigNames
  ++ batteryConfigNames ++ secondBase;

  # Write new config and style
  config = baseconfig // {
    modules-right = modules-right;
  } // networkConfigs // diskConfigs // tempConfigs // batteryConfigs;
  style = basestyle + networkStyle + diskStyle + tempStyle + batteryStyle;

in {
  programs.waybar = {
    enable = true;
    package = pkgs.unstable.waybar;
    systemd.enable = true;
    # Latch onto hyprland configured in wayland.windowManager.hyprland.systemd.enable, otherwise it crashes if started before hyprlanb
    systemd.target = "hyprland-session.target";
    settings = [ config ];
    style = style;
  };
}
