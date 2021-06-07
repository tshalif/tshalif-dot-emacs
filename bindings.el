(global-set-key [(control delete)] 'kill-this-buffer)
(global-set-key [f4] 'other-window)
(global-set-key [(control f4)] 'switch-to-other-buffer)
(global-set-key "\C-c\C-t" 'bookmark-save)
(global-set-key "\C-c\<" 'sgml-tag)
(global-set-key "\C-xy" 'bookmark-jump)
(global-set-key [f9] 'compile)
(global-set-key [C-down-mouse-3] 'my-find-region-file-emacs)
(global-set-key [(control shift button3)] 'my-find-region-file-frame-emacs)
(global-set-key [C-down-mouse-4] 'text-scale-increase)
(global-set-key [C-down-mouse-5] 'text-scale-decrease)
(global-set-key [S-down-mouse-3] 'my-find-region-file-netscape)
;(global-set-key [(control shift button3)] 'my-find-region-file-realplay)
(global-set-key "\C-cd" 'my-shell-cd)
(global-set-key "\C-x\C-c" '(lambda nil
                              (interactive)
                              (desktop-save "~/")
                              (save-buffers-kill-emacs)))


(global-set-key [M-up] '(lambda nil
                              (interactive)
                              (scroll-down 1)))

(global-set-key [M-S-up] '(lambda nil
                              (interactive)
                              (scroll-other-window-down 1)))


(global-set-key [M-down] '(lambda nil
                              (interactive)
                              (scroll-up 1)))



(global-set-key [M-S-down] '(lambda nil
                              (interactive)
                              (scroll-other-window-down -1)))


(global-set-key [M-right] 'srt-copy-lines)
(global-set-key [M-left] 'undo)
(global-set-key [M-delete] '(lambda nil
                              (interactive)
                              (beginning-of-line)
                              (setq my-next-char
                                    (buffer-substring (point) (+ (point) 1)))
                              (kill-line)

                              (if (not (string-equal "\n" my-next-char))
                                  (delete-char 1))))
