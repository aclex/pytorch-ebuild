Ebuild files and necessary patches for [PyTorch](https://github.com/pytorch/pytorch)
==========

The project contains a portage directory subtree, which can be used for building and merging [PyTorch](https://github.com/pytorch/pytorch) in Gentoo-based distros.

**This branch contains the ebuild for [PyTorch](https://github.com/pytorch/pytorch) building with [AMD ROCm](https://rocm.github.io/) support and requires additional external portage [repository with ROCm infrastructure by @justxi](https://github.com/justxi/rocm/). If you're not interested in [AMD ROCm](https://rocm.github.io/) support, please, consider checking out the [`master`](https://github.com/aclex/pytorch-ebuild/tree/master) branch instead.**

How to use
---------

First register the [ROCm repository](https://github.com/justxi/rocm/) in the system. Probably the easiest way is to add it to your system as an overlay (see also [here](https://wiki.gentoo.org/wiki/Custom_repository)). In short, to do this you want to create a small file in your `/etc/portage/repos.conf` directory (as `root`):

```bash
cat >> /etc/portage/repos.conf/justxi-rocm.conf << EOF
[justxi-rocm]
location = /var/db/repos/justxi-rocm
sync-type = git
sync-uri = https://github.com/justxi/rocm
auto-sync = yes
EOF
```

Then add the current portage repository to the system just the same way: 

```bash
cat >> /etc/portage/repos.conf/aclex-pytorch.conf << EOF
[aclex-pytorch]
location = /var/db/repos/aclex-pytorch
sync-type = git
sync-uri = https://github.com/aclex/pytorch-ebuild
auto-sync = yes
EOF
```

Now you just sync the changes (`emerge --sync`, `eix-sync` etc.) and merge the packages using the common utilities via e.g. `emerge`.

What's inside
--------

* [x] `libtorch` (C++ core of [PyTorch](https://github.com/pytorch/pytorch)) building with [AMD ROCm](https://rocm.github.io/) support
* [x] system-wide installation
* [x] Python binding (i.e. [PyTorch](https://github.com/pytorch/pytorch) itself) linked to the built `libtorch` instance (i.e. no additional rebuild)
* [x] BLAS selection
* [x] building official documentation
* [x] [torchvision](https://github.com/pytorch/vision) (CPU and CUDA support only at the moment)
