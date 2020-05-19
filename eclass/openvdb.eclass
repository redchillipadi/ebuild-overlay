# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: openvdb.eclass
# @MAINTAINER:
# Adrian Grigo <agrigo2001@yahoo.com.au>
# @ AUTHOR:
# Author: Adrian Grigo <agrigo2001@yahoo.com.au>
# Based on work of: Michał Górny <mgorny@gentoo.org> and Krzysztof Pawlik <nelchael@gentoo.org>
# @SUPPORTED_EAPIS: 5 6 7
# @BLURB: An eclass for OpenVDB to control which ABI version is compiled
# @DESCRIPTION:
# The OpenVDB package is a library for sotring and manipulating sparse
# data structures with dynamic topology as required for use in volume
# rendering for computer graphics.
#
# Each major version of OpenVDB provides an updated ABI, as well as
# the ability to support legacy versions of the ABI. For example
# Openvdb 7 can be compiled to support version 5, 6 or 7 of the ABI.
#
# However the user needs to choose at compile time which version to
# build. It is not possible to support multiple versions concurrently.
# If it were possible to provide mutliple SLOTS for OpenVDB then
# this eclass may not be required.
#
# Currently OpenVDB and all packages depending upon it must be
# built for the same ABI version. This currently means blender, but
# will soon include OpenImageIO and USD. Houdini also has strict
# requirements, should an ebuild be introduced for it.
#
# The client packages have differing requirements for the ABI support.
# For example, Houdini-17 only supports ABI 5, and Houdini-18 only
# supports ABI 6. Blender supports ABI 4-7.
#
# This eclass allows the user to specify which ABI of OpenVDB to
# compile on the system by an OPENVDB_ABI variable.
#
# Each client package can specify the version of the ABI it supports
# in a list in the OPENVDB_COMPAT variable.
#
# When the client package includes OpenVDB as a dependency, it can use
# the OPENVDB_SINGLE_USEDEP variable that this package exports to
# enforce the correct version of OpenVDB to be compiled
# eg. openvdb? ( media-gfx/openvdb[${OPENVDB_SINGLE_USEDEP}] )
# The variable evaluates to openvdb_abi_X when OPENVDB_ABI="X"
#
# It can specify to the build system the ABI version as follows:
# append-cppflags -DOPENVDB_ABI_VERSION_NUMBER="${OPENVDB_ABI}"
#
# The package includes pkg_setup which ensures that the package will
# only compile if OPENVDB_ABI matches one in OPENVDB_COMPAT
#
# @EXAMPLE:
# The user needs to choose which version of the ABI supports all packages
# they plan to install. This is then stored in a variable in make.conf
# eg. OPENVDB_ABI="5" in /etc/portage/make.conf
#
# The OpenVDB package has USE flags for openvdb_abi_X for each version
# it supports. It allows only one to be selected by making use of
# OPENVDB_REQUIRED_USE
#
# The client packages need to:
# - inherit this eclass.
# - list the ABI supported by the package in OPENVDB_COMPAT.
# - include OPENVDB_SINGLE_USEDEP in RDEPEND
# - pass the OPENVDB_ABI_VERSION to the package build system
#
# @CODE
# inherit openvdb
# OPENVDB_COMPAT=( 4 5 6 7 )
# REQUIRED_USE="openvdb? ( ${OPENVDB_REQUIRED_USE} )"
# RDEPEND="openvdb? ( media-gfx/openvdb[${OPENVDB_SINGLE_USEDEP}] )"
#
# src_configure() {
#   append-cppflags -DOPENVDB_ABI_VERSION_NUMBER="${OPENVDB_ABI_VERSION}"
#   ...
#   cmake-utils_src_configure
# }
# @CODE

case "${EAPI:-0}" in
	0|1|2|3|4)
		die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}"
		;;
	5|6|7)
		# EAPI=5 is required for sane USE_EXPAND dependencies
		;;
	*)
		die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
		;;
esac

EXPORT_FUNCTIONS pkg_setup

# @ECLASS-VARIABLE: OPENVDB_COMPAT
# @REQUIRED
# @DESCRIPTION:
# This variable contains a list of OpenVDB ABI the package supports.
# It must be set before the 'inherit' call and has to be an array.
#
# Example use:
# @CODE
# OPENVDB_COMPAT=( 4 5 6 7 )
# @CODE
#

# @ECLASS-VARIABLE: OPENVDB_SINGLE_USEDEP
# @DESCRIPTION:
# This is an eclass generated USE-dependency flag which can be used by
# any package depending on openvdb to ensure the correct ABI version
# support is built.
#
# Example use:
# @CODE
# RDEPEND="openvdb? ( media-gfx/openvdb[${OPENVDB_SINGLE_USEDEP}] )"
# @CODE

# @ECLASS-VARIABLE: OPENVDB_REQUIRED_USE
# @DESCRIPTION:
# This is an eclass-generated required use expression which ensures
# that exactly one openvdb_use_X value has been enabled.
#
# The expression should be utilized by media-gfx/openvdb ebuild only
# by adding it to REQUIRED_USE. It is not required in the client
# packages
#
# Example use:
# @CODE
# REQUIRED_USE="${OPENVDB_REQUIRED_USE}"
# @CODE
#
# Example value:
# @CODE
# ^^ ( openvdb_abi_3 openvdb_abi_4 openvdb_abi_5 openvdb_abi_6 openvdb_abi_7)
# @CODE

# @ECLASS-VARIABLE: OPENVDB_ABI_VERSION
# @DESCRIPTION:
# This is an eclass generated variable which returns the ABI version
# selected in OPENVDB_ABI, allowing it to be passed to the build system
#
# Example use:
# @CODE
# src_configure() {
#   append-cppflags -DOPENVDB_ABI_VERSION_NUMBER="${OPENVDB_ABI_VERSION}"
#   ...
#   cmake-utils_src_configure
# }
# @CODE
#
# Example value (when OPENVDB_ABI="5"):
# @CODE
# 5
# @CODE

# @ECLASS-VARIABLE: _OPENVDB_ALL_ABI
# @INTERNAL
# @DESCRIPTION:
# All supported OpenVDB ABI
# Update this with each new major version release of OpenVDB
_OPENVDB_ALL_ABI=(
	3 4 5 6 7
)
readonly _OPENVDB_ALL_ABI

_openvdb_set_globals() {
	local i

	if ! declare -p OPENVDB_COMPAT &>/dev/null; then
		die 'OPENVDB_COMPAT not declared.'
	fi
	if [[ $(declare -p OPENVDB_COMPAT) != "declare -a"* ]]; then
		die 'OPENVDB_COMPAT must be an array.'
	fi

	if [[ ${#OPENVDB_ABI[@]} -ne 1 ]]; then
		die "OPENVDB_ABI must be set to a single ABI version from ${_OPENVDB_ALL_ABI[*]}"
	fi

	unset openvdb_version
	openvdb_version=5
	#for i in "${_OPENVDB_ABI[@]}"; do
	#	if has "openvdb_abi_${i}" "${USE}"; then
	#		if [[ ${openvdb_version} ]]; then
	#			die "More than one openvdb_abi_X USE flag set."
	#		fi
	#	fi
	#done
	if [[ ! ${openvdb_version} ]]; then
		die "No OpenVDB ABI Version selected for the system. Please set OPENVDB_ABI."
	fi

	if ! has "${openvdb_version}" "${_OPENVDB_ALL_ABI[@]}"; then
		die "OPENVDB_ABI ${openvdb_version} is not one of ${_OPENVDB_ALL_ABI[*]}"
	fi

	if ! has "${openvdb_version}" "${OPENVDB_COMPAT[@]}"; then
		die "This package does not support OpenVDB ABI ${openvdb_version} in OPENVDB_COMPAT"
	fi

	local required=()
	for i in "${_OPENVDB_ABI[@]}"; do
		required+="openvdb_abi_${i}"
	done

	OPENVDB_REQUIRED_USE="^^ ( ${required[*]} )"
	OPENVDB_SINGLE_USEDEP="openvdb_abi_${openvdb_version}(+)"
	OPENVDB_ABI_VERSION="${openvdb_version}"
	readonly OPENVDB_REQUIRED_USE OPENVDB_SINGLE_USEDEP OPENVDB_ABI_VERSION
}
_openvdb_set_globals
unset -f _openvdb_set_globals

if [[ ! ${_OPENVDB} ]]; then

# @FUNCTION: openvdb_setup
# @DESCRIPTION
# Ensure one and only one OpenVDB ABI version is selected
openvdb_setup() {
	debug-print-function ${FUNCNAME} "${@}"

	eerror "Setup: OPENVDB_ABI is ${OPENVDB_ABI}"

	unset EOPENVDB

	local i
	for i in "${_OPENVDB_ABI[@]}"; do
		if use "openvdb_abi_${i}"; then
			if [[ ${EOPENVDB} ]]; then
				eerror "Your OPENVDB_ABI setting lists more than a single OpenVDB"
				eerror "ABI version. Please set it to just one value."
				echo
				die "More than one ABI in OPENVDB_ABI."
			fi
		fi
		einfo "Using OpenVDB ABI ${EOPENVDB} to build"
	done

	if [[ ! ${EOPENVDB} ]]; then
		eerror "No OpenVDB ABI Version selected for the system. Please set"
		eerror "the OPENVDB_ABI variable in your make.conf to one"
		eerror "of the values contained in all of:"
		eerror
		eerror "- the entire list of ABI: ${_OPENVDB_ALL_ABI[*]}"
		eerror "- the ABI supported by this package: ${OPENVDB_COMPAT}"
		eerror "- and the ABI supported by all other packages on your system"
		echo
		die "No supported OpenVDB ABI version in OPENVDB_ABI."
	fi
}

# @FUNCTION: openvdb_pkg_setup
# @DESCRIPTION:
# Runs openvdb_setup.
openvdb_pkg_setup() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${MERGE_TYPE} != binary ]] && openvdb_setup
}

_OPENVDB=1
fi
