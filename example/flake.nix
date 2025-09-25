{
  inputs = {
    xnode-manager.url = "github:Openmesh-Network/xnode-manager";
    xnode-nodejs-template.url = "github:Openmesh-Network/xnode-nodejs-template"; # "path:..";
    nixpkgs.follows = "xnode-nodejs-template/nixpkgs";
  };

  outputs = inputs: {
    nixosConfigurations.container = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
      };
      modules = [
        inputs.xnode-manager.nixosModules.container
        {
          services.xnode-container.xnode-config = {
            host-platform = ./xnode-config/host-platform;
            state-version = ./xnode-config/state-version;
            hostname = ./xnode-config/hostname;
          };
        }
        inputs.xnode-nodejs-template.nixosModules.default
        {
          services.xnode-nodejs-template.enable = true;
        }
      ];
    };
  };
}
