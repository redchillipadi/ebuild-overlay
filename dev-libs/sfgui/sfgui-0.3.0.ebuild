# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils cmake git-r3

DESCRIPTION="Simple and Fast Graphical User Interface"
HOMEPAGE="http://sfgui.sfml-dev.de/"
EGIT_REPO_URI="https://github.com/TankOs/SFGUI.git"
EGIT_COMMIT="0.3.0"
LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"
DEPEND="media-libs/libsfml virtual/opengl"
