# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
SLOT="0"
RESTRICT="fetch"
DESCRIPTION="A suite of integrated tools for game developers to design and build games"
HOMEPAGE="https://www.unrealengine.com/"
LICENSE=GPL-2
KEYWORDS="~amd64"
RDEPEND="
	<=sys-devel/clang-4.0.1:*
	dev-qt/qt-creator
	>=dev-lang/mono-3.2.8
	app-text/dos2unix
"
DEPEND="${RDEPEND}"

SRC_URI="https://github.com/EpicGames/UnrealEngine/archive/4.18.3-release.zip -> ${P}.zip"

S=${WORKDIR}/${P}-release

pkg-nofetch() {
	einfo "Please create an account with EpicGames to download"
	einfo "  - https://github.com/EpicGames/UnrealEngine/archive/4.18.3-release.zip"
	einfo "and save it as ${P}.zip in your DISTDIR directory."
}

src_configure() {
	./Setup.sh
	./GenerateProjectFiles.sh
}

src_compile() {
	emake UE4Editor-Linux-Debug || die "emake failed"
}

src_install() {
	insinto /opt/UnrealEngine
	doins -r ${S}/Engine
	doins -r ${S}/FeaturePacks
	doins -r ${S}/Samples
	doins -r ${S}/Templates
}
