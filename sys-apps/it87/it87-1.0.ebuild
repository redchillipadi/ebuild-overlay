# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 linux-mod

EGIT_REPO_URI="https://github.com/groeck/it87.git"
EGIT_COMMIT="v1.0"

RDEPEND="sys-apps/lm_sensors"
DEPEND="${RDEPEND}"
SLOT="0"

MODULE_NAMES="it87(drivers/hwmon,${S}/${P},${S})"
BUILD_TARGETS="clean modules"
