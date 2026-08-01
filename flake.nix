{
	description = "Change your GNOME Shell and GTK accent colors dynamically based on your wallpaper";

	inputs = {
		flake-parts = { type="github"; owner="hercules-ci"; repo="flake-parts"; };
		nixpkgs = { type="github"; owner="NixOS"; repo="nixpkgs"; ref="nixpkgs-unstable"; };
		chromaleon = {
			url = "https://github.com/Fabito02/ChromaLeon/releases/latest/download/user-accent-colors@fabito02.shell-extension.zip";
			flake = false;
		};
	};

	outputs = inputs@{ flake-parts, ... }:
		flake-parts.lib.mkFlake { inherit inputs; } {
			systems = [ "x86_64-linux" "aarch64-linux" ];
			perSystem = { config, self', inputs', pkgs, system, ... }: {
				packages = let pkgName = "chromaleon-gnome-extension"; in {
					default = self'.packages.${pkgName};
					${pkgName} = pkgs.stdenv.mkDerivation {
						name = pkgName;
						src = inputs.chromaleon;
						nativeBuildInputs = [pkgs.buildPackages.glib];

						buildPhase = ''
							glib-compile-schemas --strict ./schemas/
						'';

						installPhase = ''
							install_path=$out/share/gnome-shell/extensions/user-accent-colors@fabito02
							${pkgs.lib.getExe' pkgs.coreutils "mkdir"} --parents -- $install_path
							${pkgs.lib.getExe' pkgs.coreutils "cp"} --recursive --no-target-directory -- ./ $install_path
						'';

						fixupPhase = ''
							substituteInPlace $install_path/utils/recolorUtils.js \
								--replace-warn "/usr/share/icons/" "/run/current-system/sw/share/icons/"
						'';

						meta = {
							description = "Change your GNOME Shell and GTK accent colors dynamically based on your wallpaper";
							homepage = "https://github.com/Fabito02/ChromaLeon";
							license = pkgs.lib.licenses.gpl3;
							platforms = pkgs.lib.platforms.linux;
						};
					};
				};
			};
		};
}		 
