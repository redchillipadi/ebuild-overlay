# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils git-r3

DESCRIPTION="A 2d physics library"
HOMEPAGE="http://box2d.org/"
EGIT_REPO_URI="https://github.com/erincatto/Box2D.git"
LICENSE="ZLIB"
SLOT="0"
DEPEND="app-arch/unzip
	dev-util/premake:5"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

src_prepare() {
	eapply_user
	premake5 gmake
}

src_configure() {
	make -C Build
}

src_install() {
	mkdir -p ${D}/usr/include/
	cp -r "${S}/Box2D" "${D}/usr/include/"
	find "${D}/usr/include/Box2D/" -type f -name "*.cpp" -exec rm '{}' \;
	dodoc -r ${S}/Documentation
	dolib.a ${S}/Build/bin/x86_64/Debug/libBox2D.a
}
