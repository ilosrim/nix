{
  pkgs,
  inputs,
  outputs,
  lib,
  config,
  packages,
  ...
}: {
  config = {
    users.users = {
      ilosrim = {
        isNormalUser = true;
        description = "Mirsoli Mirsultonov";
        initialPassword = "1998";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAaQbHBiPNSnPD1KM29X5yrvkYa+u7gHvVeW4Z/j/hna ilosrim@nixos"
        ];
        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
          "vboxusers"
          "admins"
        ];
        packages =
          (with pkgs; [
            paper-plane
            dissent
          ])
          ++ (with pkgs.unstable; []);
      };
    };

    # home-manager = {
    #   extraSpecialArgs = {
    #     inherit inputs outputs;
    #   };
    #   users = {
    #     # Import your home-manager configuration
    #     ilosrim = import ../../../home.nix;
    #   };
    # };
  };
}
