(require 'python)

(defun my-shell-mode-hook ()
  (add-hook 'comint-output-filter-functions 'python-pdbtrack-comint-output-filter-function t))

(add-hook 'shell-mode-hook 'my-shell-mode-hook)

;; ;; To get path from shell
;; (use-package exec-path-from-shell
;;   :ensure t
;;   :config
;;   (when (memq window-system '(mac ns x))
;;     (exec-path-from-shell-initialize)))

;; Installing company mode
(use-package company
  :ensure t
  :config
  (add-hook 'after-init-hook 'global-company-mode))

;; Disable the delay
(setq company-idle-delay 0)

(eval-after-load 'company
  '(progn
     (define-key company-active-map (kbd "TAB") 'company-complete-common-or-cycle)
     (define-key company-active-map (kbd "<tab>") 'company-complete-common-or-cycle)
     (define-key company-active-map (kbd "S-TAB") 'company-select-previous)
     (define-key company-active-map (kbd "<backtab>") 'company-select-previous)))

(use-package company-jedi
  :ensure t)

(defun my/python-mode-hook ()
  (add-to-list 'company-backends 'company-jedi))
(add-hook 'python-mode-hook 'my/python-mode-hook)

;; Python
(setq python-shell-interpreter "python3")

(setq jedi:environment-root "jedi")  ; or any other name you like
(setq jedi:environment-virtualenv
      (append python-environment-virtualenv
              '("--python" "/usr/bin/python3")))


;; (defun my-elpy-mode-hook ()
;;   (progn
;;     (flycheck-mode)
;;     (py-autopep8-enable-on-save)
;;     (jedi-mode)
;;     (local-set-key "\M-." 'jedi:goto-definition)
;;     (local-set-key "\M-," 'jedi:goto-definition-pop-marker)))


;; (elpy-enable)

;; (add-hook 'elpy-mode-hook 'my-elpy-mode-hook)
