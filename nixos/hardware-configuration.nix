# This is just an example, you should generate yours with nixos-generate-config and put it in here.
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/4b44640e-4535-4928-862c-1076ecef31d5";
    fsType = "ext4";
  };

  fileSystems."/boot" = { 
    device = "/dev/disk/by-uuid/9807-03B0";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [ ];

  # Set your system kind (needed for flakes)
  nixpkgs.hostPlatform = "x86_64-linux";
  # hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
