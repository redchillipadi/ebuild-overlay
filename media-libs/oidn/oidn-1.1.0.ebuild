# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils git-r3

DESCRIPTION="Intel Open Image Denoise Library"
HOMEPAGE="http://www.openimagedenoise.org/"
EGIT_REPO_URI="https://github.com/OpenImageDenoise/oidn.git"
EGIT_TAG="v${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-cpp/tbb"
DEPEND="${RDEPEND}"

RESTRICT="test"

src_configure() {
        local mycmakeargs=(
                -DCMAKE_BUILD_TYPE="Release"
        )
        cmake-utils_src_configure
}

