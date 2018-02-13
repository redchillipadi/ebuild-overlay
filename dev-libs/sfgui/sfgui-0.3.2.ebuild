# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils cmake-utils git-r3

DESCRIPTION="Simple and Fast Graphical User Interface"
HOMEPAGE="http://sfgui.sfml-dev.de/"
EGIT_REPO_URI="https://github.com/TankOs/SFGUI.git"
EGIT_COMMIT="0.3.2"
LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"
DEPEND="media-libs/libsfml
	virtual/opengl
"
PATCHES=(
	"${FILESDIR}/sfgui-0.3.2-widgets-dos2unix.patch"
	"${FILESDIR}/sfgui-0.3.2-listbox.patch"
)
