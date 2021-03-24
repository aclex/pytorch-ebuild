# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

DISTUTILS_OPTIONAL=1

inherit cmake distutils-r1

DESCRIPTION="Datasets, Transforms and Models specific to Computer Vision"
HOMEPAGE="https://github.com/pytorch/vision"
SRC_URI="https://github.com/pytorch/vision/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"

IUSE="cuda ffmpeg +python"

REQUIRED_USE="ffmpeg? ( python )"

DEPEND="
	virtual/jpeg
	media-libs/libpng
	cuda? ( dev-util/nvidia-cuda-toolkit:0= )
	ffmpeg? ( virtual/ffmpeg )
	python? (
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		>=dev-python/pillow-4.1.1[${PYTHON_USEDEP}]
	)
	=sci-libs/pytorch-1.8.0[python?,cuda?]
"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}/${P//torch/}" "${S}"
}

src_configure() {
	local mycmakeargs=(
		-DTORCH_INSTALL_PREFIX=/usr
	)

	cmake_src_configure

	if use python; then
		FORCE_CUDA=$(usex cuda 1 0) \
		CUDA_HOME=$(usex cuda ${CUDA_HOME} "") \
		NO_FFMPEG=$(usex ffmpeg 0 1) \
		distutils-r1_src_configure
	fi
}

src_compile() {
	cmake_src_compile

	if use python; then
		addpredict /dev/nvidiactl
		FORCE_CUDA=$(usex cuda 1 0) \
		CUDA_HOME=$(usex cuda ${CUDA_HOME} "") \
		NO_FFMPEG=$(usex ffmpeg 0 1) \
		MAKEOPTS="-j1" \
		distutils-r1_src_compile
	fi
}

src_install() {
	cmake_src_install

	if use python; then
		FORCE_CUDA=$(usex cuda 1 0) \
		CUDA_HOME=$(usex cuda ${CUDA_HOME} "") \
		NO_FFMPEG=$(usex ffmpeg 0 1) \
		distutils-r1_src_install
	fi
}
