# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="design system for interactive fiction"
HOMEPAGE="https://inform7.com"
SRC_URI="http://inform7.com/apps/6M62/I7_6M62_Linux_all.tar.gz"
LICENSE="Artistic-2 Inform"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm ~ppc ~x86"
S="${WORKDIR}/inform7-6M62"
DOCS="share/doc/${PN}/README share/doc/${PN}/ChangeLogs"
RESTRICT="strip"

src_prepare()
{
	local MY_ARCH="error"
	case "${ARCH}" in
		"amd64") MY_ARCH="x86_64" ;;
		"x86") MY_ARCH="i386" ;;
		"arm") MY_ARCH="armv6lfh" ;;
		"ppc") MY_ARCH="ppc" ;;
		*) die "Binaries for your architecture are not available" ;;
	esac

	local INFORM_COMMON="${PN}-common_6M62_all.tar.gz"
	local INFORM_COMPILERS="${PN}-compilers_6M62_${MY_ARCH}.tar.gz"
	local INFORM_INTERPRETERS="${PN}-interpreters_6M62_${MY_ARCH}.tar.gz"

	tar xzf ${INFORM_COMMON} || die
	tar xzf ${INFORM_COMPILERS} || die
	tar xzf ${INFORM_INTERPRETERS} || die

	eapply "${FILESDIR}/${P}-adjust-prefix.patch"
	eapply_user
}

src_install() {
	dobin bin/i7

	doman man/*/*

	dodir "/usr/share/${PN}"
	cp -R share/${PN}/* "${D}/usr/share/${PN}/"

	dosym "../share/${PN}/Compilers/cBlorb" "/usr/libexec/cBlorb"
	dosym "../share/${PN}/Compilers/inform6" "/usr/libexec/inform6"
	dosym "../share/${PN}/Compilers/intest" "/usr/libexec/intest"
	dosym "../share/${PN}/Compilers/ni" "/usr/libexec/ni"
	dosym "../share/${PN}/Interpreters/dumb-frotz" "/usr/libexec/dumb-frotz"
	dosym "../share/${PN}/Interpreters/dumb-git" "/usr/libexec/dumb-git"
	dosym "../share/${PN}/Interpreters/dumb-glulxe" "/usr/libexec/dumb-glulxe"

	dodoc -r ${DOCS}
}
