These are Tal Shalif's personal Emacs init files.

# How to use

1. Clone repository under `~/.tshalif-emacs`
    ```bash
    cd ~/src
    git clone git@github.com:tshalif/tshalif-dot-emacs.git ~/.tshalif-emacs
    ```
1. Load `~/.tshalif-emacs/.emacs` somewhere into your `~/.emacs`
    ```lisp
    (package-initialize)

    (load-file "~/.tshalif-emacs/.emacs")
    ...
    ```
