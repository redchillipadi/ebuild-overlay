# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DESCRIPTION="A cross playform 3d games engine"
HOMEPAGE="https://unity3d.com"
#SRC_URI="http://beta.unity3d.com/download/44012bad7987/UnitySetup -> UnitySetup-${PVR}"
SRC_URI="https://download.unity3d.com/download_unity/44012bad7987/LinuxEditorInstaller/Unity.tar.xz -> Unity-${PVR}.tar.xz"
LICENSE="Unity-Companion-License-1.2"
SLOT="0"
KEYWORDS="-* ~amd64"
S="${WORKDIR}/"
RDEPEND="
	gnome-base/gconf
"

#src_unpack() {
#	mkdir -p ${S}
#	cp ${DISTDIR}/UnitySetup-${PVR} ${S}/
#	chmod +x ${S}/UnitySetup-${PVR}
#}

#src_compile() {
#	yes | ${S}/UnitySetup-${PVR} --unattended --install-location=${S} --download-location=${DISTDIR} || die
#}

src_install() {
	dodir "/opt/Unity"
	cp -R "${S}/Editor" "${D}/opt/Unity/" || die "Install failed"
}
