Make sure you have provided the following information:

 - [x] link to your code branch cloned from rhboot/shim-review in the form user/repo@tag
   hiddn-security/shim-review@hiddn-security-shim-x86_64-20190520 ([direct link](https://github.com/hiddn-security/shim-review/tree/hiddn-security-shim-x86_64-20190520))
 - [x] completed README.md file with the necessary information
   https://github.com/hiddn-security/shim-review/blob/hiddn-security-shim-x86_64-20190520/README.md
 - [x] shim.efi to be signed
   https://github.com/hiddn-security/shim-review/blob/hiddn-security-shim-x86_64-20190520/shimx64.efi
 - [x] public portion of your certificate embedded in shim (the file passed to VENDOR_CERT_FILE)
   https://github.com/hiddn-security/shim-review/blob/hiddn-security-shim-x86_64-20190520/hiddn-secure-boot.cer
 - [x] any extra patches to shim via your own git tree or as files
   See the ./patches directory in https://github.com/hiddn-security/shim-review/tree/hiddn-security-shim-x86_64-20190520.
 - [x] any extra patches to grub via your own git tree or as files
   No patches.
 - [x] build logs
   https://github.com/hiddn-security/shim-review/blob/hiddn-security-shim-x86_64-20190520/build.log

###### What organization or people are asking to have this signed:
Hiddn Security AS, https://hiddn.no/.

###### What product or service is this for:
HDDs and SSDs with hardware encryption. For example, this product:
https://hiddn.no/products/safedisk/.

###### What is the origin and full version number of your shim?
Version 15 (https://github.com/rhboot/shim/releases/tag/15), plus 3 patches for
reproducible builds. Patch 1 and 2 are backported from master branch, patch 3
is from shim [PR 169](https://github.com/rhboot/shim/pull/169/).

###### What's the justification that this really does need to be signed for the whole world to be able to boot it:
We develop and sell secure storage products on the global market that contains
a pre-boot environment for entering a passphrase to unlock/decrypt. This
pre-boot environment is write protected by our custom firmware/hardware.
Currently our customers are forced to disable Secure Boot, or else the pre-boot
environment gets rejected by the UEFI firmware. Neither we nor our customers
want that!

###### How do you manage and protect the keys used in your SHIM?
The keys are stored on an offline PC/network, with strict access rules.

###### Do you use EV certificates as embedded certificates in the SHIM?
No.

###### What is the origin and full version number of your bootloader (GRUB or other)?
grub-2.04-rc1 (94d9926a664014007130796616210b68e421d54a), from
https://git.savannah.gnu.org/git/grub.git. grubx64.efi is built with embedded
grub.cfg file and shim_lock support.

###### If your SHIM launches any other components, please provide further details on what is launched
No other components are launched.

###### How do the launched components prevent execution of unauthenticated code?
No other components are launched.

###### Does your SHIM load any loaders that support loading unsigned kernels (e.g. GRUB)?
No.

###### What kernel are you using? Which patches does it includes to enforce Secure Boot?
Linux 4.4.56, from kernel.org. No patches. (Updating to newer longterm kernel
versions are planned.) Secure Boot is enforced by embedding all our user space
in the kernel initramfs and not load any code from outside. (The complete
bzImage/linux.efi image is less than 4 MiB.)

###### What changes were made since your SHIM was last signed?
None. This is our first submission.

###### What is the hash of your final SHIM binary?
```
$ sha256sum ./result/share/shim/15/x64/shimx64.efi
a4d1c9a7a680fcc1a3e73f9ce28a81fce2b82a868beab7d94a769dfcfd0eca09  ./result/share/shim/15/x64/shimx64.efi
```
