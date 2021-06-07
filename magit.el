(use-package magit
  :ensure t)
(require 'magit)
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-c g") 'magit-file-dispatch)
(setq magit-git-debug t)
