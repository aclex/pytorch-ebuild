Ebuild files and necessary patches for [PyTorch](https://github.com/pytorch/pytorch)
==========

The project contains a portage directory subtree, which can be used for building and merging [PyTorch](https://github.com/pytorch/pytorch) in Gentoo-based distros.

How to use
---------

Probably the easiest way is to add this repository to your system as overlay, as described in details [here](https://wiki.gentoo.org/wiki/Custom_repository). In short, to do this you want to create a small file in your `/etc/portage/repos.conf` directory (as `root`):

```bash
cat >> /etc/portage/repos.conf/aclex-pytorch.conf << EOF
[aclex-pytorch]
location = /var/db/repos/aclex-pytorch
sync-type = git
sync-uri = https://github.com/aclex/pytorch-ebuild
auto-sync = yes
EOF
```

Then you just sync the changes (`emerge --sync`, `eix-sync` etc.) and merge the packages using the common utilities via e.g. `emerge`.

What's inside
--------

* [x] `libtorch` (C++ core of [PyTorch](https://github.com/pytorch/pytorch))
* [x] system-wide installation
* [x] actual Python binding (the [PyTorch](https://github.com/pytorch/pytorch) itself) linked to the built `libtorch` instance (i.e. no additional rebuild)
* [x] BLAS selection
* [x] building official documentation
* [x] [torchvision](https://github.com/pytorch/vision)
