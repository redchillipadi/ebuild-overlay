# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit cmake-utils python-single-r1 flag-o-matic

DESCRIPTION="Universal Scene Description"
HOMEPAGE="https://graphics.pixar.com/usd/docs/index.html"
SRC_URI="https://github.com/PixarAnimationStudios/${PN}/archive/v${PV}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE="doc python imaging usdview glew openexr openimageio color-management osl ptex embree alembic hdf5 draco test jemalloc"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	usdview? ( python )
	openimageio? (
		imaging
	)
	color-management? ( imaging )
	embree? ( imaging )
	hdf5? ( alembic )
	test? ( python )
"

RDEPEND="
	dev-cpp/tbb
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-libs/boost:=[python,${PYTHON_MULTI_USEDEP}]
			usdview? (
				dev-python/pyside2[${PYTHON_MULTI_USEDEP}]
				>=dev-python/pyopengl-3.1.5[${PYTHON_MULTI_USEDEP}]
			)
		')
	)
	imaging? ( >=media-libs/opensubdiv-3.4.3 )
	glew? ( >=media-libs/glew-2.0.0 )
	openexr? ( media-libs/openexr )
	openimageio? ( media-libs/openimageio:= )
	color-management? ( media-libs/opencolorio )
	osl? ( media-libs/osl )
	ptex? ( media-libs/ptex )
	doc? ( app-doc/doxygen[dot] )
	embree? ( =media-libs/embree-2.16.4 )
	alembic? ( media-gfx/alembic )
	hdf5? (
		media-gfx/alembic[hdf5]
		sci-libs/hdf5[hl]
	)
	draco? ( media-libs/draco )
	jemalloc? ( dev-libs/jemalloc )
"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

CMAKE_BUILD_TYPE=Release


PATCHES=(
	"${FILESDIR}/${P}-fix-cmake-openexr-multilib.patch"
	"${FILESDIR}/${P}-fix-cmake-boost-python.patch"
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	default

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DCMAKE_INSTALL_PREFIX=/opt/usd
		-DPXR_BUILD_ALEMBIC_PLUGIN=$(usex alembic)
		-DPXR_BUILD_DOCUMENTATION=$(usex doc)
		-DPXR_BUILD_DRACO_PLUGIN=$(usex draco)
		-DPXR_BUILD_EMBREE_PLUGIN=$(usex embree)
		-DPXR_BUILD_IMAGING=$(usex imaging)
		-DPXR_BUILD_MONOLITHIC=ON
		-DPXR_BUILD_OPENCOLORIO_PLUGIN=$(usex color-management)
		-DPXR_BUILD_OPENIMAGEIO_PLUGIN=$(usex openimageio)
		-DPXR_BUILD_TESTS=$(usex test)
		-DPXR_BUILD_USD_IMAGING=$(usex usdview)
		-DPXR_BUILD_USD_TOOLS=OFF
		-DPXR_ENABLE_HDF5_SUPPORT=$(usex hdf5)
		-DPXR_ENABLE_OSL_SUPPORT=$(usex osl)
		-DPXR_ENABLE_PTEX_SUPPORT=$(usex ptex)
		-DPXR_ENABLE_PYTHON_SUPPORT=$(usex python)
		-DPXR_SET_INTERNAL_NAMESPACE=usdBlender
		-DPXR_USE_PYTHON_3=ON
	)

	if use jemalloc; then
		mycmakeargs+=( -DPXR_MALLOC_LIBRARY:path=/usr/lib64/libjemalloc.so )
	fi

	cmake-utils_src_configure
}
