# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils

DESCRIPTION="Flat Assembler - an open source assembly language compiler"
HOMEPAGE="https://flatassembler.net/"
SRC_URI="https://flatassembler.net/${P}.tgz"
LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"
DEPEND=""
S="${WORKDIR}/${PN}"

src_compile() {
	"${S}/fasm" "${S}/source/Linux/fasm.asm"
	"${S}/fasm.x64" "${S}/source/Linux/x64/fasm.asm"
}

src_install() {
	dobin "${S}/source/Linux/fasm"
	newbin "${S}/source/Linux/x64/fasm fasm.x64"
}
