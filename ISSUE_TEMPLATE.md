Make sure you have provided the following information:

 - [x] link to your code branch cloned from rhboot/shim-review in the form user/repo@tag

	https://github.com/richterger/shim-review

 - [x] completed README.md file with the necessary information

        https://github.com/richterger/shim-review/blob/master/README.md

 - [x] shim.efi to be signed

	https://github.com/richterger/shim-review/blob/master/shimx64.efi	

 - [x ] public portion of your certificate embedded in shim (the file passed to VENDOR_CERT_FILE)

    	https://github.com/richterger/shim-review/blob/master/patches-shim/ECOS_Tech_Code_signing_Certificate_EV.cer

 - [x] any extra patches to shim via your own git tree or as files

	https://github.com/richterger/shim-review/tree/master/patches-shim

 - [x] any extra patches to grub via your own git tree or as files

	https://github.com/richterger/shim-review/tree/master/patches-grub

 - [x] build logs

	https://github.com/richterger/shim-review/blob/master/shim_build.log


###### What organization or people are asking to have this signed:

ECOS Technology GmbH

https://www.ecos.de/

###### What product or service is this for:

ECOS SECURE BOOT STICK (SBS)

https://www.ecos.de/produkte/zugangskomponenten/secure-boot-stick/

This is a secure ThinClient on a USB Stick, the SBS [SX] Version is approved
by the german BSI to use in govermental organisation

###### What is the origin and full version number of your shim?

https://github.com/rhboot/shim.git
commit a4a1fbe728c9545fc5647129df0cf1593b953bec 15 Mar 2019

###### What's the justification that this really does need to be signed for the whole world to be able to boot it:

The SBS need to work in every computer, so it's necessary to have a public
signed bootloader.
Since we build the kernel and all our binaries on our own, we need to be
able to sign them with our signature, hence we need a public signed
bootloader.


###### How do you manage and protect the keys used in your SHIM?

The key is stored on a FIPS-140-2 Token. The key is part of our EV code
signing certificate.

###### Do you use EV certificates as embedded certificates in the SHIM?

yes

###### What is the origin and full version number of your bootloader (GRUB or other)?

https://www.gnu.org/software/grub/

Gentoo ebuild grub-2.02-r3

###### If your SHIM launches any other components, please provide further details on what is launched

shim is patched to only be able to launch our own grub. Launching any other
code (like Mok-Manager, Fallback etc.) has been removed from shim

###### How do the launched components prevent execution of unauthenticated code?

Our grub has the following patches:

- Grub is build and shipped as one static binary. No modules are used.
- The code to load a module at runtime (insmod) has been removed from our grub
- Grub is signed with our EV code signing certificate
- Grub only loads a kernel that was signed by us. There is no way to load any code that is not correctly signed with our certificate.
- Also other files like background images are only loaded if they are correctly signed
- There is no way to add a user certificate.
- The Linux Kernel we use, uses signed modules and only loads modules that are correctly signed with our certificate.
- grub.cfg is embbeded in the signed grub binary

###### Does your SHIM load any loaders that support loading unsigned kernels (e.g. GRUB)?

No

###### What kernel are you using? Which patches does it includes to enforce Secure Boot?

Kernel 4.14, 4.19 and 5.1. Our kernel and all modules are signed
by our key and kernel enforces that only correctly signed modules are
loaded.

###### What changes were made since your SHIM was last signed?

Updated from shim 0.9 to 0.15+

###### What is the hash of your final SHIM binary?

8f6b33b2fb10f6333ef37f0b8aac70b8ab73b121588879f3c6d28eed550f8f53  shimx64.efi

