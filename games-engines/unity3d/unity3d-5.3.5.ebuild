# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils

BUILDTAG=20160525
PV_F=${PV}f1 # Workaround for that ugly f-revision
IUSE="ffmpeg nodejs java gzip android"
DESCRIPTION="Realtime creation platform for 2D and 3D games and applications."
HOMEPAGE="https://unity3d.com"
SRC_URI="http://download.unity3d.com/download_unity/linux/unity-editor-installer-${PV_F}+${BUILDTAG}.sh -> ${P}+${BUILDTAG}.sh"

LICENSE="Unity-Companion-License-1.2"
SLOT="0"
KEYWORDS="-* ~amd64" # Package is x86_64-only
RESTRICT="strip mirror"
RDEPEND="ffmpeg? ( media-video/ffmpeg )
	nodejs? ( net-libs/nodejs )
	java? ( virtual/jdk:* virtual/jre:* )
	android? ( dev-util/android-studio )
	gzip? ( app-arch/gzip )
	dev-util/desktop-file-utils
	x11-misc/xdg-utils
	sys-devel/gcc:*[multilib]
	virtual/opengl
	virtual/glu
	dev-libs/nss
	media-libs/libpng:*
	x11-libs/libXtst
	dev-libs/libpqxx
	dev-dotnet/mono-addins
	dev-dotnet/gconf-sharp
	net-libs/nodejs[npm]"

DEPEND="${RDEPEND}
	sys-apps/fakeroot"

S="${WORKDIR}/unity-editor-${PV_F}"
FILES="${S}/Files"

src_unpack() {
	yes | fakeroot sh "${DISTDIR}/${P}+${BUILDTAG}.sh" > /dev/null || die "Failed unpacking archive!"
}

src_prepare() {
	ln -s /usr/bin/python2 "${S}/Editor/python" # Fix WebGL building
	mkdir -p "${FILES}"
	cp -R "${FILESDIR}/*" "${FILES}/"
	sed -i "/^Version=/c\Version=${PV}" "${FILES}/unity-editor.desktop"
	sed -i "/^Version=/c\Version=${PV}" "${FILES}/unity-monodevelop.desktop"
	eapply_user # In case someone wants to patch .desktop files, for example
}

src_install() {
	# Install Unity3D itself
	insinto /opt/Unity
	doins -r "${S}/*"

	# Install .desktop launchers
	insopts "-Dm644"
	insinto /usr/share/applications
	doins "${FILES}/unity-editor.desktop"
	doins "${FILES}/unity-monodevelop.desktop"

	# Install icons
	insinto /usr/share/icons/hicolor/256x256/apps
	doins "${S}/unity-editor-icon.png"
	insinto /usr/share/icons/hicolor/48x48/apps
	doins "${FILES}/unity-monodevelop.png"

	# Install launch binaries
	insopts "-Dm755"
	insinto /usr/bin
	doins "${FILES}/unity-editor"
	doins "${FILES}/monodevelop-unity"

	fperms +x /opt/Unity/Editor/Unity
	fperms +x /opt/Unity/Editor/UnityHelper
	fperms 4755 /opt/Unity/Editor/chrome-sandbox
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	chmod 4755 /opt/Unity/Editor/chrome-sandbox

	gnome2_icon_cache_update
	ewarn "Please note that Unity3D requires closed-source"
	ewarn "graphics drivers to be used for now, as it makes"
	ewarn "use of OpenGL Compatibility profile. Please do"
	ewarn "not try to use the editor with Mesa3D - you will"
	ewarn "encounter tons of bugs & issues. Hang tight and"
	ewarn "hope that Unity3D guys will manage to add support"
	ewarn "for open-source drivers!"
}

pkg_postrm() {
	gnome2_icon_cache_update
}
