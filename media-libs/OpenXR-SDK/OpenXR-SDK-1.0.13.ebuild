# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )

inherit git-r3 cmake python-single-r1

DESCRIPTION="OpenXR Software Development Kit"
HOMEPAGE="https://www.khronos.org/openxr/"
EGIT_REPO_URI="https://github.com/KhronosGroup/OpenXR-SDK"

CMAKE_BUILD_TYPE="Release"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	${DEPEND}
	dev-libs/jsoncpp
	dev-util/glslang
	media-libs/libglvnd
	media-libs/vulkan-loader
	x11-libs/libXext
	x11-libs/libX11
	x11-libs/libxcb
"

DEPEND="${RDEPEND}"
BDEPEND=""


