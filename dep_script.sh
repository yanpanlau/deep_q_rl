#!/bin/bash

#echo "==>dependencies setup for deep_q_rl"

#echo "==>updating current package..."
#sudo apt-get update

#echo "==>installing OpenCV..."
#sudo apt-get install python-opencv

#echo "==>installing Matplotlib..."
#sudo apt-get install python-matplotlib python-tk

echo "==>installing Theano ..."
# some dependencies ...
sudo apt-get install python-numpy python-scipy python-dev python-pip python-nose g++ libopenblas-dev git
pip install --user --upgrade --no-deps git+git://github.com/Theano/Theano.git

echo "==>installing Lasagne ..."
pip install --user --upgrade https://github.com/Lasagne/Lasagne/archive/master.zip

# Packages below this point require downloads. 
mkdir build
cd build

if [ ! -d "./pylearn2" ]
then
echo "==>installing Pylearn2 ..."
# dependencies...
sudo apt-get install libyaml-0-2 python-six
git clone git://github.com/lisa-lab/pylearn2
fi
cd ./pylearn2
python setup.py develop --user
cd ..

if [ ! -d "./ALE" ]
then
echo "==>installing ALE ..."

# dependencies ...
sudo apt-get install libsdl1.2-dev libsdl-gfx1.2-dev libsdl-image1.2-dev cmake

git clone --recursive https://github.com/nadavbh12/Arcade-Learning-Environment-2.0.git ALE
mkdir cores
cd ./ALE
cd stella-libretro; make -j; cd ..; echo "stella compiled";
cd snes9x-next; make -j; cd ..; echo "snes9x compiled";
cmake -DUSE_SDL=ON -DUSE_RLGLUE=OFF -DBUILD_EXAMPLES=OFF .
make -j 4
export CFLAGS='-std=c++11'
pip install --user .
cp stella-libretro/stella_libretro.so ../../cores/
cp snes9x-next/snes9x_next_libretro.so ../../cores/
cd ..
fi

echo "==>All done!"
