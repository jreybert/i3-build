set -e

# depends:
# gtkdocize (Fedora gtk-doc)
# gperf 
# docbook2pdf (Fedora docbook-utils-pdf)
# ragel

for bin in gtkdocize gperf docbook2pdf ragel; do
    type $bin >/dev/null 2>&1 || { echo >&2 "$bin is necessary, install it."; exit 1; }
done


CUR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILD_DIR=$CUR_DIR/build
export PKG_CONFIG_PATH=$BUILD_DIR/lib/pkgconfig/:$BUILD_DIR/share/pkgconfig/:$PKG_CONFIG_PATH

mkdir -p $BUILD_DIR

git submodule update --init --recursive
git submodule foreach git clean -xffd

function autogen_util {
    ACLOCAL="aclocal -I $BUILD_DIR/share/aclocal/" ./autogen.sh
}

pushd macros
./autogen.sh
./configure --prefix=$BUILD_DIR
make -j16 install
popd

pushd util
autogen_util
./configure --prefix=$BUILD_DIR
make -j16 install
popd

pushd util-renderutil
autogen_util
./configure --prefix=$BUILD_DIR
make -j16 install
popd

pushd util-image
autogen_util
./configure --prefix=$BUILD_DIR
make -j16 install
popd

# depends image
pushd util-cursor
autogen_util
./configure --prefix=$BUILD_DIR
make -j16 install
popd

pushd util-keysyms
autogen_util
./configure --prefix=$BUILD_DIR
make -j16 install
popd

pushd util-wm
autogen_util
./configure --prefix=$BUILD_DIR
make -j16 install
popd

pushd libev
sh ./autogen.sh
./configure --prefix=$BUILD_DIR
make -j16 install
popd

pushd proto
autogen_util
./configure --prefix=$BUILD_DIR
make -j16 install
popd

pushd libxcb
autogen_util
./configure --prefix=$BUILD_DIR
make -j16 install
popd

pushd libxkbcommon
autogen_util
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

pushd fontconfig
./autogen.sh
./configure --prefix=$BUILD_DIR
make -j16 install
popd

pushd freetype2
./autogen.sh
./configure --prefix=$BUILD_DIR
make -j16 install
popd

pushd harfbuzz
./autogen.sh
./configure --prefix=$BUILD_DIR
make -j16 install
popd

pushd pango
./autogen.sh
./configure --prefix=$BUILD_DIR
make -j16 install-data
popd

wget "http://downloads.sourceforge.net/project/pcre/pcre/8.38/pcre-8.38.tar.bz2"
tar xjf pcre-8.38.tar.bz2
rm pcre-8.38.tar.bz2
pushd pcre-8.38
./configure --prefix=$BUILD_DIR
make -j16 install
popd

pushd i3
make -j16 PREFIX=$BUILD_DIR install
popd
