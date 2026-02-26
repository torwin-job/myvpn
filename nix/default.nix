{
  buildGoModule,
  subPackage ? null,
  self,
}:

let
  binaryMapping = {
    "client" = "myvpn-client";
    "server" = "myvpn-server";
  };

  selectedSubPackages =
    if subPackage != null then
      [ "cmd/${subPackage}" ]
    else
      [
        "cmd/client"
        "cmd/server"
      ];

  binaryName =
    if subPackage != null then builtins.getAttr subPackage binaryMapping else "myvpn-client";
in

buildGoModule {
  pname = "myvpn";
  version = self.shortRev or self.dirtyShortRev or "dirty";

  src = ../.;

  subPackages = selectedSubPackages;

  vendorHash = "sha256-1fBJpb7SoW8lb/JXr01NvUwBq0lhrvSp+utI5MgVP98=";

  ldflags = [ "-s" ];

  postInstall = ''
    if [ -f "$out/bin/client" ]; then
      mv "$out/bin/client" "$out/bin/myvpn-client"
    fi
    if [ -f "$out/bin/server" ]; then
      mv "$out/bin/server" "$out/bin/myvpn-server"
    fi
  '';

  meta = {
    description = "MyVPN protocol";
    homepage = "https://github.com/torwin-job/myvpn";
    mainProgram = binaryName;
  };
}
