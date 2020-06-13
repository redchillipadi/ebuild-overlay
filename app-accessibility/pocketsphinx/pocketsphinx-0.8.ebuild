# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
DISTUTILS_OPTIONAL=1
AUTOTOOLS_AUTORECONF=1
inherit autotools-utils distutils-r1

DESCRIPTION="Pocketsphinx library used by the Sphinx Speech Recognition Engine"
HOMEPAGE="http://cmusphinx.sourceforge.net/"
SRC_URI="mirror://sourceforge/cmusphinx/${P}.tar.gz"

LICENSE="BSD-2 HPND MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	app-accessibility/sphinxbase"
DEPEND="${RDEPEND}"
BDEPEND="${RDEPEND}"

AUTOTOOLS_IN_SOURCE_BUILD=1

src_configure() {
	local myeconfargs=(
		# python modules are built through distutils
		# so disable the ugly wrapper
		--without-python
	)
	autotools-utils_src_configure
}

run_distutils() {
	pushd python > /dev/null || die
	distutils-r1_"${@}"
	popd > /dev/null || die
}

src_compile() {
	autotools-utils_src_compile

	run_distutils ${FUNCNAME}
}

python_test() {
	LD_LIBRARY_PATH="${S}"/src/lib${PN}/.libs \
		"${PYTHON}" sb_test.py || die "Tests fail with ${EPYTHON}"
}

src_test() {
	autotools-utils_src_test

	run_distutils ${FUNCNAME}
}

src_install() {
	run_distutils ${FUNCNAME}

	autotools-utils_src_install
}
