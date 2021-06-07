(add-to-list 'auto-mode-alist '("\\.ihtml\\'" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc\\'" . php-mode))

(add-hook 'php-mode-hook 'my-php-mode-hook)
(defun my-php-mode-hook ()
  "My PHP mode configuration."
  (flycheck-mode)
  (company-mode)
  (projectile-mode)
  (setq indent-tabs-mode nil
        tab-width 4
        c-basic-offset 4))

(defun my-php-parse-error-log ()
  "Parse phpshop error log stack trace"
  (interactive)
  (replace-regexp "^\\(#[0-9]+ +\\)?\\(.+\\)\\[\\([^]]+\\)\\]\\(.*\\)$" "\\3: \\2 \\3" nil (point-min) (point-max))
  (compilation-mode)
  (beginning-of-buffer))

  
(defun my-php-parse-error-log2 ()
  "Parse phpshop error log stack trace"
  (interactive)
  (replace-regexp "^\\(#[0-9]+ +\\)?\\(.+\\.php\\)(\\([0-9]+\\)): \\(.*\\)$" "\\2:\\3: \\4" nil (point-min) (point-max))
  (compilation-mode)
  (beginning-of-buffer))
