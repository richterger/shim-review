
-------------------------------------------------------------------------------
What organization or people are asking to have this signed:
-------------------------------------------------------------------------------

ECOS Technology GmbH

https://www.ecos.de/


-------------------------------------------------------------------------------
What product or service is this for:
-------------------------------------------------------------------------------

ECOS SECURE BOOT STICK (SBS)

https://www.ecos.de/produkte/zugangskomponenten/secure-boot-stick/

This is a secure ThinClient that boot from an USB Stick. The SBS [SX] Version 
is approved by the german BSI to use in govermental organisations


-------------------------------------------------------------------------------
What's the justification that this really does need to be signed for the whole world to be able to boot it:
-------------------------------------------------------------------------------

The SBS need to work on every computer, so it's necessary to have a public
signed bootloader.
Since we build the kernel and all our binaries on our own, we need to be
able to sign them with our signature, hence we need a public signed
bootloader.

-------------------------------------------------------------------------------
Who is the primary contact for security updates, etc.
-------------------------------------------------------------------------------

- Name: Gerald Richter
- Position: CTO
- Email address: richter@ecos.de
- PGP key, signed by the other security contacts, and preferably also with signatures that are reasonably well known in the linux community:
https://github.com/richterger/shim-review/blob/master/pgpkeys/gerald.richter%40ecos.de.asc

-------------------------------------------------------------------------------
Who is the secondary contact for security updates, etc.
-------------------------------------------------------------------------------

- Name: Tobias Schaefer
- Position: Engineer
- Email address: tobias.schaefer@ecos.de
- PGP key, signed by the other security contacts, and preferably also with signatures that are reasonably well known in the linux community:
https://github.com/richterger/shim-review/blob/master/pgpkeys/tobias.schaefer%40ecos.de.asc

-------------------------------------------------------------------------------
What upstream shim tag is this starting from:
-------------------------------------------------------------------------------

https://github.com/rhboot/shim.git
commit a4a1fbe728c9545fc5647129df0cf1593b953bec 15 Mar 2019

-------------------------------------------------------------------------------
URL for a repo that contains the exact code which was built to get this binary:
-------------------------------------------------------------------------------

https://github.com/rhboot/shim.git
+ patches-shim/ecos_shim.patch

See BUILD (or below) for exact instructions how to build the binary


-------------------------------------------------------------------------------
What patches are being applied and why:
-------------------------------------------------------------------------------

patches-shim/ecos_shim.patch

- We have removed all functionality from shim we don't use
- MokManager is not used. The code to load ModManger has been removed,  so there is no way to add user certificates
- All certificates have been removed from the code and from the build process
- The only certificate that is compiled into our shim is our EV code signing certificate that is used to verify grub
- Verification of hashs (sha1, sha256 etc) (without certificate) of other binaries has been removed from the code.
- Loading of binaries that are whitelisted with MokManager has been removed from the code
- The one and only thing this shim can do is to load a bootloader that is signed with our EV code signing certificate

-------------------------------------------------------------------------------
What OS and toolchain must we use to reproduce this build?  Include where to find it, etc.  We're going to try to reproduce your build as close as possible to verify that it's really a build of the source tree you tell us it is, so these need to be fairly thorough. At the very least include the specific versions of gcc, binutils, and gnu-efi which were used, and where to find those binaries.
-------------------------------------------------------------------------------

```
# debian strech
# binutils/stable,now 2.28-5 amd64 
# gcc/stable,now 4:6.3.0-4 amd64 

mkdir /usr/src/apps
cd /usr/src/apps

git clone https://github.com/richterger/shim-review.git
git clone https://github.com/rhboot/shim.git
cd shim
git checkout a4a1fbe728c9545fc5647129df0cf1593b953bec
cd ..

# debian strech has, gnu-efi 3.0.4 which is too old, so download and install
# gnu-efi 3.0.9
wget https://sourceforge.net/projects/gnu-efi/files/gnu-efi-3.0.9.tar.bz2
tar xvfj gnu-efi-3.0.9.tar.bz2 
cd gnu-efi-3.0.9/
make install PREFIX=/usr LIBDIR=/usr/lib64
cd ../shim
patch -p1 < ../shim-review/patches-shim/ecos_shim.patch 
cp ../shim-review/patches-shim/ECOS_Tech_Code_signing_Certificate_EV.cer .
make
```



-------------------------------------------------------------------------------
Which files in this repo are the logs for your build?   This should include logs for creating the buildroots, applying patches, doing the build, creating the archives, etc.
-------------------------------------------------------------------------------

shim_build.log

-------------------------------------------------------------------------------
Add any additional information you think we may need to validate this shim
-------------------------------------------------------------------------------
