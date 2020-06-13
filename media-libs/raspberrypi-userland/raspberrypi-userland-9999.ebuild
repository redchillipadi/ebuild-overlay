# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake flag-o-matic git-r3

DESCRIPTION="Raspberry Pi userspace tools and libraries"
HOMEPAGE="https://github.com/raspberrypi/userland"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="arm64"

DEPEND=""
RDEPEND=""

EGIT_REPO_URI="https://github.com/raspberrypi/userland"

pkg_setup() {
	append-ldflags $(no-as-needed)
}

src_configure() {
	local mycmakeargs=(
		-DVMCS_INSTALL_PREFIX="/opt/vc"
		-DARM64=$(usex arm64)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	insinto /lib/udev/rules.d
	doins "${FILESDIR}"/92-local-vchiq-permissions.rules

	dodir /usr/share/doc/${PF}
	mv "${D}"/usr/src/hello_pi "${D}"/usr/share/doc/${PF}/
	rmdir "${D}"/usr/src
}
