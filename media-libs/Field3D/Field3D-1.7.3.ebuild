# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A library for storing voxel data"
HOMEPAGE="http://opensource.imageworks.com/?p=field3d"
SRC_URI="https://github.com/imageworks/Field3D/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc mpi"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	dev-libs/boost:=
	media-libs/ilmbase:=
	sci-libs/hdf5:=
	mpi? ( virtual/mpi )
"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DINSTALL_DOCS=$(usex doc)
		-DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=ON
		$(cmake_use_find_package mpi MPI)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc; then
		doxygen "${S}/Field3D.doxyfile"
	fi
}

src_install() {
	cmake_src_install
	einstalldocs

	if use doc; then
		dodoc -r "${S}/docs"
	fi

}
