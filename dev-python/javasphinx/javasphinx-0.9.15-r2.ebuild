# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{6..11} pypy{,3} )

DISTUTILS_USE_SETUPTOOLS="rdepend"
inherit distutils-r1 pypi

DESCRIPTION="Sphinx extension for documenting Java projects"
HOMEPAGE="https://github.com/bronto/javasphinx"
SRC_URI="$(pypi_sdist_url)"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-solaris"

RDEPEND="
	>=dev-python/javalang-0.10.1[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
	dev-python/future[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/namespace-sphinxcontrib[${PYTHON_USEDEP}]"

# avoid circular dependency with sphinx
PDEPEND="
	>=dev-python/sphinx-1.5.3"

DEPEND="
	${RDEPEND}
	${PDEPEND}"

PATCHES=(
	"${FILESDIR}/Fix-l_-command-as-per-recent-Sphinx-changes.patch"
)
