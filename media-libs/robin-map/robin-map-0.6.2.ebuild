# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 cmake-utils

DESCRIPTION="A C++ implementation of a fast hash map and hash set using robin hood hashing"
HOMEPAGE="https://github.com/Tessil/robin-map"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~ppc64 ~x86"

EGIT_REPO_URI="https://github.com/Tessil/${PN}"
EGIT_COMMIT="v${PV}"
