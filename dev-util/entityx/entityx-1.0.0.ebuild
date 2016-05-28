# Copyright 2016 Adrian Grigo <agrigo2001@yahoo.com.au>
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils cmake-utils git-r3

DESCRIPTION="A fast, type-safe c++ entity component system"
HOMEPAGE="https://github.com/alecthomas/entityx"
EGIT_REPO_URI="git://github.com/alecthomas/entityx.git"
LICENSE="MIT"
SLOT="0"
KEHWORDS="~amd64 ~x86"
RESTRICT="test"

src_prepare() {
  cmake-utils_src_prepare
}

src_configure() {
  CMAKE_USE_DIR="${S}"
  cmake-utils_src_configure
}


