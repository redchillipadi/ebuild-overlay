# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 cmake-utils

DESCRIPTION="Play hundreds of adventure games made with Adventure Game Studio"
HOMEPAGE="https://www.adventuregamestudio.co.uk/"
EGIT_REPO_URI="https://github.com/${PN}/ags.git"
EGIT_BRANCH="release-${PV}"
LICENSE="Artistic-2"
KEYWORDS="~amd64"
SLOT="0"

RDEPEND="
	<media-libs/allegro-5.0.11[vorbis,X]
	media-libs/libtheora
	media-libs/freetype
	media-libs/dumb
	media-libs/aldumb
	>=sys-devel/gcc-4.4.7:=
"

DEPEND="${RDEPEND}"

# These are marked as dependencies on the AGS web page, but are included
# as dependencies of the dependencies above
#media-libs/libogg
#media-libs/libvorbis
#x11-libs/libXxf86vm
#x11-libs/libXext

# Allegro 5 does not build as I am missing glXCreateContextAttribsARB
# I think is is included by mesa with other gfx cards, but not nvidia
# If allegro5 were made to build, then it might be possible to specifg
# USE flags dumb and truetype for allegro, and remove reliance on
# aldumb, dumb and freetype directly.

#src_compile() {
#	make --directory=Engine
#}

#src_install() {
#	make --directory=Engine install
#}
