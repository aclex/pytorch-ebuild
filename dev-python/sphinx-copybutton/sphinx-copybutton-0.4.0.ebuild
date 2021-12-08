# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Add a copy button to each of your code cells"
HOMEPAGE="https://github.com/executablebooks/sphinx-copybutton"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"

DEPEND="
	${PYTHON_DEPS}
	>=dev-python/sphinx-1.8[${PYTHON_USEDEP}]
"
