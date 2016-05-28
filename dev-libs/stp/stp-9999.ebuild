# Copyright 1999-2016 Adrian Grigo <agrigo2001@yahoo.com.au>
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils cmake-utils git-r3

DESCRIPTION="An extension library for SFML2 designed to read the Tiled map format"
HOMEPAGE="https://edoren.github.io/STP"
EGIT_REPO_URI="git://github.com/edoren/STP.git"
LICENSE="MIT"
SLOT="0"
IUSE="doc"
DEPEND="app-arch/unzip
	media-libs/libsfml
	sys-libs/zlib
	dev-libs/pugixml
	doc? ( app-doc/doxygen )"
KEHWORDS="~amd64 ~x86"
RESTRICT="test"

src_prepare() {
  epatch "${FILESDIR}/${P}-object_accessors.patch"
  epatch "${FILESDIR}/${P}-documentation_folder.patch"
  cmake-utils_src_prepare
}

src_configure() {
  mycmakeargs=(
    "-DUSE_SHARED_PUGIXML:BOOL=ON"
    "-DUSE_SHARED_ZLIB:BOOL=ON"
    `cmake-utils_use doc STP_BUILD_DOC`
  )

  cmake-utils_src_configure
}
