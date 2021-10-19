# NixOS configuration

This is my "portable" NixOS configuration repository.  
It houses system configuration files and user files managed by home-manager, which is installed by system. 

## Compatability

There are a few settings to keep an eye on when porting to a different machine: 
* system/hardware-configuration.nix
    * Update list `boot.initrd.availableKernelModules` for your system
    * My system uses EFI bootloader with following partition names:
        * root (`/`) = "nixos"
        * swap = "swap"
        * boot (`/boot`) = "boot"
* system/configuration.nix: 
    * Name the correct network interface under:  
        ```
        networking.interfaces.enp<?>s0.useDHCP = true
        ```

Other parts of system configurations should be hardware agnostic. Of course don't forget to change username and git configuration!

