(defun my-setenv (var val)
  (interactive "sEnvironment Var: \ns%s Value: " var)
  (if (string= val "nil")
      (setq setval nil)
    (setq setval val))
  (setenv var setval)  
  (message "%s=>%s" var (getenv var)))

(defun my-find-region-file-emacs (beg end)
  "open file, whose name is currently marked (e.g. by the mouse)"
  (interactive "r")
  (my-find-region-file beg end))

(defun my-find-region-file-frame-emacs (beg end)
  "open file, whose name is currently marked (e.g. by the mouse)"
  (interactive "r")
  (my-find-region-file beg end nil t))

(defun my-find-region-file-netscape (beg end)
  "open file, whches name is currently marked (e.g. by the mouse)"
  (interactive "r")
  (my-find-region-file beg end "pnetscape"))

(defun my-find-region-file-realplay (beg end)
  "open file, whches name is currently marked (e.g. by the mouse)"
  (interactive "r")
  (my-find-region-file beg end "realplay"))

;(require 'string); for elib's string-replace-match

(defun my-find-region-file (beg end &optional program new-frame)
  (make-local-variable 'my-file-name)

  (setq my-line-num 0)
  (setq my-file-name nil)

  (goto-char beg)
  (if program
      (setq my-file-name (buffer-substring beg end))
    (or
     (and
      ;; /export/hostname_data/file/name + file line number
      ;;(search-forward-regexp "\\([^ :\t\n]+\\)\\(:\\([0-9]+\\)\\)?" end)
      (search-forward-regexp 
       "/export/\\([^_/]+\\)_\\([^/]+\\)/\\([^\"\t\n:,; ]+\\)[ \t]*[:\",]?[,;]?\\( line \\)?\\([0-9]+\\)?" end t)
      (progn
        (setq my-file-name-host 
              (buffer-substring (match-beginning 1) (match-end 1)))
        (setq my-file-name-dir
              (buffer-substring (match-beginning 2) (match-end 2)))
        (setq my-file-name-rest
              (buffer-substring (match-beginning 3) (match-end 3)))
        (setq my-file-name 
              (concat "/" my-file-name-dir "/" my-file-name-host
                      "/" my-file-name-rest))
        (and 
         (match-beginning 4)
         (setq my-line-num 
               (string-to-number (buffer-substring 
                               (match-beginning 4)
                               (match-end 4)))))
        t))
     (and
      ;; local file + file line number
      ;;(search-forward-regexp "\\([^ :\t\n]+\\)\\(:\\([0-9]+\\)\\)?" end)
      (search-forward-regexp 
       "\\([^\"\t\n:; ]+\\)[ \t]*[:\";,]?[,\";,[]?[ ]*\\(line\\|on line\\)?[ ]*\\([0-9]+\\)?" end)
      (progn
        (setq my-file-name 
              (buffer-substring (match-beginning 1) (match-end 1)))
        (and 
         (match-beginning 3)
         (setq my-line-num 
               (string-to-number (buffer-substring 
                               (match-beginning 3)
                               (match-end 3)))))
	
        t))))
  (if program
      (progn
	(if (string= (substring my-file-name 0 1) "~")
	    (setq my-file-name (expand-file-name my-file-name)))
	(call-process program nil nil nil my-file-name))
    (and my-file-name
	 
	 ; local file in emacs
	 (progn
           (if new-frame
               (find-file-other-frame my-file-name)
             (find-file-other-window my-file-name))
	   (goto-line my-line-num)))))


(defun my-shell-cd ()
  "switch to buffer *shell* and cd to same directory as current buffer"
  (interactive)

  (if (not (string= "*shell*" (buffer-name)))
      (progn
        (setq my-shell-cd-str (concat "cd '" (expand-file-name default-directory) "'"))
        (setq my-default-directory default-directory)
        (switch-to-buffer-other-window "*shell*")
        (end-of-buffer)
        (insert my-shell-cd-str)
        (comint-send-input)
        (cd my-default-directory))
    (shell-command "yakuake-pwd.sh")))


(setq my-kill-some-buffers-no-kill-mode-alist
      (list "lisp-interaction-mode" "shell-mode" "vm-mode" "vm-summary-mode"
            "mail-mode" "cvs-mode" "cvs-edit-mode" "compilation-mode"
            "gdb-mode"))


(setq my-kill-some-buffers-no-kill-name-alist
      (list "*scratch*"))

(defun my-kill-some-buffers nil
  (interactive)
  
  (let ((buffers (buffer-list)))
    (while buffers
      (let ((buffer (car buffers)))
        (progn
          (setq buffers (cdr buffers))
          (switch-to-buffer buffer)
          (let ((need-to-kill t))
            (progn
              (let ((file (if (buffer-file-name) 
                              (file-name-nondirectory (buffer-file-name))
                            (buffer-name)))
                    (modes my-kill-some-buffers-no-kill-mode-alist)
                    (names my-kill-some-buffers-no-kill-name-alist))
                (progn
                  (while (and modes need-to-kill)
                    (let ((mode (car modes)))
                      (progn
                        (setq modes (cdr modes))
                        (and
                         (string= mode (symbol-name major-mode))
                         (or
                          (setq need-to-kill nil)
                          (setq modes nil))))))
                  (while (and names need-to-kill)
                    (let ((name (car names)))
                      (progn
                        (setq names (cdr names))
                        (and
                         (string= name file)
                         (or
                          (setq need-to-kill nil)
                          (setq names nil))))))
                  (and 
                   need-to-kill
                   (kill-this-buffer)
                   ;;(yes-or-no-p (concat "kill buffer " file "? "))
                   ))))))))))

(defun my-file-basename (file)
  (car (split-string (car (reverse (split-string file "/"))) "\\.")))

(defun my-file-extension (file)
  (car (reverse (split-string file "\\."))))

(defun my-php-trace ()
  (interactive)

  (beginning-of-buffer)
  (save-excursion
    (query-replace-regexp "^\\(#[0-9]+\\) \\(.+\\.php(\\([0-9]+\\)):\\(.+\\)$" "\\2:\\3:error: \\1 \\3" (point-min) (point-max))))
  
(defun my-cc-trace ()
  (interactive)

  (save-excursion
    (end-of-defun)
    (backward-list)
    (next-line)
    (beginning-of-line)
    (insert "fprintf(stderr, \"%s >>>>>>>>\\n\", __FUNCTION__);")
    (c-indent-command)
    (insert "\n\n"))

  (save-excursion
    (end-of-defun)
    (search-backward "}")
    (insert "\nfprintf(stderr, \"%s <<<<<<<<\\n\", __FUNCTION__);")
    (c-indent-command)
    (insert "\n")))
  
(defun my-cc-header ()
  (interactive)
  (beginning-of-buffer)
  (insert "#ifndef ")
  (setq my-cc-header-ifdefword 
        (buffer-substring 
         (point) 
         (progn
           (upcase-region 
            (point)
            (progn
              (insert (concat (my-file-basename (buffer-file-name))
                              "_" 
                              (my-file-extension 
                                (buffer-file-name)) "\n"))
              (point)))
           (point))))
  (insert (concat "#define " my-cc-header-ifdefword "\n"))
  (end-of-buffer)
  ;(my-cvsid)
  (insert (concat "\n\n" "#endif // " my-cc-header-ifdefword))
  (beginning-of-buffer))

(defun my-docbook2html nil
  (interactive)
  (shell-command-on-region 
   (point-min) (point-max) 
   (concat "(cat > '" (buffer-file-name) ".tmp';xsltproc /usr/share/sgml/docbook/stylesheet/xsl/nwalsh/html/docbook.xsl '" (buffer-file-name)  ".tmp' > '" (buffer-file-name) ".html')"))
  (shell-command (concat "firefox '" (buffer-file-name) ".html'")))


(defun my-idea-open nil
  (interactive)
  (setq idea-command "intellij-idea-ultimate")
  (shell-command
   (concat idea-command " --line " (format "%s" (line-number-at-pos)) " " (buffer-file-name))))
    

(defun my-sudo-save nil
  (interactive)
  (if (buffer-modified-p)
      (progn 
	(shell-command-on-region 
	 (point-min) (point-max) 
	 (concat "sudo bash -c 'cat > " (buffer-file-name) "'"))
	(set-buffer-modified-p nil))))
    
(defun my-sudo-edit nil
  (interactive)
;  (define-key (current-local-map) "\C-x\C-s" 'my-sudo-save)
  (toggle-read-only)
  (auto-save-mode nil))




(defun srt-copy-lines nil
  (interactive)

  (other-window 1)
  (setq my-text
        (progn
          (save-excursion
            (buffer-substring 
             (point) 
             (progn
               (search-forward-regexp "^$")
               (point))))))

  (other-window 1)

  (save-excursion 
    (insert my-text)
    (delete-region 
     (point)
     (progn
       (search-forward-regexp "^$")
       (point)))))
(defun bzr-status-pwd (path)
  "Run \"bzr status\" in pwd, which must be a tree root."
  (interactive "fSubdir: ")
  (interactive)
  (let* ((window-conf (current-window-configuration))
         (root (expand-file-name "."))
         (subdir (expand-file-name path))	 
         (buffer (dvc-prepare-changes-buffer
                  `(bzr (last-revision ,root 1))
                  `(bzr (local-tree ,root))
                  'status subdir 'bzr)))
    (dvc-switch-to-buffer-maybe buffer)
    (dvc-buffer-push-previous-window-config window-conf)
    (setq dvc-buffer-refresh-function 'bzr-dvc-status)
    (dvc-run-dvc-async
     'bzr (list "status" subdir)
     :finished
     (dvc-capturing-lambda (output error status arguments)
       (with-current-buffer (capture buffer)
         (if (> (point-max) (point-min))
             (dvc-show-changes-buffer output 'bzr-parse-status
                                      (capture buffer))
           (dvc-diff-no-changes (capture buffer)
                                "No changes in %s"
                                (capture root))))
       :error
       (dvc-capturing-lambda (output error status arguments)
         (dvc-diff-error-in-process (capture buffer)
                                    "Error in diff process"
                                    output error))))))

(defun my-grep (term suffixes)
  (interactive "sSearch: \ns%s Files: " term)
  (my-grep-internal term suffixes "find"))

(defun my-lgrep (term suffixes)
  (interactive "sSearch: \ns%s Files: " term)
  (my-grep-internal term suffixes "locate"))


(defun my-grep-internal (term suffixes type)
  (make-local-variable 'suffix)
  (make-local-variable 'suffix-list)
  (make-local-variable 'files)
  (make-local-variable 'cmd)
  (make-local-variable 'filecmd)

  (if (and 
       (string= type "find") 
       (not 
	(string= suffixes "")))
      (setq files "\\( ")
    (setq files ""))

  (let ((suffix-list (split-string suffixes)))
    (while suffix-list
      (let ((suffix (car suffix-list)))
	(if (string= suffix "")
	    nil
	  (if (string= type "find")
	      (setq files (concat files " -name '*" suffix "' -o "))
	    (setq files (concat files suffix "\\|"))))
	
	(setq suffix-list (cdr suffix-list)))))

  (if (string= files "")
      nil
    (if (string= type "find")
	(setq files (concat files "-name non-existing-terminator.file \\)"))
      (setq files (concat files "non-existing-terminator-file"))))
  
  (if (string= type "find")
      (setq filecmd (concat "find  \\! -path '*.svn*' " files))
    (setq filecmd (concat "locate -r '\\(" files "\\)$'")))

  (setq cmd (concat filecmd " | xargs -ib8a2e6fb-e4e1-42e1-a4d0-9183582cf317 zgrep -EnHi -e '" term "' 'b8a2e6fb-e4e1-42e1-a4d0-9183582cf317'"))
  
  (grep cmd))

(defun my-replace-buffer (cmd)
  (interactive"sCommand: ")
  (shell-command-on-region 
   (point-min) (point-max) 
   cmd
   (current-buffer)))

(defun my-command-on-file (cmd)
  (interactive"sCommand - must specify '%%s' to be replaced by buffer file, stdout will replace file : ")
  (setq backupfile (concat (buffer-file-name) ".back"))
  (copy-file(buffer-file-name)  backupfile 1 t t t)
  (shell-command (concat (format cmd backupfile) " > " (buffer-file-name)))
  (revert-buffer t t t))
