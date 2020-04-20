# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit git-r3 distutils-r1

DESCRIPTION="Wrapper library for accessing the language model tools for CMU Sphinx (CMUCLMTK)"
HOMEPAGE="https://jasperproject.github.io/"
EGIT_REPO_URI="https://github.com/Holzhaus/python-cmuclmtk.git"
EGIT_TAGS="v${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="app-accessibility/sphinx3"

DEPEND=""
BDEPEND=""
