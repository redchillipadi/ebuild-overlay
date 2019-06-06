# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Play hundreds of adventure games made with Adventure Game Studio"
HOMEPAGE="https://www.adventuregamestudio.co.uk/"
SRC_URI="https://github.com/adventuregamestudio/ags/archive/v.3.4.3.1.tar.gz"
LICENSE="Artistic-2"
KEYWORDS="~amd64"
SLOT="0"
S="${WORKDIR}/ags-v.${PV}/Engine"

RDEPEND="
	>=sys-devel/gcc-4.4.7:=
	<media-libs/allegro-5.0.11[vorbis,X]
	media-libs/libtheora
	media-libs/freetype
	media-libs/dumb
	media-libs/aldumb
"

DEPEND="${RDEPEND}"

# These are marked as dependencies on the AGS web page, but are included
# as dependencies of the dependencies above
#media-libs/libogg
#media-libs/libvorbis
#x11-libs/libXxf86vm
#x11-libs/libXext

src_install() {
	dobin	ags
}
