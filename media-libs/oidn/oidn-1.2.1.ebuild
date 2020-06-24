# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="Intel Open Image Denoise Library"
HOMEPAGE="http://www.openimagedenoise.org/"
EGIT_REPO_URI="https://github.com/OpenImageDenoise/oidn.git"
EGIT_TAG="v${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-cpp/tbb
	>=dev-lang/ispc-1.12.0
"
DEPEND="${RDEPEND}"

RESTRICT="test"

src_unpack() {
	git-r3_src_unpack
	tar xf "${FILESDIR}/${P}-weights.tar.xz"
	cmake_src_unpack
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE="Release"
	)
	cmake_src_configure
}
