# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils git-r3 toolchain-funcs flag-o-matic

DESCRIPTION="Command line media player for the Raspberry Pi"
HOMEPAGE="https://github.com/popcornmix/omxplayer"
EGIT_REPO_URI="https://github.com/popcornmix/omxplayer.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="X"

RDEPEND="dev-libs/libpcre
	media-fonts/freefont
	|| ( media-libs/raspberrypi-userland media-libs/raspberrypi-userland-bin )
	sys-apps/dbus
	sys-apps/fbset
	virtual/ffmpeg
	dev-libs/boost
	media-libs/freetype:2
	X? (
		x11-apps/xrefresh
		x11-apps/xset
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	eapply "${FILESDIR}/fonts-path.patch"
	eapply "${FILESDIR}/${P}-makefile.patch"
	eapply "${FILESDIR}/${P}-64bit-size-fixes.patch"
	eapply_user

	cat > Makefile.include << EOF
LIBS=-lvchiq_arm -lvcos -lbcm_host -lEGL -lGLESv2 -lopenmaxil -lrt -lpthread
EOF

	tc-export CXX
}

src_compile() {
	emake omxplayer.bin
}

src_install() {
	dobin omxplayer omxplayer.bin
	dodoc README.md
}
