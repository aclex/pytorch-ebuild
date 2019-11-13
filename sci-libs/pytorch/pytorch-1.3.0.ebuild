# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )

DISTUTILS_OPTIONAL=1

inherit distutils-r1 cmake-utils git-r3 python-r1

DESCRIPTION="An open source machine learning framework that accelerates the path from research prototyping to production deployment."
HOMEPAGE="https://pytorch.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

EGIT_REPO_URI="https://github.com/${PN}/${PN}"
EGIT_BRANCH="v${PV}"
EGIT_SUBMODULES=(
	'*'
	'-third_party/protobuf'
	'-third_party/ios-cmake'
	'-third_party/gflags'
	'-third_party/glog'
	'-third_party/googletest'
#	'-third_party/tbb'
)

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="asan cuda doc +fbgemm ffmpeg gflags glog +gloo leveldb lmdb mkl +mkldnn mpi namedtensor +nnpack numa +numpy +observers opencl opencv +openmp +python +qnnpack redis rocm static tbb test tools zeromq"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	numpy? ( python )
"

DEPEND="
	cuda? ( dev-util/nvidia-cuda-toolkit:0= )
	doc? ( dev-python/pytorch-sphinx-theme )
	ffmpeg? ( virtual/ffmpeg )
	gflags? ( dev-cpp/gflags )
	glog? ( dev-cpp/glog )
	leveldb? ( dev-libs/leveldb )
	lmdb? ( dev-db/lmdb )
	mkl? ( sci-libs/mkl )
	mpi? ( virtual/mpi )
	numpy? ( dev-python/numpy )
	opencl? ( virtual/opencl )
	opencv? ( media-libs/opencv )
	python? ( ${PYTHON_DEPS} )
	redis? ( dev-db/redis )
	rocm? ( dev-libs/rocm-opencl-driver )
	zeromq? ( net-libs/zeromq )
"
RDEPEND="${DEPEND}"
BDEPEND="
	doc? ( app-doc/doxygen )
"

PATCHES=(
	"${FILESDIR}/0001-Use-FHS-compliant-paths-from-GNUInstallDirs-module.patch"
	"${FILESDIR}/0002-Don-t-build-libtorch-again-for-PyTorch.patch"
	"${FILESDIR}/0003-Change-path-to-caffe2-build-dir-made-by-libtorch.patch"
	"${FILESDIR}/0004-Don-t-fill-rpath-of-Caffe2-library-for-system-wide-i.patch"
	"${FILESDIR}/0005-Change-library-directory-according-to-CMake-build.patch"
)

src_configure() {
	local mycmakeargs=(
		-DTORCH_BUILD_VERSION=${PV}
		-DTORCH_INSTALL_LIB_DIR=lib64
		-DBUILD_BINARY=$(usex tools ON OFF)
		-DBUILD_CUSTOM_PROTOBUF=OFF
		-DBUILD_DOCS=$(usex doc ON OFF)
		-DBUILD_PYTHON=$(usex python ON OFF)
		-DBUILD_SHARED_LIBS=$(usex static OFF ON)
		-DBUILD_TEST=$(usex test ON OFF)
		-DUSE_ASAN=$(usex asan ON OFF)
		-DUSE_CUDA=$(usex cuda ON OFF)
		-DUSE_ROCM=$(usex rocm ON OFF)
		-DUSE_FBGEMM=$(usex fbgemm ON OFF)
		-DUSE_FFMPEG=$(usex ffmpeg ON OFF)
		-DUSE_GFLAGS=$(usex gflags ON OFF)
		-DUSE_GLOG=$(usex glog ON OFF)
		-DUSE_LEVELDB=$(usex leveldb ON OFF)
		-DUSE_LITE_PROTO=OFF
		-DUSE_LMDB=$(usex lmdb ON OFF)
		-DCAFFE2_USE_MKL=$(usex mkl ON OFF)
		-DUSE_MKLDNN=$(usex mkldnn ON OFF)
		-DUSE_MKLDNN_CBLAS=OFF
		-DUSE_NCCL=OFF
		-DUSE_NNPACK=$(usex nnpack ON OFF)
		-DUSE_NUMPY=$(usex numpy ON OFF)
		-DUSE_NUMA=$(usex numa ON OFF)
		-DUSE_OBSERVERS=$(usex observers ON OFF)
		-DUSE_OPENCL=$(usex opencl ON OFF)
		-DUSE_OPENCV=$(usex opencv ON OFF)
		-DUSE_OPENMP=$(usex openmp ON OFF)
		-DUSE_TBB=OFF
		-DUSE_PROF=OFF
		-DUSE_QNNPACK=$(usex qnnpack ON OFF)
		-DUSE_REDIS=$(usex redis ON OFF)
		-DUSE_ROCKSDB=OFF
		-DUSE_ZMQ=$(usex zeromq ON OFF)
		-DUSE_MPI=$(usex mpi ON OFF)
		-DUSE_GLOO=$(usex gloo ON OFF)
		-DBUILD_NAMEDTENSOR=$(usex namedtensor ON OFF)
		-DBLAS=OpenBLAS
		-DBUILDING_SYSTEM_WIDE=ON # to remove insecure DT_RUNPATH header
	)

	cmake-utils_src_configure

	if use python; then
		distutils-r1_src_configure
	fi
}

src_install() {
	cmake-utils_src_install

	local multilib_failing_files=(
		libtorch.so
		libtbb.so
		libcaffe2_observers.so
		libc10.so
		libc10d.a
		libgloo.a
		libshm.so
		libsleef.a
		libcaffe2_detectron_ops.so
		libtorch_python.so
)
	for file in ${multilib_failing_files[@]}; do
		mv -f "${D}/usr/lib/$file" "${D}/usr/lib64"
	done

	rm -rfv "${D}/torch"
	rm -rfv "${D}/var"
	rm -rfv "${D}/usr/lib"

	rm -fv ${D}/usr/include/*.{h,hpp}
	rm -rfv "${D}/usr/include/asmjit"
	rm -rfv "${D}/usr/include/c10d"
	rm -rfv "${D}/usr/include/fbgemm"
	rm -rfv "${D}/usr/include/fp16"
	rm -rfv "${D}/usr/include/gloo"
	rm -rfv "${D}/usr/include/include"

	rm -fv "${D}/usr/lib64/libtbb.so"
	rm -rfv "${D}/usr/lib64/cmake"

	if ! use static; then
		rm -fv ${D}/usr/lib64/*.a
	fi

	rm -rfv "${D}/usr/share/doc/mkldnn"

	if use python; then
		scanelf -r --fix ${BUILD_DIR}/caffe2/python;
		CMAKE_BUILD_DIR=${BUILD_DIR} distutils-r1_src_install
		python_foreach_impl python_optimize
	fi
}