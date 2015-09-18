#!/bin/bash

# https://gist.github.com/red-green/10587222

# Jasper install script (http://jasperproject.github.io/)
# Must be run as root (i.e. sudo setup.sh)

apt-get update
apt-get upgrade --yes
apt-get install vim git-core espeak python-dev python-pip bison libasound2-dev libportaudio-dev python-pyaudio subversion autoconf libtool automake gfortran --yes

sed "s/options snd-usb-audio index=-2/options snd-usb-audio index=0" /etc/modprobe.d/alsa-base.conf>/etc/modprobe.d/alsa-base.conf
alsa force-reload

echo 'export LD_LIBRARY_PATH="/usr/local/lib"
source .bashrc' >> ~/.bash_profile
echo 'LD_LIBRARY_PATH="/usr/local/lib"
export LD_LIBRARY_PATH
PATH=$PATH:/usr/local/lib/
export PATH' >> ~/.bashrc

wget http://downloads.sourceforge.net/project/cmusphinx/sphinxbase/0.8/sphinxbase-0.8.tar.gz
wget http://downloads.sourceforge.net/project/cmusphinx/pocketsphinx/0.8/pocketsphinx-0.8.tar.gz
tar -zxvf sphinxbase-0.8.tar.gz
tar -zxvf pocketsphinx-0.8.tar.gz

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

svn co https://svn.code.sf.net/p/cmusphinx/code/trunk/cmuclmtk/
(
cd cmuclmtk/
./autogen.sh
make
make install
)

wget http://www.openfst.org/twiki/pub/FST/FstDownload/openfst-1.3.3.tar.gz
#wget https://mitlm.googlecode.com/files/mitlm-0.4.1.tar.gz
#wget https://m2m-aligner.googlecode.com/files/m2m-aligner-1.2.tar.gz
#wget https://phonetisaurus.googlecode.com/files/phonetisaurus-0.7.8.tgz
#wget http://phonetisaurus.googlecode.com/files/g014b2b.tgz

tar -xvf m2m-aligner-1.2.tar.gz
tar -xvf openfst-1.3.3.tar.gz
tar -xvf phonetisaurus-0.7.8.tgz
tar -xvf mitlm-0.4.1.tar.gz
tar -xvf g014b2b.tgz

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

git clone https://github.com/jasperproject/jasper-client.git jasper
pip install --upgrade setuptools
pip install -r jasper/client/requirements.txt

chmod 777 -R *

reboot
