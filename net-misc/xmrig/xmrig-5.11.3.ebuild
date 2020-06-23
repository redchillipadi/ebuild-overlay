# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3 cmake

DESCRIPTION="RandomX, CryptoNight, AstroBWT and Argon2 CPU/GPU miner"
HOMEPAGE="https://xmrig.com/"
EGIT_REPO_URI="https://github.com/xmrig/xmrig.git"
EGIT_TAG="v${PV}"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
RESTRICT="test"
IUSE="hwloc opencl cuda"
DEPEND="
	hwloc? ( sys-apps/hwloc )
	opencl? ( virtual/opencl )
	cuda? ( dev-util/nvidia-cuda-toolkit )
"
PATCHES=(
	"${FILESDIR}/${P}-nodonations.patch"
)

src_configure() {
	local mycmakeargs=(
		-DWITH_LIBCPUID=ON
		-DWITH_HWLOC=$(usex hwloc)
		-DWITH_CN_LITE=ON
		-DWITH_CN_HEAVY=ON
		-DWITH_CN_PICO=ON
		-DWITH_RANDOMX=ON
		-DWITH_ARGON2=ON
		-DWITH_ASTROBWT=ON
		-DWITH_HTTP=ON
		-DWITH_DEBUG_LOG=OFF
		-DWITH_TLS=ON
		-DWITH_ASM=ON
		-DWITH_MSR=ON
		-DWITH_ENV_VARS=ON
		-DWITH_EMBEDDED_CONFIG=OFF
		-DWITH_OPENCL=$(usex opencl)
		-DWITH_CUDA=$(usex cuda)
		-DWITH_NVML=ON
		-DWITH_ADL=ON
		-DWITH_STRICT_CACHE=ON
		-DWITH_INTERLEAVE_DEBUG_LOG=OFF
		-DBUILD_STATIC=OFF
		-DARM_TARGET=0
		-DHWLOC_DEBUG=OFF
	)
	cmake_src_configure
}

src_install() {
	dobin "${S}_build/xmrig"
}
