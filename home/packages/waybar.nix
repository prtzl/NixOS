{ lib, configName, pkgs, ... }:

let
  # Load base configs, we'll add device specific configs to these
  baseconfig = (builtins.fromJSON (builtins.readFile ./dotfiles/waybar/config));
  basestyle = builtins.readFile ./dotfiles/waybar/style.css;

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
        hwmon-path = [ "/dev/${path}" ];
        format = "${icon}  {temperatureC}°C";
        interval = 5;
      };
    };

  selectedTemps = temps.${configName};

  makeTempConfigNames = configs:
    lib.lists.imap1 (index: name: "temperature#${builtins.toString index}")
    configs;
  tempConfigNames = makeTempConfigNames selectedTemps;

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
      temperature#${builtins.toString index} {
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
      interval = 5;
      format = "${builtins.toString index}⛃ {percentage_used}%";
      path = "${path}";
    };
  };

  selectedDisks = disks.${configName};

  makeDiskConfigNames = configs:
    lib.lists.imap1 (index: name: "disk#${builtins.toString index}") configs;
  diskConfigNames = makeDiskConfigNames selectedDisks;

  makeDiskConfigs = configs:
    lib.lists.imap1 (index: name: makeDisks name index) configs;
  diskConfigs =
    lib.foldl' (acc: x: acc // x) { } (makeDiskConfigs selectedDisks);

  diskStyle = builtins.concatStringsSep ''
    ,
  '' diskConfigNames + ''
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
      format = "{ifname}";
      format-wifi = "   {essid} ";
      format-ethernet = "   {ifname} ";
      format-disconnected = " 🚫 ";
      format-disabled = "  ";
      tooltip-format = "{ifname}";
      tooltip-format-wifi = " {essid} ({signalStrength}%)  ";
      tooltip-format-ethernet = " {ifname}  ";
      tooltip-format-disconnected = "{ifname} disconnected";
      max-length = 100;
      on-click = "nm-connection-editor";
      interval = 5;
    };
  };

  # selectedInterfaces = interfaces.nixtop; # for testing
  selectedInterfaces = interfaces.${configName};

  # Create list of network interfaces
  makeNetworkConfigNames = configs:
    lib.lists.imap1 (index: name: "network#${builtins.toString index}") configs;
  networkConfigNames = makeNetworkConfigNames selectedInterfaces;

  # Create css block for styling network interfaces
  networkStyle = "";

  # Create attrset of network config option blocks
  makeNetworkConfigs = configs:
    lib.lists.imap1 (index: name: makeInterface name index) configs;
  networkConfigs =
    lib.foldl' (acc: x: acc // x) { } (makeNetworkConfigs selectedInterfaces);

  ## Output configs

  # Append network interfaces before last element (audio)
  modules-right = let
    original = baseconfig.modules-right;
    # First three are tray, cpu, and memory;
    firstBase = lib.lists.take 3 original;
    # Leaves with last 2
    secondBase = lib.lists.take 2 (lib.lists.drop 3 original);
  in firstBase ++ tempConfigNames ++ diskConfigNames ++ networkConfigNames
  ++ secondBase;

  # Write new config and style
  config = baseconfig // {
    modules-right = modules-right;
  } // networkConfigs // diskConfigs // tempConfigs;
  style = basestyle + networkStyle + diskStyle + tempStyle;

in {
  programs.waybar = {
    enable = true;
    package = pkgs.unstable.waybar;
    systemd.enable = true;
    settings = [ config ];
    style = style;
  };
}
