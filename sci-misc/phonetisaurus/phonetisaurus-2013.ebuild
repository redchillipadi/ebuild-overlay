# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Phonetisaurus"
HOMEPAGE="http://code.google.com/p/phonetisaurus"
SRC_URI="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/phonetisaurus/is2013-conversion.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="<=sci-misc/openfst-1.3.4"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/is2013-conversion/phonetisaurus/src"

src_install() {
	exeinto /usr/bin
	doexe "${S}/../../bin/phonetisaurus-g2p"
}
