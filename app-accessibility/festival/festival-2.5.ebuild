# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils multilib toolchain-funcs

MY_PV="${PV}.0-release"
MY_P=${PN}-${MY_PV}

DESCRIPTION="Festival Text to Speech engine"
HOMEPAGE="http://www.cstr.ed.ac.uk/projects/festival/"
SITE="http://www.festvox.org/packed/${PN}/${PV}"
SRC_URI="${SITE}/${MY_P}.tar.gz
	${SITE}/festlex_CMU.tar.gz
	${SITE}/festlex_OALD.tar.gz
	${SITE}/festlex_POSLEX.tar.gz
	${SITE}/speech_tools-${MY_PV}.tar.gz
	${SITE}/voices/festvox_cmu_indic_ben_rm_cg.tar.gz
	${SITE}/voices/festvox_cmu_indic_guj_ad_cg.tar.gz
	${SITE}/voices/festvox_cmu_indic_guj_dp_cg.tar.gz
	${SITE}/voices/festvox_cmu_indic_guj_kt_cg.tar.gz
	${SITE}/voices/festvox_cmu_indic_hin_ab_cg.tar.gz
	${SITE}/voices/festvox_cmu_indic_kan_plv_cg.tar.gz
	${SITE}/voices/festvox_cmu_indic_mar_aup_cg.tar.gz
	${SITE}/voices/festvox_cmu_indic_mar_slp_cg.tar.gz
	${SITE}/voices/festvox_cmu_indic_pan_amp_cg.tar.gz
	${SITE}/voices/festvox_cmu_indic_tam_sdr_cg.tar.gz
	${SITE}/voices/festvox_cmu_indic_tel_kpn_cg.tar.gz
	${SITE}/voices/festvox_cmu_indic_tel_sk_cg.tar.gz
	${SITE}/voices/festvox_cmu_indic_tel_ss_cg.tar.gz
	${SITE}/voices/festvox_cmu_us_aew_cg.tar.gz
	${SITE}/voices/festvox_cmu_us_ahw_cg.tar.gz
	${SITE}/voices/festvox_cmu_us_aup_cg.tar.gz
	${SITE}/voices/festvox_cmu_us_awb_cg.tar.gz
	${SITE}/voices/festvox_cmu_us_axb_cg.tar.gz
	${SITE}/voices/festvox_cmu_us_bdl_cg.tar.gz
	${SITE}/voices/festvox_cmu_us_clb_cg.tar.gz
	${SITE}/voices/festvox_cmu_us_eey_cg.tar.gz
	${SITE}/voices/festvox_cmu_us_fem_cg.tar.gz
	${SITE}/voices/festvox_cmu_us_gka_cg.tar.gz
	${SITE}/voices/festvox_cmu_us_jmk_cg.tar.gz
	${SITE}/voices/festvox_cmu_us_ksp_cg.tar.gz
	${SITE}/voices/festvox_cmu_us_ljm_cg.tar.gz
	${SITE}/voices/festvox_cmu_us_lnh_cg.tar.gz
	${SITE}/voices/festvox_cmu_us_rms_cg.tar.gz
	${SITE}/voices/festvox_cmu_us_rxr_cg.tar.gz
	${SITE}/voices/festvox_cmu_us_slp_cg.tar.gz
	${SITE}/voices/festvox_cmu_us_slt_cg.tar.gz
	${SITE}/voices/festvox_kallpc16k.tar.gz
	${SITE}/voices/festvox_rablpc16k.tar.gz"

LICENSE="FESTIVAL HPND BSD rc regexp-UofT free-noncomm"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="
	acct-user/festival
	~app-accessibility/speech-tools-2.5
	>=sys-libs/ncurses-5.6-r2
"

RDEPEND="${DEPEND}
	media-sound/alsa-utils
"

BDEPEND="${RDEPEND}"

S=${WORKDIR}/festival

src_prepare() {
	# tell festival to use the speech-tools we have installed.
	sed -i -e "s:\(EST=\).*:\1${EPREFIX}/usr/share/speech-tools:" "${S}"/config/config.in
	sed -i -e "s:\$(EST)/lib:/usr/$(get_libdir):" "${S}"/config/project.mak

	# fix the reference  to /usr/lib/festival
	sed -i -e "s:\(FTLIBDIR.*=.*\)\$.*:\1${EPREFIX}/usr/share/festival:" "${S}"/config/project.mak

	# Fix path for examples in festival.scm
	sed -i -e "s:\.\./examples/:${EPREFIX}/usr/share/doc/${PF}/examples/:" "${S}"/lib/festival.scm

	epatch "${FILESDIR}/${PN}-2.1-ldflags.patch"
	epatch "${FILESDIR}/${PN}-2.1-init-scm.patch"
	epatch "${FILESDIR}/${PN}-2.1-gentoo-system.patch"

	# copy what we need for MultiSyn from speech_tools.
	cp -pr "${WORKDIR}"/speech_tools/base_class "${S}"/src/modules/MultiSyn

	epatch "${FILESDIR}/${P}-gcc4.7.patch"

	echo "(Parameter.set 'Audio_Command \"aplay -q -c 1 -t raw -f s16 -r \$SR \$FILE\")" >> "${S}"/lib/siteinit.scm
	echo "(Parameter.set 'Audio_Method 'Audio_Command)" >> "${S}"/lib/siteinit.scm
}

src_configure() {
	econf || die "econf failed"
}

src_compile() {
	emake -j1 PROJECT_LIBDEPS="" REQUIRED_LIBDEPS="" LOCAL_LIBDEPS="" \
		OPTIMISE_CXXFLAGS="${CXXFLAGS}" OPTIMISE_CCFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CC="$(tc-getCC)" CXX="$(tc-getCXX)" || die "emake failed"
}

src_install() {
	# Install the binaries
	dobin src/main/festival
	dobin lib/etc/*Linux*/audsp
	dolib.a src/lib/libFestival.a

	# Install the main libraries
	insinto /usr/share/festival
	doins -r lib/*

	# Install the examples
	insinto /usr/share/doc/${PF}
	doins -r examples

	# Need to fix saytime, etc. to look for festival in the correct spot
	for ex in "${D}"/usr/share/doc/${PF}/examples/*.sh; do
		exnoext=${ex%%.sh}
		chmod a+x "${exnoext}"
		sed "s:${S}/bin/festival:/usr/bin/festival:" "${exnoext##$D}"
	done

	# Install the header files
	insinto /usr/include/festival
	doins src/include/*.h

	insinto /etc/festival
	doins lib/site*

	# Install the docs
	dodoc "${S}"/{ACKNOWLEDGMENTS,NEWS,README}
	doman "${S}"/doc/{festival.1,festival_client.1}

	# create the directory where our log file will go.
	diropts -m 0755 -o festival -g audio
	keepdir /var/log/festival
}

pkg_postinst() {
	elog
	elog "    Useful examples include saytime, text2wave. For example, try:"
	elog "        \"/usr/share/doc/${PF}/examples/saytime\""
	elog
	elog "    Or for something more fun:"
	elog '        "echo "Gentoo can speak" | festival --tts"'
	elog
	elog "This version also allows configuration of site specific"
	elog "initialization in /etc/festival/siteinit.scm and"
	elog "variables in /etc/festival/sitevars.scm."
	elog
}
