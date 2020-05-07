# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

PYTHON_COMPAT=( python{ 3_{6, 7, 8} )

DESCRIPTION="Universal Scene Description library"
HOMEPAGE="https://graphics.pixar.com/usd/docs/index.html"
SRC_URI="https://github.com/PixarAnimationStudios/USD/archive/v${PV}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc python imaging usdview glew openexr openimageio color-management osl ptex embree alembic draco test jemalloc"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	usdview? ( python )
	openimageio? ( imaging )
	color-management? ( imaging )
	embree? ( imaging )
"

DEPEND="
	dev-libs/boost[python]
	dev-cpp/tbb
	imaging? ( >=media-libs/opensubdiv-3.4.3 )
	glew? ( >=media-libs/glew-2.0.0 )
	openexr? ( media-libs/openexr )
	openimageio? ( media-libs/openimageio )
	color-management? ( media-libs/opencolorio )
	osl? ( media-libs/osl )
	ptex? ( media-libs/ptex )
	doc? ( app-doc/doxygen[dot] )
	embree? ( media-libs/embree )
	alembic? ( media-libs/alembic )
	draco? ( media-libs/draco )
	jemalloc? ( dev-libs/jemalloc )
"

#	usdview? (
#		( || ( pyslide-1.2.2, pyslide2-2.0.0-alpha0 / 5.14.1 ) )
#		>=dev-python/pyopengl-3.1.5[${PYTHON_USEDEP}]
#	)

RDEPEND="${DEPEND}"
BDEPEND=""


src_configure() {
        local mycmakeargs=(
		-DPXR_ENABLE_PYTHON_SUPPORT=$(usex python)
		-DPXR_USE_PYTHON_3=ON
		-DPXR_ENABLE_OSL_SUPPORT=$(usex osl)
		-DPXR_BUILD_DOCUMENTATION=$(usex doc)
		-DPXR_BUILD_IMAGING=$(usex imaging)
		-DPXR_ENABLE_PTEX_SUPPORT=$(usex ptex)
		-DPXR_BUILD_USD_IMAGING=$(usex usdview)
		-DPXR_BUILD_OPENIMAGEIO_PLUGIN=$(usex openimageio)
		-DPXR_BUILD_OPENCOLORIO_PLUGIN=$(usex color-management)
		-DPXR_BUILD_EMBREE_PLUGIN=$(usex embree)
		-DPXR_BUILD_ALEMBIC_PLUGIN=$(usex alembic)
		-DPXR_BUILD_DRACO_PLUGIN=$(usex draco)
		-DPXR_BUILD_TESTS=$(usex test)
		-DPXR_INSTALL_LOCATION=/opt/pxr
		-DPXR_LIB_PREFIX=/opt/pxr/lib
	)
	#-DPXR_MALLOC_LIBRARY:path=/usr/lib64/libjemalloc.so
	cmake-utils_src_configure
}

#src_install() {
#	#cmake-utils_src_install
#
#	#rm -rf "${D}/usr/cmake"
#	#rm -rf "${D}/usr/plugin"
#	#rm "${D}/usr/lib/*.so"
#	#rm -rf "${D}/usr/pxrConfig.cmake"
#
#	doheader -r "${S}_build/include/pxr"
#
#	dolib.so "${S}_build/pxr/base/arch/libarch.so"
#	dolib.so "${S}_build/pxr/base/gf/libgf.so"
#	dolib.so "${S}_build/pxr/base/js/libjs.so"
#	dolib.so "${S}_build/pxr/base/plug/libplug.so"
#	dolib.so "${S}_build/pxr/base/tf/libtf.so"
#	dolib.so "${S}_build/pxr/base/trace/libtrace.so"
#	dolib.so "${S}_build/pxr/base/vt/libvt.so"
#	dolib.so "${S}_build/pxr/base/work/libwork.so"
#	dolib.so "${S}_build/pxr/usd/ar/libar.so"
#	dolib.so "${S}_build/pxr/usd/kind/libkind.so"
#	dolib.so "${S}_build/pxr/usd/ndr/libndr.so"
#	dolib.so "${S}_build/pxr/usd/pcp/libpcp.so"
#	dolib.so "${S}_build/pxr/usd/sdf/libsdf.so"
#	dolib.so "${S}_build/pxr/usd/sdr/libsdr.so"
#	dolib.so "${S}_build/pxr/usd/usd/libusd.so"
#	dolib.so "${S}_build/pxr/usd/usdGeom/libusdGeom.so"
#	dolib.so "${S}_build/pxr/usd/usdHydra/libusdHydra.so"
#	dolib.so "${S}_build/pxr/usd/usdLux/libusdLux.so"
#	dolib.so "${S}_build/pxr/usd/usdMedia/libusdMedia.so"
#	dolib.so "${S}_build/pxr/usd/usdRender/libusdRender.so"
#	dolib.so "${S}_build/pxr/usd/usdRi/libusdRi.so"
#	dolib.so "${S}_build/pxr/usd/usdShade/libusdShade.so"
#	dolib.so "${S}_build/pxr/usd/usdSkel/libusdSkel.so"
#	dolib.so "${S}_build/pxr/usd/usdUI/libusdUI.so"
#	dolib.so "${S}_build/pxr/usd/usdUtils/libusdUtils.so"
#	dolib.so "${S}_build/pxr/usd/usdVol/libusdVol.so"
#
#	dobin "${S}_build/pxr/usd/bin/sdfdump/sdfdump"
#	dobin "${S}_build/pxr/usd/bin/sdffilter/sdffilter"
#}

