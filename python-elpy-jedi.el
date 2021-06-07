(require 'python)
(setq python-shell-interpreter "python3")

(defun my-shell-mode-hook ()
  (add-hook 'comint-output-filter-functions 'python-pdbtrack-comint-output-filter-function t))

(add-hook 'shell-mode-hook 'my-shell-mode-hook)

(use-package flycheck
  :ensure t
  :commands flycheck-mode
  :config
  (setq flycheck-python-pycompile-executable "python3"))

;; (use-package py-autopep8
;;   :commands py-autopep8-enable-on-save
;;   :ensure t)

(use-package jedi
  :ensure t
  :commands jedi-mode
  :config
  (setq python-environment-default-root-name "jedi")
  (setq jedi:environment-root python-environment-default-root-name)
  (setq python-environment-virtualenv
        (append python-environment-virtualenv
              '("--python" "/usr/bin/python3")))
  (setq jedi:environment-virtualenv python-environment-virtualenv)
  (setq jedi:server-command (list "/home/tshalif/.emacs.d/.python-environments/jedi/bin/jediepcserver"))
  :bind (:map jedi-mode-map
              ("M-." . jedi:goto-definition)
              ("M-," . jedi:goto-definition-pop-marker)))

(defun my-elpy-mode-hook ()
  (progn
    (flycheck-mode)
;    (py-autopep8-enable-on-save)
    (jedi-mode)))

(use-package elpy
  :ensure t
  :config
  (add-hook 'elpy-mode-hook 'my-elpy-mode-hook))


(elpy-enable)

