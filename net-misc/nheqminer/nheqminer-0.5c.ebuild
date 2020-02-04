# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils cmake-utils git-r3

DESCRIPTION="Nicehash Equihash Miner"
HOMEPAGE="https://www.nicehash.com/"
EGIT_REPO_URI="https://github.com/nicehash/nheqminer.git"
EGIT_TAG="0.5c"
LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"
DEPEND="
	acct-user/nicehash
	dev-libs/boost[static-libs]
	dev-lang/fasm
	>=dev-util/nvidia-cuda-toolkit-8
	<dev-util/nvidia-cuda-toolkit-9
"

src_compile() {
	sed -e "s|../${PN}/|../${P}/|" -i "${S}/CMakeLists.txt"
	fasm -m 1280000 "${S}/cpu_xenoncat/asm_linux/equihash_avx1.asm"
	fasm -m 1280000 "${S}/cpu_xenoncat/asm_linux/equihash_avx2.asm"
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	dobin "${S}_build/nheqminer"
	doinitd "${FILESDIR}/nicehash"
}

pkg_postinst() {
	elog
	elog "Remember to configure the server and bitcoin address"
	elog "as appropriate in /etc/init.d/nicehash"
	elog
	elog "To automatically start the daemon on boot run"
	elog "# rc-update add nicehash default"
	elog
}
