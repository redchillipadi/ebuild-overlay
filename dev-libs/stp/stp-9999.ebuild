# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils cmake-utils git-r3

DESCRIPTION="An extension library for SFML2 designed to read the Tiled map format"
HOMEPAGE="https://edoren.github.io/STP"
EGIT_REPO_URI="https://github.com/edoren/STP.git"
LICENSE="MIT"
SLOT="0"
IUSE="doc"
DEPEND="app-arch/unzip
	media-libs/libsfml
	sys-libs/zlib
	dev-libs/pugixml
	doc? ( app-doc/doxygen )"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${P}-object_accessors.patch
	"${FILESDIR}"/${P}-documentation_folder.patch
)

src_configure() {
	mycmakeargs=(
		-DUSE_SHARED_PUGIXML:BOOL=ON
		-DUSE_SHARED_ZLIB:BOOL=ON
		-DSTP_BUILD_DOC=$(usex doc ON OFF)
	)

	cmake-utils_src_configure
}

src_install() {
	#install recursively (source)/include/STP/* into /usr/include/STP/
	mkdir -p ${D}/usr/include
	cp -r ${S}/include/STP ${D}/usr/include/

	#install (source)/README.md into /usr/share/doc/stp-9999/
	dodoc ${S}/README.md

	#install (workdir)/lib/libSTP.so into /usr/lib64/
	dolib.so ${S}_build/lib/libSTP.so
}
