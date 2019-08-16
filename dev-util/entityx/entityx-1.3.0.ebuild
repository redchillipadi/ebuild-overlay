# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils cmake-utils git-r3

DESCRIPTION="A fast, type-safe c++ entity component system"
HOMEPAGE="https://github.com/alecthomas/entityx"
EGIT_REPO_URI="https://github.com/alecthomas/entityx.git"
EGIT_COMMIT="1.3.0"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

src_configure() {
	CMAKE_USE_DIR="${S}"
	cmake-utils_src_configure
}
