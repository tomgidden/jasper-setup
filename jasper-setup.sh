#!/bin/bash

set -e

# https://gist.github.com/red-green/10587222

# Jasper install script (http://jasperproject.github.io/)
# Must be run as root (i.e. sudo setup.sh)


# Packages
if false; then

apt-get update
apt-get upgrade --yes
apt-get install git-core espeak python-dev python-pip bison libasound2-dev libportaudio-dev python-pyaudio subversion autoconf libtool automake gfortran --yes

fi


# Configure (Raspberry Pi)
if false; then

sed "s/options snd-usb-audio index=-2/options snd-usb-audio index=0" /etc/modprobe.d/alsa-base.conf>/etc/modprobe.d/alsa-base.conf
alsa force-reload

echo 'export LD_LIBRARY_PATH="/usr/local/lib"
source .bashrc' >> ~/.bash_profile
echo 'LD_LIBRARY_PATH="/usr/local/lib"
export LD_LIBRARY_PATH
PATH=$PATH:/usr/local/lib/
export PATH' >> ~/.bashrc

fi



# Download

[ -f sphinxbase-0.8.tar.gz ] || wget http://downloads.sourceforge.net/project/cmusphinx/sphinxbase/0.8/sphinxbase-0.8.tar.gz
[ -f pocketsphinx-0.8.tar.gz ] || wget http://downloads.sourceforge.net/project/cmusphinx/pocketsphinx/0.8/pocketsphinx-0.8.tar.gz
[ -f openfst-1.3.3.tar.gz ] || wget http://www.openfst.org/twiki/pub/FST/FstDownload/openfst-1.3.3.tar.gz
#wget https://mitlm.googlecode.com/files/mitlm-0.4.1.tar.gz
#wget https://m2m-aligner.googlecode.com/files/m2m-aligner-1.2.tar.gz
#wget https://phonetisaurus.googlecode.com/files/phonetisaurus-0.7.8.tgz
#wget http://phonetisaurus.googlecode.com/files/g014b2b.tgz
#svn co https://svn.code.sf.net/p/cmusphinx/code/trunk/cmuclmtk/
[ -d jasper ] || git clone https://github.com/jasperproject/jasper-client.git jasper


# Unzip

[ -d sphinxbase-0.8 ] || tar zxf sphinxbase-0.8.tar.gz
[ -d pocketsphinx-0.8 ] || tar zxf pocketsphinx-0.8.tar.gz
[ -d cmuclmtk ] || tar zxf cmuclmtk-20150918-svn.tgz
[ -d m2m-aligner-1.2 ] || tar zxf m2m-aligner-1.2.tar.gz
[ -d openfst-1.3.3 ] || tar zxf openfst-1.3.3.tar.gz
[ -d phonetisaurus-0.7.8 ] || tar zxf phonetisaurus_0.7.8.tgz
[ -d mitlm-0.4.1 ] || tar zxf mitlm-0.4.1.tar.gz
[ -d g014b2b ] || tar zxf g014b2b.tgz


(
cd sphinxbase-0.8/
./configure --enable-fixed
make
make install
)

(
cd pocketsphinx-0.8/
./configure
make
make install
)

# reboot??

(
cd cmuclmtk/
./autogen.sh
make
make install
)

(
cd openfst-1.3.3/
./configure --enable-compact-fsts --enable-const-fsts --enable-far --enable-lookahead-fsts --enable-pdt
make install
)

(
cd m2m-aligner-1.2/
make
)

(
cd mitlm-0.4.1/
./configure
make install
)

(
cd phonetisaurus-0.7.8/src
make
)

cp m2m-aligner-1.2/m2m-aligner /usr/local/bin/m2m-aligner
cp phonetisaurus-0.7.8/phonetisaurus-g2p /usr/local/bin/phonetisaurus-g2p

(
cd g014b2b/
./compile-fst.sh
)

mv g014b2b phonetisaurus

pip install --upgrade setuptools
pip install -r jasper/client/requirements.txt

chmod 777 -R *

#reboot
