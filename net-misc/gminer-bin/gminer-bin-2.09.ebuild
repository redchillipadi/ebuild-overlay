# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A closed source cryptocurrency miner for NVIDIA and AMD GPUs"
HOMEPAGE="https://cryptomining-blog.com/11895-new-gminer-2-07-with-a-performance-boost-for-the-cuckatoo32-algorithm/"
SRC_URI="https://github.com/develsoftware/GMinerRelease/releases/download/${PV}/gminer_2_09_linux64.tar.xz -> ${P}.tar.xz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
S="${WORKDIR}"

src_install() {
	dobin miner
}
