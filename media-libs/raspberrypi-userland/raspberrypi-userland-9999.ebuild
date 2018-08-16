# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit cmake-utils flag-o-matic git-r3

DESCRIPTION="Raspberry Pi userspace tools and libraries"
HOMEPAGE="https://github.com/raspberrypi/userland"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="media-libs/mesa[egl,gles1,gles2]"
RDEPEND=""

EGIT_REPO_URI="https://github.com/raspberrypi/userland"

PATCHES=( "${FILESDIR}"/${P}-compile-arm64.patch )

pkg_setup() {
	append-ldflags $(no-as-needed)
}

src_configure() {
	local mycmakeargs=(
		-DVMCS_INSTALL_PREFIX="/usr"
	)
#		-DCMAKE_BUILD_TYPE="Release"
#		-DARM64=ON

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	insinto /lib/udev/rules.d
	doins "${FILESDIR}"/92-local-vchiq-permissions.rules

	dodir /usr/share/doc/${PF}
	mv "${D}"/usr/src/hello_pi "${D}"/usr/share/doc/${PF}/
	rmdir "${D}"/usr/src

	# Don't overwrite the newer versions provided by mesa
	rm -rf "${D}/usr/include/GLES"
	rm -rf "${D}/usr/include/GLES2"
	rm -rf "${D}/usr/include/EGL"
	rm -rf "${D}/usr/include/KHR"
}
