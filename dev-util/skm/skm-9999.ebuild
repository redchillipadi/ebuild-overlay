# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 cmake

DESCRIPTION="A beginner's all-purpose sofware toolkit"
HOMEPAGE="https://splashkit.io/"
EGIT_REPO_URI="https://github.com/splashkit/${PN}"

LICENSE="GPL"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	media-libs/libsdl2
	media-libs/sdl2-gfx
	media-libs/sdl2-mixer
	media-libs/sdl2-ttf
	media-libs/sdl2-net
	media-libs/sdl2-image
	sys-libs/ncurses
	media-libs/libpng
	net-misc/curl[openssl]
	media-libs/flac
	media-libs/libvorbis
	media-libs/libmikmod
	media-libs/freetype
	app-arch/bzip2
	media-libs/libwebp
"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${P}/source"

src_install() {
	dodoc "${WORKDIR}/${P}/README.MD"

	exeinto "/opt/splashkit"
	doexe "${WORKDIR}/${P}/skm"

	dolib.so "${WORKDIR}/${P}_build/libSplashKit.so"

	rm -rf "${WORKDIR}/${P}/clang++/lib/macos"
	rm -rf "${WORKDIR}/${P}/clang++/lib/win32"
	rm -rf "${WORKDIR}/${P}/clang++/lib/win64"
	rm -rf "${WORKDIR}/${P}/g++/lib/macos"
	rm -rf "${WORKDIR}/${P}/g++/lib/win32"
	rm -rf "${WORKDIR}/${P}/g++/lib/win64"
	mkdir -p "${ED}/opt/splashkit"
	IFS=' ' read -ra COMMANDS <<< "fix help linux resources tools clang++ fpc install-scripts linux new source update dotnet g++ python3"
	for CMD in "${COMMANDS[@]}"
	do
		cp -r "${WORKDIR}/${P}/${CMD}" "${ED}/opt/splashkit"
	done

#	mv "${S}/include" "${S}/splashkit"
#	doheader -r "${S}/splashkit"
}
