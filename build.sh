set -e

# depends: gtk-doc

CUR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILD_DIR=$CUR_DIR/build
export PKG_CONFIG_PATH=$BUILD_DIR/lib/pkgconfig/:$BUILD_DIR/share/pkgconfig/:$PKG_CONFIG_PATH

mkdir -p $BUILD_DIR

git submodule update --init --recursive
git submodule foreach git clean -xffd

pushd util
./autogen.sh
./configure --prefix=$BUILD_DIR
make -j16 install
popd

pushd util-cursor
./autogen.sh
./configure --prefix=$BUILD_DIR
make -j16 install
popd

pushd util-keysyms
./autogen.sh
./configure --prefix=$BUILD_DIR
make -j16 install
popd

pushd util-wm
./autogen.sh
./configure --prefix=$BUILD_DIR
make -j16 install
popd

pushd libev
sh ./autogen.sh
./configure --prefix=$BUILD_DIR
make -j16 install
popd

pushd libxkbcommon
./autogen.sh
./configure --prefix=$BUILD_DIR
make -j16 install
popd

pushd startup-notification
./autogen.sh
./configure --prefix=$BUILD_DIR
make -j16 install
popd

pushd yajl
./configure --prefix $BUILD_DIR
make -j16 install
popd

pushd pango
./autogen.sh
./configure --prefix=$BUILD_DIR
make -j16 install
popd

pushd pixman
./autogen.sh
./configure --prefix=$BUILD_DIR
make -j16 install
popd

pushd cairo
./autogen.sh
./configure --prefix=$BUILD_DIR
make -j16 install
popd

pushd i3
make -j16 PREFIX=$BUILD_DIR install
popd