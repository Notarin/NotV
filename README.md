# What is this?

This is a [Nix](https://nixos.org/) [flake](https://wiki.nixos.org/wiki/Flakes) packaging, likely wrapping, and providing games that I or others felt like packaging.

# Games

The following is a list of what games are packaged, some information about the package itself, and potentially some notes to consider.

## Voices of the Void

A subtle horror game that is early-release. You can find it [here](https://votv.dev/).

### Running Voices of the Void

#### Running an installed Voices of the Void

This votv package comes bundled with a custom desktop entry, meaning it will show up in your launcher like any other application. Of course, you will have had to installed it preceding this using any of the methods listed or another.

#### Running Voices of the Void without cloning

Useful for if you want to try it out before you clone it onto your machine.

```sh
nix run github:/Notarin/Notagames#votv
```

### Installing Voices of the Void on NixOS

There is a multitude of ways to install the votv package into your NixOS install. [It is assumed you have already fetched this flake inside yours](#how-to-get-this-flake-into-your-flake).

#### Installing Voices of the Void system-wide on NixOS

The most likely and straightforward method is simply adding it to your environment packages, `environment.systemPackages`.

```nix
environment.systemPackages = with pkgs; [
    # If you have passed just the package itself here
    votv
    # or may look something like this if you passed the entire flake here
    Notagames.packages.${pkgs.stdenv.hostPlatform.system}.votv
];
```

#### Installing Voices of the Void to a single user on NixOS

If you want to provide the game to a single user, without the others having it available, you can pass it to that specific users packages, `users.users.<name>.packages`.

```nix
users.users.<name>.packages = with pkgs; [
    # If you have passed just the package itself here
    votv
    # or may look something like this if you passed the entire flake here
    Notagames.packages.${pkgs.stdenv.hostPlatform.system}.votv
];
```

### Installing Voices of the Void on home-manager

There is a multitude of ways to install the votv package into your NixOS install. [It is assumed you have already fetched this flake inside yours](#how-to-get-this-flake-into-your-flake).

#### Installing Voices of the Void into your home-manager environment

This is the most likely way you will install Voices of the Void if you are using home-manager. You will simply just add it to your home packages, `home.packages`. (this exact syntax is assuming standalone. If you use home-manager as a module and feel like contributing, please reach out.)

```nix
home.packages = with pkgs; [
    # If you have passed just the package itself here
    votv
    # or may look something like this if you passed the entire flake here
    Notagames.packages.${pkgs.stdenv.hostPlatform.system}.votv
];
```

### Notes

This package has `wine` included in its closure, being how it runs the windows game. Furthermore, it specifically uses a wayland variant of wine, depending on your system this may spell issues for you. This package is made using `stdenv` from `nixpkgs`, meaning it has the standard overridability, you may override the package to change the version of wine used.

```nix
votv.override {wine = pkgs.wine64;}
# or
Notagames.packages.${pkgs.stdenv.hostPlatform.system}.votv.override {wine = pkgs.wine64;}
```

To prevent this game from clashing from any system installed version of wine, or any previously used version of wine, it has `WINEPREFIX` set to be `~/.local/share/VotV/`, so it places all its files there. This dir contains both internal wine data, as all as **ALL OF YOUR SAVE FILES** made with this game. If you override the version of wine with another, it may not be compatible with the wine data saved to the prefix, meaning it will fuss and fail to start. Excersize caution *before* you delete the previous instance of wines data, make *sure* you back up your saves.

Speaking of which, this flake is very young. Changes may be made with no notice, causing you having to move the wine/save-dir, or possibly lose the data altogether! You should be making backups anyways.

Another note, it is planned to attempt to switch to proton.

# Extra Info

## How to get this flake, into *your* flake

There are two easy ways to fetch this flake in your own, each with their pros and cons.

### Adding this flake to your Inputs

The simplest way, at the price of the flake *always* fetching this flake regardless of if it needs it for not, is simply adding it to your flakes inputs.

```nix
# All of the following are perfectly identical, but defined with slightly different syntax to show how it may look different in your own flake.
inputs = {
    Notagames = {
         url = "github:Notarin/Notagames";
    };
};
inputs = {
    Notagames.url = "github:Notarin/Notagames";
};
inputs.Notagames.url = "github:Notarin/Notagames";
```

Following adding this to your inputs, you will then have to get it usable in your outputs. Firstly, given that `outputs` is actually a function, you will need to set it up so that this flake is passed into the arg of the function, there are two main ways of doing that.

#### Passing an arg in directly

This is the common, declarative, and recommended method.

```nix
outputs = {self, nixpkgs, ...}: {...}
# becomes
outputs = {self, nixpkgs, Notagames, ...}: {...}
```

You then may use the flake as a value in the outputs body, by the name `Notagames`.

#### Passing the arg in by (at) operator

The `...` operator is an operator using in function args to say "I can take infinite extra args.". It alone doesn't do much besides let you ignore args, however in conjuction with the `@` operator, it becomes a single unit encapsulating all the args. This includes both explicitly listed args, as well as any extra args passed. It looks like this:

```nix
outputs = {self, nixpkgs, ...}@inputs: {...} # "inputs" could be any name
# or even no explicit args
outputs = {...}@inputs: {...}
# or if it tickles your fancy, you can do both
outputs = {self, nixpkgs, Notagames, ...}@inputs: {...}
```

Then in the outputs body you may refer to the flake as `inputs.Notagames`, or just by its name in the third example.

### Actually using the flake

Following getting the flake fetched and loaded into your own, then comes actually using/installing it.

#### Loading the flake into NixOS modules

In NixOS, you will add either the flake itself, or the package to `specialArgs`, then in any NixOS module, you may add the flake or the package in the top args and then use this flake however you please.

#### Loading the flake into home-manager modules

In home-manager, it is nearly identical to NixOS, but instead of `specialArgs`, it is `extraSpecialArgs`.
