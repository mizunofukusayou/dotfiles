{
  lazyvim,
  self,
  userName,
  ...
}:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${userName} = ../home-manager/home.nix;
    extraSpecialArgs = {
      inherit userName;
      inherit self;
      inherit lazyvim;
    };
  };
  users.users.${userName}.home = "/Users/${userName}";
}
