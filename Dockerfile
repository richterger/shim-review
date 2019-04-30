# Usage:
#   $ docker build -t hiddn-shim-review .
#   $ docker run -it -v $PWD:/hiddn-shim-review hiddn-shim-review
#
# The shim build result will be available ./result/ (on the host), similar to a
# normal nix-build.
#
# NOTE: Nix builds inside Docker cannot use sandboxing.

FROM nixos/nix:2.2.1

# Override these commands and run a shell instead with `docker run [...] sh`
CMD echo "Building the shim with nix" \
  && set -x \
  && cd /hiddn-shim-review \
  && rm -f ./result \
  && nix-build \
  && nix-store -l ./result > build.log.from-docker \
  && mkdir -p result-from-docker \
  && cp -r ./result/* result-from-docker \
  && rm -f ./result \
  && ln -sf result-from-docker result
