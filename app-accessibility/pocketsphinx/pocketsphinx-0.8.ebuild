# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

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

