# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9,10} )

DISTUTILS_OPTIONAL=1

inherit python-r1

DESCRIPTION="Documentation reference for PyTorch."
HOMEPAGE="https://pytorch.org/docs"
PYTORCH_NAME=${PN:0:7}
REPO_URI="https://github.com/${PYTORCH_NAME}/${PYTORCH_NAME}"
SRC_URI="${REPO_URI}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"

DEPEND="
	${PYTHON_DEPS}
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	=sci-libs/pytorch-${PV}*[${PYTHON_USEDEP}]
	=sci-libs/torchvision-0.12*[${PYTHON_USEDEP}]
	dev-python/sphinxcontrib-katex[${PYTHON_USEDEP}]
	dev-python/pytorch-sphinx-theme[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/0001-Don-t-prerender-TeX-parts.patch"
	"${FILESDIR}/0002-Use-MAKE-environment-variable-instead-of-make.patch"
	"${FILESDIR}/1.7/Don-t-turn-Sphinx-warnings-into-errors.patch"
	"${FILESDIR}/1.9/Wrap-add_stylesheet-function-in-getattr.patch"
)

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}/${PYTORCH_NAME}-${PV}" "${S}" || die
}

src_compile() {
	local doc_build_dir="${S}/docs"
	cd "${doc_build_dir}" || die
	emake html-stable
}

src_install() {
	local doc_build_dir="${S}/docs"

	mkdir -p "${D}/usr/share/doc/${P}" || die
	cp -a "${doc_build_dir}/build/html" "${D}/usr/share/doc/${P}/html" || die
}
