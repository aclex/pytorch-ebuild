Ebuild files and necessary patches for [PyTorch](https://github.com/pytorch/pytorch)
==========

The project contains a portage directory subtree, which can be used for building and merging [PyTorch](https://github.com/pytorch/pytorch) in Gentoo-based distros.

How to use
---------

For example, you can create custom local repository, as described [here](https://wiki.gentoo.org/wiki/Custom_repository) and just move the whole directory content of the project (except for LICENSE and README.md stuff) there. Then you just merge the packages using the common utilities (`emerge`).

What's inside
--------

* [x] `libtorch` (C++ core of [PyTorch](https://github.com/pytorch/pytorch))
* [x] system-wide installation
* [x] actual Python binding (the [PyTorch](https://github.com/pytorch/pytorch) itself) linked to the built `libtorch` instance (i.e. no additional rebuild)
* [x] BLAS selection (currently [OpenBLAS](https://www.openblas.net/) only)
* [ ] building official documentation
* [x] [torchvision](https://github.com/pytorch/vision)
