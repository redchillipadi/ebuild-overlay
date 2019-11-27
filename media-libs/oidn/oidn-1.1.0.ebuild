# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Intel Open Image Denoise Library"
HOMEPAGE="http://www.openimagedenoise.org/"
SRC_URI="https://github.com/OpenImageDenoise/oidn/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-cpp/tbb"
DEPEND="${RDEPEND}"

RESTRICT="test"
