# Configuration files
This is a repository of the many configuration files I use on my [NixOS](https://nixos.org/) Linux computers.

## `scripts/`
This directory includes many miscellanious tools and scripts.  The most important are `mdtopdf` and `asciimath.hs`, the latter of which will soon be replaced by [alexander-c-b/AsciiMath](https://github.com/alexander-c-b/AsciiMath).

I also use `to-clipboard` and `from-clipboard` quite often, which are thin wrappers over [`xclip`](https://github.com/astrand/xclip).

## `.local/share/`
`pandoc/templates/default.context` is my fork of the default [ConTeXt](https://wiki.contextgarden.net/Main_Page) template from [Pandoc](https://pandoc.org/index.html), the document conversion tool underpinning my process for writing professional documents in Markdown.

## `.config/`
-   **`z-nix-config/`** contains all my NixOS configuration; principally, `system.nix` contains the main configuration, while `desktop.nix` and `laptop.nix` contain specific configuration for my desktop and laptop systems, respectively.  `packages.nix` is self-explanatory.  `ghcPackages.nix` provides Pandoc and necessary utilities for document creation.

-   **`nvim/`** contains my configuration for my text editor of choice, [Neovim](https://neovim.io/).  `init.vim` is the most important, as well as my custom Markdown syntax file under `syntax/pmarkdown.vim`.
