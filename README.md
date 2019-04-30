This repo is for review of requests for signing shim.  To create a request for review:

- clone this repo
- edit the template below
- add the shim.efi to be signed
- add build logs
- commit all of that
- tag it with a tag of the form "myorg-shim-arch-YYYYMMDD"
- push that to github
- file an issue at https://github.com/rhboot/shim-review/issues with a link to your branch

Note that we really only have experience with using grub2 on Linux, so asking
us to endorse anything else for signing is going to require some convincing on
your part.

Here's the template:

-------------------------------------------------------------------------------
What organization or people are asking to have this signed:
-------------------------------------------------------------------------------
Hiddn Security AS, https://hiddn.no/.

-------------------------------------------------------------------------------
What product or service is this for:
-------------------------------------------------------------------------------
HDDs and SSDs with hardware encryption. For example, this product:
https://hiddn.no/products/safedisk/.

-------------------------------------------------------------------------------
What's the justification that this really does need to be signed for the whole world to be able to boot it:
-------------------------------------------------------------------------------
We develop and sell secure storage products on the global market that contains
a pre-boot environment for entering a passphrase to unlock/decrypt. This
pre-boot environment is write protected by our custom firmware/hardware.
Currently our customers are forced to disable Secure Boot, or else the pre-boot
environment gets rejected by the UEFI firmware. Neither we nor our customers
want that!

-------------------------------------------------------------------------------
Who is the primary contact for security updates, etc.
-------------------------------------------------------------------------------
- Name: Bjørn Forsman
- Position: Software developer
- Email address: bf@hiddn.no
- PGP key, signed by the other security contacts, and preferably also with signatures that are reasonably well known in the linux community:
  (No PGP key, sorry.)

-------------------------------------------------------------------------------
Who is the secondary contact for security updates, etc.
-------------------------------------------------------------------------------
- Name: Daniel Bengtsson
- Position: Software developer
- Email address: db@hiddn.no
- PGP key, signed by the other security contacts, and preferably also with signatures that are reasonably well known in the linux community:
  (No PGP key, sorry.)

-------------------------------------------------------------------------------
What upstream shim tag is this starting from:
-------------------------------------------------------------------------------
https://github.com/rhboot/shim/releases/tag/15

-------------------------------------------------------------------------------
URL for a repo that contains the exact code which was built to get this binary:
-------------------------------------------------------------------------------

Due to applying patches on the shim release, for reproducible builds, the
source code necessarily have been split in two:

* This repo itself, from https://github.com/hiddn-security/shim-review,
  containing the shim patches.
* Upstream shim repo, at release 15:
  https://github.com/rhboot/shim/archive/51413d1deb0df0debdf1d208723131ff0e36d3a3.tar.gz.
  This gets fetched at build time by the build scripts in this shim-review
  repo.

The exact code is set up at build time by extracting the shim release tarball,
then applying the patches.

-------------------------------------------------------------------------------
What patches are being applied and why:
-------------------------------------------------------------------------------
* `./patches/Makefiles-ensure-m32-gets-propogated-to-our-gcc-para.patch`, a
  dependency of the next patch, backported from shim master branch
  (commit [104d6e54ac7b](https://github.com/rhboot/shim/commit/104d6e54ac7b8d608edc09d0fc1e916dec033b35)).
* `./patches/Once-again-try-even-harder-to-get-binaries-without-t.patch`,
  for reproducible build, backported from shim master branch (commit
  [a4a1fbe728c9](https://github.com/rhboot/shim/commit/a4a1fbe728c9545fc5647129df0cf1593b953bec)).
* `./patches/Makefile-use-fixed-build-host-if-SOURCE_DATE_EPOCH-is-defined.patch`,
  for reproducible build, copied from https://github.com/rhboot/shim/pull/169.

These patches are applied by [./default.nix](./default.nix).

-------------------------------------------------------------------------------
What OS and toolchain must we use to reproduce this build?  Include where to find it, etc.  We're going to try to reproduce your build as close as possible to verify that it's really a build of the source tree you tell us it is, so these need to be fairly thorough. At the very least include the specific versions of gcc, binutils, and gnu-efi which were used, and where to find those binaries.
-------------------------------------------------------------------------------
The shim is built with [Nix](http://nixos.org/nix). For convenience there is a
Dockerfile that wraps the build. See usage comments in
[./Dockerfile](./Dockerfile). The docker build has been verified on Fedora 29
x86_64 (without SELinux: `setenforce 0`) and NixOS 18.09 x86_64.

Alternatively, if not using docker, here are other ways to setup the build:

1. Install Nix on Linux distros like this: `curl https://nixos.org/nix/install | sh`.
2. Import [this NixOS OVA file](https://releases.nixos.org/nixos/18.09/nixos-18.09.2532.571b40d3f50/nixos-18.09.2532.571b40d3f50-x86_64-linux.ova)
into VirtualBox. (The exact NixOS version doesn't matter much, since the build
uses pinned/frozen dependency references. But it must have Nix >= 2.0.)

When you have the `nix-build` command available, do the build inside this
repo:

```
# Generally sandboxing is recommended for reproducibility, but turn it off to
# make the build similar to the docker environment.
$ nix-build --option sandbox false

$ sha256sum ./result/share/shim/15/x64/shimx64.efi
a4d1c9a7a680fcc1a3e73f9ce28a81fce2b82a868beab7d94a769dfcfd0eca09  ./result/share/shim/15/x64/shimx64.efi
```

The tools used for the build can be inspected interactively with `nix-shell`
(enters the build environment). Alternatively, run this and inspect the paths
that get printed:

```
$ nix-build -A important-deps
/nix/store/5c5vbvcybxllw3jdwzm1s0gx7j1464rc-binutils-wrapper-2.30
/nix/store/cy3x06bfplivhrvx6rf7vkszx81c09nn-gcc-wrapper-7.3.0
/nix/store/v81hady4j01dxnpdhbqzb55bf18zrsm5-gnu-efi-3.0.8
```

-------------------------------------------------------------------------------
Which files in this repo are the logs for your build?   This should include logs for creating the buildroots, applying patches, doing the build, creating the archives, etc.
-------------------------------------------------------------------------------
[./build.log](./build.log), obtained with `nix-store -l ./result > build.log`
after having run `nix-build --option sandbox false` inside this repo.

The build is run in a `set -x` shell, for completeness. To reduce the noise,
filter it with `grep -E -v "^\++" build.log`.

-------------------------------------------------------------------------------
Add any additional information you think we may need to validate this shim
-------------------------------------------------------------------------------
None.
