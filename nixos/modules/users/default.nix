{ pkgs, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ilosrim = {
    isNormalUser = true;
    description = "ilosrim";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
    packages = with pkgs; [ firefox-esr ];
  };
}
