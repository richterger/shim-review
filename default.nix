# This is a Nix (https://nixos.org/nix) expression for (repducible) build of
# the Red Hat boot shim, with the Hiddn Security Secure Boot certificate built
# in.
#
# Usage:
#   nix-build [--option sandbox true]
#
# Sandboxed build is optional, but recommended. It enables container-like
# isolation from the build host. Sandboxed builds happen in /build (bind
# mounted), whereas non-sandboxed builds happen in /tmp/nix-build-$NAME. The
# shimx64.efi binary gets the same hash whether or not sandboxing is enabled.
#
# Tested on Linux x86_64 with Nix 2.2.
#
# Author: Bjørn Forsman <bjorn.forsman@gmail.com>

let
  # Get the build environment (compiler++) from this nixpkgs version.
  pkgsSource = builtins.fetchTarball {
    # branch release-18.09 @ 2019-04-25
    url = "https://github.com/NixOS/nixpkgs/archive/196979ee539bd2ba16e224356be787085e27776a.tar.gz";
    sha256 = "05jd1l9nn0dzvm5i6g7ngjz48cymc9l77yz9ngwz3diy5cz0k8kl";
  };

  # Pass values for config and overlays, so they won't be searched for in
  # impure places ($HOME).
  pkgs = import pkgsSource { config = {}; overlays = []; };
in

pkgs.stdenv.mkDerivation rec {
  name = "shim-${version}";
  version = "15-hiddn1";

  # release tag 15 (2019-04-05)
  shimCommit = "51413d1deb0df0debdf1d208723131ff0e36d3a3";
  src = pkgs.fetchzip {
    url = "https://github.com/rhboot/shim/archive/${shimCommit}.tar.gz";
    sha256 = "1xgplglq5laa7a7gda0wly80ilf7svmwi5a7raabsqpmq23zjlfq";
  };

  # Trace the whole build.
  # Use `nix-store -l ./result | grep -E -v "^\++"` to filter out the trace.
  preUnpack = ''
    set -x
  '';

  # For reproducible build
  patches = [
    # Backported from master
    ./patches/Makefiles-ensure-m32-gets-propogated-to-our-gcc-para.patch  # a dependency of the next patch
    ./patches/Once-again-try-even-harder-to-get-binaries-without-t.patch

    # https://github.com/rhboot/shim/pull/169
    ./patches/Makefile-use-fixed-build-host-if-SOURCE_DATE_EPOCH-is-defined.patch
  ];

  buildInputs = with pkgs; [ gnu-efi elfutils ];

  EFI_INCLUDE = "${pkgs.gnu-efi}/include/efi";
  EFI_PATH = "${pkgs.gnu-efi}/lib";

  # * The build is run without .git/, for reproducible source hash, so
  #   explicitly pass the COMMIT_ID. (Without this it'll fall back to "master".)
  # * Disable parallel build (DASHJ=1), for reproducible build log (diff'able).
  buildPhase = ''
    make \
      VENDOR_CERT_FILE=${./hiddn-secure-boot.cer} \
      COMMIT_ID=${shimCommit} \
      DASHJ=1
  '';

  # Plain "install" tries to install the shim to the host EFI System Partition,
  # so use a different install target.
  installPhase = ''
    make install-as-data prefix="$out"
  '';

  # For easy reference to the core tools used in this build (that is asked for
  # in the shim-review process).
  #
  # Usage:
  #   $ nix-build -A important-deps
  #   /nix/store/5c5vbvcybxllw3jdwzm1s0gx7j1464rc-binutils-wrapper-2.30
  #   /nix/store/cy3x06bfplivhrvx6rf7vkszx81c09nn-gcc-wrapper-7.3.0
  #   /nix/store/v81hady4j01dxnpdhbqzb55bf18zrsm5-gnu-efi-3.0.8
  passthru = {
    important-deps = with pkgs; {
      inherit (stdenv) cc;
      inherit binutils gnu-efi;
    };
  };

  meta.description = "Red Hat boot shim built with Hiddn Security Secure Boot certificate";
}
