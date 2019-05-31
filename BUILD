
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

