# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9,10} )

DISTUTILS_OPTIONAL=1

inherit distutils-r1 cmake git-r3 python-r1 python-utils-r1

DESCRIPTION="An open source machine learning framework"
HOMEPAGE="https://pytorch.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

EGIT_REPO_URI="https://github.com/${PN}/${PN}"
EGIT_COMMIT="v${PV}"
EGIT_SUBMODULES=(
	'*'
	'-third_party/eigen'
	'-third_party/protobuf'
	'-third_party/ios-cmake'
	'-third_party/gflags'
	'-third_party/glog'
	'-third_party/onnx'
	'-third_party/pybind11'
	'-third_party/python-six'
	'-third_party/tbb'
)

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="asan atlas caffe2 cuda doc eigen +fbgemm ffmpeg gflags glog +gloo leveldb lmdb mkl +mkldnn mpi namedtensor +nnpack numa +numpy +observers openblas opencl opencv +openmp +python +qnnpack redis rocm static tbb test tools zeromq"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	numpy? ( python )
	atlas? ( !eigen !mkl !openblas )
	eigen? ( !atlas !mkl !openblas )
	mkl? ( !atlas !eigen !openblas )
	openblas? ( !atlas !eigen !mkl )
	rocm? ( !mkldnn !cuda )
"

DEPEND="
	dev-libs/protobuf
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=dev-python/pybind11-2.6.2[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	sci-libs/onnx[${PYTHON_USEDEP}]
	atlas? ( sci-libs/atlas )
	cuda? ( dev-util/nvidia-cuda-toolkit:0=[profiler] )
	doc? ( dev-python/pytorch-sphinx-theme[${PYTHON_USEDEP}] )
	eigen? ( dev-cpp/eigen )
	ffmpeg? ( virtual/ffmpeg )
	gflags? ( dev-cpp/gflags )
	glog? ( dev-cpp/glog )
	leveldb? ( dev-libs/leveldb )
	lmdb? ( dev-db/lmdb )
	mkl? ( sci-libs/mkl )
	mpi? ( virtual/mpi )
	numpy? ( dev-python/numpy[${PYTHON_USEDEP}] )
	openblas? ( sci-libs/openblas )
	opencl? ( dev-libs/clhpp virtual/opencl )
	opencv? ( media-libs/opencv[${PYTHON_USEDEP}] )
	python? ( ${PYTHON_DEPS} )
	redis? ( dev-db/redis )
	rocm? (
		dev-util/amd-rocm-meta
		dev-util/rocm-cmake
		dev-libs/rccl
		sci-libs/miopen
		dev-libs/roct-thunk-interface
	)
	tbb? ( dev-cpp/tbb )
	zeromq? ( net-libs/zeromq )
"

RDEPEND="${DEPEND}
"

BDEPEND="
	doc? ( app-doc/doxygen )
"

PATCHES=(
	"${FILESDIR}/1.10/Use-FHS-compliant-paths-from-GNUInstallDirs-module.patch"
	"${FILESDIR}/1.7/Don-t-build-libtorch-again-for-PyTorch.patch"
	"${FILESDIR}/1.9/Change-path-to-caffe2-build-dir-made-by-libtorch.patch"
	"${FILESDIR}/0004-Don-t-fill-rpath-of-Caffe2-library-for-system-wide-i.patch"
	"${FILESDIR}/1.8/Change-torch_path-part-for-cpp-extensions.patch"
	"${FILESDIR}/1.9/Fix-ROCm-paths-in-LoadHIP.cmake.patch"
	"${FILESDIR}/Include-neon2sse-third-party-header-library.patch"
	"${FILESDIR}/Include-mkl-Caffe2-targets-only-when-enabled.patch"
	"${FILESDIR}/1.8/Use-platform-dependent-LIBDIR-in-TorchConfig.cmake.in.patch"
	"${FILESDIR}/Fix-path-to-torch_global_deps-library-in-installatio.patch"
	"${FILESDIR}/1.9/Don-t-check-submodules-sanity.patch"
	"${FILESDIR}/1.11/Backport-breakpad-fix-for-non-constant-sigstksz.patch"
)

src_prepare() {
	cmake_src_prepare

	if use rocm; then
		${EPYTHON} "${S}/tools/amd_build/build_amd.py" || die
	fi
}

src_configure() {
	local blas="Eigen"

	if use atlas; then
		blas="ATLAS"
	elif use mkl; then
		blas="MKL"
	elif use openblas; then
		blas="OpenBLAS"
	fi

	if use rocm; then
		export HCC_PATH="${HCC_HOME}"
		export ROCBLAS_PATH="/usr"
		export ROCFFT_PATH="/usr"
		export HIPSPARSE_PATH="/usr"
		export HIPRAND_PATH="/usr"
		export ROCRAND_PATH="/usr"
		export MIOPEN_PATH="/usr"
		export RCCL_PATH="/usr"
		export ROCPRIM_PATH="/usr"
		export HIPCUB_PATH="/usr"
		export ROCTHRUST_PATH="/usr"
		export ROCTRACER_PATH="/usr"
	fi

	local mycmakeargs=(
		-DTORCH_BUILD_VERSION=${PV}
		-DTORCH_INSTALL_LIB_DIR=lib64
		-DBUILD_CAFFE2=$(usex caffe2 ON OFF)
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
		-DUSE_TBB=$(usex tbb ON OFF)
		-DUSE_SYSTEM_TBB=$(usex tbb ON OFF)
		-DUSE_PROF=OFF
		-DUSE_QNNPACK=$(usex qnnpack ON OFF)
		-DUSE_REDIS=$(usex redis ON OFF)
		-DUSE_ROCKSDB=OFF
		-DUSE_ZMQ=$(usex zeromq ON OFF)
		-DUSE_MPI=$(usex mpi ON OFF)
		-DUSE_GLOO=$(usex gloo ON OFF)
		-DUSE_SYSTEM_PYBIND11=ON
		-DBLAS=${blas}
		-DBUILDING_SYSTEM_WIDE=ON # to remove insecure DT_RUNPATH header
		-DUSE_SYSTEM_EIGEN_INSTALL=ON
		-DUSE_SYSTEM_ONNX=ON
	)

	cmake_src_configure

	if use python; then
		distutils-r1_src_configure
	fi
}

src_compile() {
	cmake_src_compile

	if use python; then
		CMAKE_BUILD_DIR=${BUILD_DIR} distutils-r1_src_compile
	fi
}

src_install() {
	cmake_src_install

	local multilib_failing_files=(
		libgloo.a
	)

	for file in ${multilib_failing_files[@]}; do
		mv "${D}/usr/lib/$file" "${D}/usr/lib64" || die
	done

	rm -rv "${D}/usr/lib" || die

	rm -rv "${D}/usr/include/fp16" || die
	rm -rv "${D}/usr/include/fp16.h" || die

	if use rocm; then
		rm -rv "${D}/usr/include/hip" || die
	fi

	rm -rv "${D}/usr/lib64/cmake" || die

	rm -rv "${D}/usr/share/doc/dnnl" || die

	rm -rv "${D}/usr/lib64/pkgconfig" || die

	if use python; then
		if use caffe2; then
			install_shm_manager() {
				python_get_sitedir
				TORCH_BIN_DIR="${D}/${PYTHON_SITEDIR}/torch/bin"

				mkdir -pv ${TORCH_BIN_DIR} || die
				cp -v "${D}/usr/bin/torch_shm_manager" "${TORCH_BIN_DIR}" || die
			}

			python_foreach_impl install_shm_manager
			rm "${D}/usr/bin/torch_shm_manager" || die

			scanelf -r --fix "${BUILD_DIR}/caffe2/python" || die
		fi

		CMAKE_BUILD_DIR=${BUILD_DIR} distutils-r1_src_install

		fix_caffe_convert_utils() {
			python_setup
			python_get_scriptdir
			python_get_sitedir

			ln -rnsvf "${D}/${PYTHON_SCRIPTDIR}/convert-caffe2-to-onnx" "${D}/usr/bin/" || die
			ln -rnsvf "${D}/${PYTHON_SCRIPTDIR}/convert-onnx-to-caffe2" "${D}/usr/bin/" || die
			ln -rnsvf "${D}/${PYTHON_SCRIPTDIR}/torchrun" "${D}/usr/bin/" || die

			# copy absent Protobuf-generated Python binding files
			find "${BUILD_DIR}/caffe2/proto" -name "*_pb2.py" -exec cp -v {} "${D}/${PYTHON_SITEDIR}/caffe2/proto" \; || die
		}

		fix_caffe_convert_utils

		remove_tests() {
			find "${D}" -name "*test*" -exec rm -rfv {} \; || die
		}

		if use test; then
			python_foreach_impl remove_tests
		fi

		python_foreach_impl python_optimize
	fi

	find "${D}/usr/lib64" -name "*.a" -exec rm -fv {} \; || die

	if use test; then
		rm -rfv "${D}/usr/test" || die
		rm -fv "${D}/usr/bin/test_api" || die
		rm -fv "${D}/usr/bin/test_jit" || die
	fi
}
