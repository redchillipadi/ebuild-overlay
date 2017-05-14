# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils cmake-utils wxwidgets

DESCRIPTION="A tool for viewing OGRE mesh files"
HOMEPAGE="https://www.ogre3d.org/tikiwiki/Ogre+Meshy"
SRC_URI="https://downloads.sourceforge.net/project/${PN}/${PV}%20%28Ogre%201.9.0%29/OgreMeshy.${PV}.src.tar.bz2"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"
IUSE="cg"

RDEPEND="
	dev-games/ogre[cg=]
	x11-libs/libX11
	<x11-libs/wxGTK-3.0
"
DEPEND="${RDEPEND}"


S="${WORKDIR}/OgreMeshy"

PATCHES=(
	${FILESDIR}/${P}-add-x11-library.patch
)

# Note that the plugin libraries may be prestripped, as they are copies of those created by Ogre

# Also note that we install into /opt in order to keep the Resources and Plugins out of /usr/bin
# (these need to be in the same directory as the binary)

src_configure() {
	mkdir -p "${S}/bin/Release_Linux/Resources/Fonts"
	mkdir -p "${S}/bin/Release_Linux/Resources/Models"
	mkdir -p "${S}/bin/Release_Linux/Resources/Icons/32x32"
	mkdir -p "${S}/bin/Release_Linux/Plugins"

	cp -r "${S}/scripts/Resources/Icons/32x32" "${S}/bin/Release_Linux/Resources/Icons/"
	cp -r "${S}/scripts/Resources/Fonts" "${S}/bin/Release_Linux/Resources/"
	cp -r "${S}/scripts/Resources/Other/Grid.material" "${S}/bin/Release_Linux/Resources/Models/"
	cp -r "${S}/scripts/Resources/Other/Grid.png" "${S}/bin/Release_Linux/Resources/Models/"
	cp "${S}/scripts/Resources/Blender/Axis.material" "${S}/bin/Release_Linux/Resources/Models/"
	cp "${S}/scripts/Resources/Blender/Axis.mesh" "${S}/bin/Release_Linux/Resources/Models/"
	cp "${S}/scripts/Resources/Blender/Bones/BoneMesh.material" "${S}/bin/Release_Linux/Resources/Models/"
	cp "${S}/scripts/Resources/Blender/Bones/Bones.png" "${S}/bin/Release_Linux/Resources/Models/"
	cp "${S}/scripts/Resources/Blender/Bones/BoneTip.mesh" "${S}/bin/Release_Linux/Resources/Models/"
	cp "${S}/scripts/Resources/Blender/Bones/BoneGlobe.mesh" "${S}/bin/Release_Linux/Resources/Models/"
	cp "${S}/bin/Release/{Readme,ChangeLog}.txt" "${S}/bin/Release_Linux/"


	CMAKE_USE_DIR="${S}"
	cmake-utils_src_configure
}

src_install() {
	dodir "/opt/${PN}"

	exeinto "/opt/${PN}"
	doexe "${BUILD_DIR}/OgreMeshy"
	dosym "/opt/${PN}/OgreMeshy" /usr/bin/OgreMeshy

	insinto "/opt/${PN}"
	doins "${S}/bin/Release_Linux/Plugins.cfg"

	dodir "/opt/${PN}/Resources"
	mv "${S}/bin/Release_Linux/Resources/Fonts" "${ED}/opt/${PN}/Resources/" || die
	mv "${S}/bin/Release_Linux/Resources/Icons" "${ED}/opt/${PN}/Resources/" || die
	mv "${S}/bin/Release_Linux/Resources/Models" "${ED}/opt/${PN}/Resources/" || die

	dodir "/opt/${PN}/Plugins"
	insinto "/opt/${PN}/Plugins"
	if use cg; then
		doins /usr/lib/OGRE/Plugin_CgProgramManager.so
	fi
	doins /usr/lib/OGRE/Plugin_ParticleFX.so*
	doins /usr/lib/OGRE/Plugin_OctreeSceneManager.so*
	doins /usr/lib/OGRE/RenderSystem_GL.so*
}
