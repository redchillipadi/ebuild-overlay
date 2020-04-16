# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_6,3_7,3_8} )

inherit git-r3 python-single-r1

DESCRIPTION="Client code for Jasper voice computing platform"
HOMEPAGE="https://jasperproject.github.io/"
EGIT_REPO_URI="https://github.com/jasperproject/jasper-client.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-python/APScheduler
	dev-python/mock
	dev-python/pytz
	dev-python/pyyaml
	dev-python/requests
	dev-python/beautifulsoup:4
	dev-python/feedparser
	dev-python/python-dateutil
	dev-python/python-mpd
"

# argparse
# semantic
# cmuclmtk
# facebook-sdk

RDEPEND="${DEPEND}"
BDEPEND=""
