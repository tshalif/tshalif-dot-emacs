(setq scroll-step 1)
(display-time)

(setq auto-mode-alist
      (cons '("\\.xmap$" . nxml-mode) auto-mode-alist))

;; Typing "yes" or "no" takes too long---use "y" or "n"
(fset 'yes-or-no-p 'y-or-n-p)

;; for emacs to insert spaces instead of tab chars
(setq-default indent-tabs-mode nil)

(put 'erase-buffer 'disabled nil)

(put 'narrow-to-region 'disabled nil)

(display-time-mode t)

(show-paren-mode t)

(setq savehist-additional-variables '(search-ring regexp-search-ring))
(savehist-mode 1)

(put 'scroll-left 'disabled nil)
