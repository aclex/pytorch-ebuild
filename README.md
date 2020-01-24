Ebuild files and necessary patches for [PyTorch](https://github.com/pytorch/pytorch)
==========

The project contains a portage directory subtree, which can be used for building and merging [PyTorch](https://github.com/pytorch/pytorch) in Gentoo-based distros.

How to use
---------

### [AMD ROCm](https://rocm.github.io/) repository setup

**Required step only if [AMD ROCm](https://rocm.github.io/) support is going to be enabled (`rocm` USE flag). Please, head over to repository setup chapter below, if don't plan to build PyTorch against ROCm.**

If you have recent AMD GPU and would like to use it in PyTorch, you would probably want to build [PyTorch](https://github.com/pytorch/pytorch) with [AMD ROCm](https://rocm.github.io/) support. It requires the current step of registering additional external portage [repository with ROCm infrastructure by @justxi](https://github.com/justxi/rocm/).

Probably the easiest way to register external portage repository in the system is to add it as an overlay (see also [here](https://wiki.gentoo.org/wiki/Custom_repository)). In short, to do this you want to create a small file in your `/etc/portage/repos.conf` directory (as `root`):

```bash
cat >> /etc/portage/repos.conf/justxi-rocm.conf << EOF
[justxi-rocm]
location = /var/db/repos/justxi-rocm
sync-type = git
sync-uri = https://github.com/justxi/rocm
auto-sync = yes
EOF
```

### Current repository setup

Now add our current portage repository to the system: 

```bash
cat >> /etc/portage/repos.conf/aclex-pytorch.conf << EOF
[aclex-pytorch]
location = /var/db/repos/aclex-pytorch
sync-type = git
sync-uri = https://github.com/aclex/pytorch-ebuild
auto-sync = yes
EOF
```

Afterwards you just sync the changes (`emerge --sync`, `eix-sync` etc.) and merge the packages using the common utilities via e.g. `emerge`.

What's inside
--------

* [x] `libtorch` (C++ core of [PyTorch](https://github.com/pytorch/pytorch))
* [x] system-wide installation
* [x] Python binding (i.e. [PyTorch](https://github.com/pytorch/pytorch) itself) linked to the built `libtorch` instance (i.e. no additional rebuild)
* [x] BLAS selection
* [x] building official documentation
* [x] [torchvision](https://github.com/pytorch/vision) (CPU and CUDA support only at the moment)

Some questions on [ROCm](https://rocm.github.io/) support
--------
**How can I make use ROCm inside PyTorch?**
It mimics CUDA inside PyTorch (and libtorch), so you can use just the same code snippets you normally use to work with CUDA, e.g. `.cuda()`, `torch.cuda.is_available() == True` etc.

**Can I still build CUDA support along with ROCm support enabled?**
No, it's not currently possible. PyTorch can only be built with either of them.

**Is it experimental or official support?**
As the [corresponding chapter](https://rocm.github.io/pytorch.html) on the homepage reads, PyTorch ROCm support appears to be official.
