# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit check-reqs llvm

SLOT="0"
RESTRICT="fetch"
DESCRIPTION="A suite of integrated tools for game developers to design and build games"
HOMEPAGE="https://www.unrealengine.com/"
LICENSE=GPL-2
KEYWORDS="~amd64"
RDEPEND="
	<=sys-devel/clang-4.0.1:*
	|| (
		<=sys-devel/clang-4.0.1:4
		>=sys-devel/clang-3.5:0
	)
	dev-qt/qt-creator
	>=dev-lang/mono-3.2.8
	app-text/dos2unix
"
DEPEND="${RDEPEND}"

LLVM_MAX_SLOT=4

SRC_URI="https://github.com/EpicGames/UnrealEngine/archive/4.18.3-release.zip -> ${P}.zip"

S=${WORKDIR}/${P}-release

pkg_pretend() {
	CHECKREQS_DISK_BUILD="60G"
	check-reqs_pkg_setup
}

pkg_setup() {
	llvm_pkg_setup

	CHECKREQS_DISK_BUILD="60G"
	check-reqs_pkg_setup
}

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
	emake -j1 || die "emake failed"
}

src_install() {
	insinto /opt/UnrealEngine
	doins -r "${S}"/Engine
	doins -r "${S}"/FeaturePacks
	doins -r "${S}"/Samples
	doins -r "${S}"/Templates

	exeinto /opt/UnrealEngine/Engine/Binaries/Linux
	doexe "${S}"/Engine/Binaries/Linux/CrashReportClient
	doexe "${S}"/Engine/Binaries/Linux/ShaderCompileWorker
	doexe "${S}"/Engine/Binaries/Linux/UnrealLightmass
	doexe "${S}"/Engine/Binaries/Linux/UnrealFrontend
	doexe "${S}"/Engine/Binaries/Linux/UE4Editor
	doexe "${S}"/Engine/Binaries/Linux/UnrealCEFSubProcess
	doexe "${S}"/Engine/Binaries/Linux/UnrealHeaderTool
	doexe "${S}"/Engine/Binaries/Linux/UnreakPak

	insinto /usr/share/pixmaps
	newins "${S}"/Engine/Source/Programs/UnrealVS/Resources/Preview.png UE4Editor.png

	insinto /usr/share/applications
	doins "${FILESDIR}"/unreal-engine-4.desktop
}
