# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )

inherit git-r3 python-single-r1

DESCRIPTION="Client code for Jasper voice computing platform"
HOMEPAGE="https://jasperproject.github.io/"
EGIT_REPO_URI="https://github.com/jasperproject/jasper-client.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pocketsphinx julius flite festival"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

PATCHES=(
	"${FILESDIR}/${P}-use-python3.patch"
	"${FILESDIR}/${P}-fix-urlparse-import.patch"
	"${FILESDIR}/${P}-fix-mic-print.patch"
	"${FILESDIR}/${P}-fix-tts-long.patch"
	"${FILESDIR}/${P}-fix-client-imports.patch"
	"${FILESDIR}/${P}-fix-parse-requirements.patch"
	"${FILESDIR}/${P}-fix-queue.patch"
)

DEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/APScheduler[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
		dev-python/feedparser[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		dev-python/python-mpd[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
		dev-python/pyaudio[${PYTHON_USEDEP}]
		pocketsphinx? (
			dev-python/python-cmuclmtk[${PYTHON_USEDEP}]
		)
	')
	pocketsphinx? (
		app-accessibility/sphinxbase
		app-accessibility/pocketsphinx
	)
	festival? ( app-accessibility/festival )
	flite? ( app-accessibility/flite )
	julius? ( app-accessibility/julius )
"

# semantic
# cmuclmtk
# facebook-sdk

RDEPEND="${DEPEND}"
BDEPEND="${RDEPEND}"

src_install() {
	python_doexe jasper.py
	python_domodule client
	python_optimize
}
