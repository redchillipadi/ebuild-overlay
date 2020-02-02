# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )
inherit cmake python-single-r1

DESCRIPTION="A library for reading and writing images"
HOMEPAGE="https://sites.google.com/site/openimageio/ https://github.com/OpenImageIO"
SRC_URI="https://github.com/OpenImageIO/oiio/archive/RB-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/2.1"
KEYWORDS="~amd64 ~ppc64 ~x86"

X86_CPU_FEATURES=(
	sse2:sse2 sse3:sse3 ssse3:ssse3 sse4_1:sse4.1 sse4_2:sse4.2
	avx:avx avx2:avx2 avx512f:avx512f f16c:f16c
)
CPU_FEATURES=( ${X86_CPU_FEATURES[@]/#/cpu_flags_x86_} )

IUSE="color-management dicom doc ffmpeg field3d gif heif jpeg2k libressl opencv opengl openvdb openvdb_abi_5 openvdb_abi_6 openvdb_abi_7 ptex python qt5 raw ssl +truetype ${CPU_FEATURES[@]%:*}"
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	openvdb? ( || ( openvdb_abi_5 openvdb_abi_6 openvdb_abi_7 ) )
	openvdb_abi_5? ( openvdb )
	openvdb_abi_6? ( openvdb )
	openvdb_abi_7? ( openvdb )
"

RESTRICT="test" # bug 431412

BDEPEND="
	doc? ( app-doc/doxygen[latex] )
"
RDEPEND="
	dev-libs/boost:=
	dev-libs/pugixml:=
	dev-python/pybind11
	media-libs/ilmbase:=
	media-libs/libpng:0=
	>=media-libs/libwebp-0.2.1:=
	media-libs/openexr:=
	media-libs/robin-map
	media-libs/tiff:0=
	sys-libs/zlib:=
	virtual/jpeg:0
	color-management? ( >=media-libs/opencolorio-1.1.1:= )
	dicom? ( sci-libs/dcmtk )
	ffmpeg? ( media-video/ffmpeg:= )
	field3d? ( media-libs/Field3D:= )
	gif? ( media-libs/giflib:0= )
	heif? ( media-libs/libheif:= )
	jpeg2k? ( media-libs/openjpeg:= )
	opencv? ( media-libs/opencv:= )
	opengl? (
		media-libs/glew:=
		virtual/glu
		virtual/opengl
	)
	openvdb? (
		>=media-gfx/openvdb-5.2.0:=[-openvdb_abi_3,-openvdb_abi_4,openvdb_abi_5=,openvdb_abi_6=,openvdb_abi_7=]
		dev-cpp/tbb
	)
	ptex? ( media-libs/ptex:= )
	python? (
		${PYTHON_DEPS}
		dev-libs/boost:=[python,${PYTHON_USEDEP}]
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		opengl? ( dev-qt/qtopengl:5 )
	)
	raw? ( media-libs/libraw:= )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	truetype? ( media-libs/freetype:2= )
"
DEPEND="${RDEPEND}"

DOCS=( CHANGES.md CREDITS.md README.md src/doc/${PN}.pdf )

PATCHES=( "${FILESDIR}/${PN}-2.0-find-pybind11.patch" )

S="${WORKDIR}/oiio-RB-${PV}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	cmake_comment_add_subdirectory src/fonts

	# Cheap hack to get version with ABIFLAGS
	local abiver=$(cd "/usr/include"; echo python*)
	for python in ${abiver}
	do
		sed -i "/find_path (PYBIND11_INCLUDE_DIR pybind11\/pybind11.h/a           HINTS \"/usr/include/${python}\"" "${S}/src/cmake/modules/FindPybind11.cmake"
	done

	sed -i "s/BUILDDIR :=.*/BUILDDIR := ..\/..\/..\/${P}_build/" "${S}/src/doc/Makefile"
}

src_configure() {
	# Build with SIMD support
	local cpufeature
	local mysimd=()
	for cpufeature in "${CPU_FEATURES[@]}"; do
		use "${cpufeature%:*}" && mysimd+=("${cpufeature#*:}")
	done

	# If no CPU SIMDs were used, completely disable them
	[[ -z ${mysimd} ]] && mysimd=("0")

	openvdb_version=0
	if use openvdb_abi_5; then
		openvdb_version=5
	elif use openvdb_abi_6; then
		openvdb_version=6
	elif use openvdb_abi_7; then
		openvdb_version=7
	fi
	[ openvdb_version > 0 ] || die "Openvdb ABI version not specified"
	append-cppflags -DOPENVDB_ABI_VERSION_NUMBER="${openvdb_version}"

	local mycmakeargs=(
		-DBUILD_DOCS=$(usex doc)
		-DINSTALL_DOCS=$(usex doc)
		-DOIIO_BUILD_TESTS=OFF # as they are RESTRICTed
		-DSTOP_ON_WARNING=OFF
		-DUSE_EXTERNAL_PUGIXML=ON
		-DUSE_JPEGTURBO=ON
		-DUSE_NUKE=NO # Missing in Gentoo
		-DUSE_NUKE=OFF
		-DUSE_OCIO=$(usex color-management)
		-DUSE_DICOM=$(usex dicom)
		-DUSE_FFMPEG=$(usex ffmpeg)
		-DUSE_FIELD3D=$(usex field3d)
		-DUSE_GIF=$(usex gif)
		-DUSE_HEIF=$(usex heif)
		-DUSE_OPENJPEG=$(usex jpeg2k)
		-DUSE_OPENCV=$(usex opencv)
		-DUSE_OPENGL=$(usex opengl)
		-DUSE_PTEX=$(usex ptex)
		-DUSE_PYTHON=$(usex python)
		-DUSE_QT=$(usex qt5)
		-DUSE_LIBRAW=$(usex raw)
		-DUSE_OPENSSL=$(usex ssl)
		-DUSE_OPENVDB=$(usex openvdb)
		-DUSE_FREETYPE=$(usex truetype)
		-DUSE_SIMD=$(local IFS=','; echo "${mysimd[*]}")
	)

	cmake_src_configure
}
