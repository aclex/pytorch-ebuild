# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9,10} )

inherit distutils-r1

DESCRIPTION="Sphinx theme for PyTorch Docs and PyTorch Tutorials"
HOMEPAGE="https://github.com/pytorch/pytorch_sphinx_theme"
COMMIT="f7c46fdc6630b66d597b661dbbe2c88b4a95328f"
SRC_URI="https://github.com/pytorch/pytorch_sphinx_theme/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

RDEPEND="dev-python/sphinx[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND} dev-python/setuptools[${PYTHON_USEDEP}]"

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}/${PN//-/_}-${COMMIT}" "${S}"
}
