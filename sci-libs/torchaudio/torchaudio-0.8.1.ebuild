# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1 git-r3

DESCRIPTION="An audio library for PyTorch"
HOMEPAGE="https://github.com/pytorch/audio"
SRC_URI="https://github.com/pytorch/audio/archive/v${PV}.tar.gz -> ${P}.tar.gz"

EGIT_REPO_URI="https://github.com/pytorch/${PN//torch/}"
EGIT_COMMIT="v${PV}"
EGIT_SUBMODULES=(
	'*'
)

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"

IUSE=""

REQUIRED_USE=""

DEPEND="
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	=sci-libs/pytorch-1.8.1[python]
	media-sound/sox
"
RDEPEND="${DEPEND}"
