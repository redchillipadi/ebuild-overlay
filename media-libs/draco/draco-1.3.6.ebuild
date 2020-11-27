# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Library for compressing and decompressing 3D geometric objects"
HOMEPAGE="https://google.github.io/draco/"
SRC_URI="https://github.com/google/draco/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+compat +gltf"
RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${P}-0001-CMakeLists.txt-respect-library-dirs.patch"
)

DOCS=( AUTHORS CONTRIBUTING.md README.md )

src_configure() {
	local mycmakeargs=(
		-DBUILD_ANIMATION_ENCODING=OFF
		-DBUILD_FOR_GLTF=$(usex gltf)
		-DBUILD_SHARED_LIBS=ON
		-DEMSCRIPTEN=OFF
		-DENABLE_BACKWARDS_COMPATIBILITY=$(usex compat)
		-DENABLE_DECODER_ATTRIBUTE_DEDUPLICATION=ON
		-DENABLE_EXTRA_SPEED=OFF
		-DENABLE_EXTRA_WARNINGS=ON
		-DENABLE_MESH_COMPRESSION=ON
		-DENABLE_POINT_CLOUD_COMPRESSION=ON
		-DENABLE_PREDICTIVE_EDGEBREAKER=ON
		-DENABLE_STANDARD_EDGEBREAKER=ON
		-DENABLE_TESTS=OFF
		-DENABLE_WERROR=OFF
		-DENABLE_WEXTRA=ON
	)

	cmake_src_configure
}

