Nix flake package for the [Chromaleon](https://github.com/Fabito02/ChromaLeon "Change your GNOME Shell and GTK accent colors dynamically based on your wallpaper.") Gnome extension.

# Installation Instructions
1. Add the input to your `flake.nix`
```nix
inputs = {
	…
	chromaleon = {
		type="github"; owner="drazape"; repo="ChromaLeon-flake";
		inputs.nixpkgs.follows = "nixpkgs"; # optional
	};
	…
};
…
```

2. Simply install the `default` package in your system environment from the added input in a module.
```nix
environment.systemPackages = [
	…
	inputs.chromaleon.packages.${pkgs.stdenvNoCC.hostPlatform.system}.default
	…
];
```

The extension will be installed after a rebuild. re-login into Gnome, and enable the extension

# Internal Working
1. The flake gets the clean extension source from the release assets by using the URL in the `inputs`
2. It uses [*flake-parts*](https://flake.parts/) to declare the package for Linux
3. It uses the standard environment from *Nixpkgs* to make a derivation
4. Compiles the schemas during the build phase
5. Copies the current build directory to `$out/share/gnome-shell/extensions/user-accent-colors@fabito02`
6. Changes the icon paths to `/run/current-system/sw/share/icons/`. It doesn't use direct Nix store paths so that the icon packs aren't installed if the user doesn't want them.
