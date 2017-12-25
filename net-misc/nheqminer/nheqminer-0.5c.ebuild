# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils cmake-utils git-r3

DESCRIPTION="Nicehash Equihash Miner"
HOMEPAGE="https://www.nicehash.com/"
EGIT_REPO_URI="https://github.com/nicehash/nheqminer.git"
EGIT_TAG="0.5c"
LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"
DEPEND="dev-libs/boost[static-libs]
	dev-lang/fasm
	>=dev-util/nvidia-cuda-toolkit-8.0
"

src_compile() {
  sed -e "s|../${PN}/|../${P}/|" -i ${S}/CMakeLists.txt
  fasm -m 1280000 ${S}/cpu_xenoncat/asm_linux/equihash_avx1.asm
  fasm -m 1280000 ${S}/cpu_xenoncat/asm_linux/equihash_avx2.asm
  cmake-utils_src_compile
}
