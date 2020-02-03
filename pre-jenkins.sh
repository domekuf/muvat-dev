set -e

export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

if [ -x /usr/bin/scl_enabled -a -x /usr/bin/scl ]
then
	/usr/bin/scl_enabled devtoolset-6 || exec /usr/bin/scl enable devtoolset-6 "$0 $@"
fi

make -j7 $@
