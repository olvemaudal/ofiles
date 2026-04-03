;;
;; .emacs, Olve Maudal (Apr 2026, Mac setup)
;;

(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq sentence-end-double-space nil)
(setq visible-bell nil)
(column-number-mode 1)
(line-number-mode 1)
(menu-bar-mode 1)
(tool-bar-mode -1)
(scroll-bar-mode 1)

;;
;; System specific setups
;;

(when (eq system-type 'darwin)
  (set-face-attribute 'default nil :family "Menlo" :height 180)
  (setq mac-option-modifier 'meta)         ;; M-x is then left option key
  (setq mac-right-option-modifier 'none)   ;; special keys can still be reached with right option
  (global-set-key (kbd "s-C-f") 'toggle-frame-fullscreen)
  (global-set-key (kbd "s-C-m") 'toggle-frame-maximized)  
  (global-set-key (kbd "s-p") #'ignore)    ;; avoid printing on mac
  (global-set-key (kbd "s-n") #'ignore))   ;; avoid create new frame

(when (eq system-type 'windows-nt)
  (set-face-attribute 'default nil :family "Consolas" :height 180))

(when (eq window-system 'x)
  (set-face-attribute 'default nil :family "DejaVu Sans Mono" :height 120)
  (setq x-alt-keysym 'meta))

;;
;; Take control of C-q, from now on it is my personal key prefix
;; Quoted insert is sometimes useful, but from now on C-q C-q <key> will do that
;;

(defvar omakey-map (make-sparse-keymap) "My personal key prefix map.")
(global-unset-key (kbd "C-q"))
(global-set-key (kbd "C-q") omakey-map)
(define-key omakey-map (kbd "C-q") #'quoted-insert)

;;
;; C-h is my backspace. Rebind help to C-q C-h and C-q h instead
;;

(global-set-key (kbd "C-h") #'backward-delete-char-untabify)
(define-key omakey-map (kbd "C-h") #'help-command)
(define-key omakey-map (kbd "h") #'help-for-help)

;;
;; Disable C-z (who needs to to suspend emacs?)
;;

(global-set-key (kbd "C-z") nil)

;;
;; Jumping between windows
;;

(global-set-key (kbd "C-ø") (lambda () (interactive) (other-window 1)))
(global-set-key (kbd "C-S-ø") (lambda () (interactive) (other-window -1)))

;;
;; bind C-x C-r to open recent files (and increase recent files to 50)
;;

(recentf-mode 1)
(setq recentf-max-menu-items 50
      recentf-max-saved-items 50)
(global-set-key (kbd "C-x C-r") #'recentf-open-files)

;;
;; oma keys (after C-q)
;;

(define-key omakey-map "l"        #'font-lock-mode)
(define-key omakey-map "L"        #'hi-lock-face-buffer)
(define-key omakey-map "d"        (lambda () (interactive) (message "%s" default-directory)))
(define-key omakey-map "s"        #'search-forward-regexp)
(define-key omakey-map "r"        #'query-replace-regexp)
(define-key omakey-map "b"        #'rename-buffer)
(define-key omakey-map "\C-v"     #'ff-find-other-file)
(define-key omakey-map "v"        #'set-variable)
(define-key omakey-map "w"        #'whitespace-mode)
(define-key omakey-map "t"        (lambda () (interactive) (setq truncate-lines (not truncate-lines)) (redraw-display)))
(define-key omakey-map "\C-x\C-w" #'write-region)
(define-key omakey-map "\C-k"     (lambda () (interactive) (kill-buffer (current-buffer))))
(define-key omakey-map "c"        #'compile)
(define-key omakey-map "o"        (lambda () (interactive) (other-window 1)))
(define-key omakey-map "\C-o"     (lambda () (interactive) (other-window -1)))

;;
;; fix PAGER, when running shell, we do not want *less* or something similar
;;

(setenv "PAGER" "cat")

;;
;; Navigate between buffers
;;

(when (eq system-type 'darwin)
  (define-key omakey-map "\C-s" '(lambda () (interactive) (find-file-existing "~/scratchpad.txt")))
  (define-key omakey-map "\C-e" '(lambda () (interactive) (find-file-existing "~/.emacs"))))

(when (eq system-type 'windows-nt)
  (define-key omakey-map "\C-s" '(lambda () (interactive) (find-file-existing "C:/Users/olvm/scratchpad.txt"))))

;;
;; goto-match-paren (C-q %)
;; 

(defun goto-match-paren (arg)
  "Go to the matching parenthesis if on parenthesis, otherwise insert %.
vi style of % jumping to matching brace."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
	((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))

(define-key omakey-map "%" 'goto-match-paren)

;;
;; mode hooks
;;

;;(setq python-mode-hook
;;     '(lambda ()
;;        (font-lock-mode 't)))
;;        (local-set-key [(return)] 'py-newline-and-indent)
;;        (local-set-key [(control h)] 'py-electric-backspace)))
;;
;;(setq compilation-mode-hook
;;     '(lambda ()
;;        (local-set-key [(control o)] '(lambda () (interactive) (other-window 1)))
;;        (local-set-key [(control O)] '(lambda () (interactive) (other-window -1)))))
;;

;;(setq comint-password-prompt-regexp "\\(\\([Oo]ld \\|[Nn]ew \\|'s \\|login \\|Kerberos \\|CVS \\|UNIX \\| SMB \\|^\\)[Pp]assword\\( (again)\\)?\\|pass phrase\\|\\(Enter\\|Repeat\\|Enter same\\) passphrase\\)\\([^:]+\\)?:\\s *\\'")

;;(setq shell-mode-hook 
;;     '(lambda ()
;;        (setq comint-input-ring-size 1024)
;;        ;;(setq comint-output-filter-functions '(ansi-color-process-output comint-strip-ctrl-m oma-strip-ctrl-h comint-postoutput-scroll-to-bottom comint-watch-for-password-prompt))
;;	(setq explicit-shell-file-name '"/bin/zsh")
;;	;;(setq explicit-shell-file-name '"C:/Program Files/Git/bin/bash.exe")
;;        (local-set-key [(meta p)] 'comint-previous-matching-input-from-input)
;;        (local-set-key [(meta n)] 'comint-next-matching-input-from-input)))
;;
;;
;;(if (equal system-type 'windows-nt)
;;   (progn
;;     (setq comint-completion-addsuffix '("\\" . " "))))

;; 
;; oma-shell
;; 

(setq display-buffer-alist '(("[0-9]" display-buffer-same-window)))

(define-key omakey-map "1" '(lambda (arg) (interactive "P") (oma-shell "1" arg)))
(define-key omakey-map "2" '(lambda (arg) (interactive "P") (oma-shell "2" arg)))
(define-key omakey-map "3" '(lambda (arg) (interactive "P") (oma-shell "3" arg)))
(define-key omakey-map "4" '(lambda (arg) (interactive "P") (oma-shell "4" arg)))
(define-key omakey-map "5" '(lambda (arg) (interactive "P") (oma-shell "5" arg)))
(define-key omakey-map "6" '(lambda (arg) (interactive "P") (oma-shell "6" arg)))
(define-key omakey-map "7" '(lambda (arg) (interactive "P") (oma-shell "7" arg)))
(define-key omakey-map "8" '(lambda (arg) (interactive "P") (oma-shell "8" arg)))
(define-key omakey-map "9" '(lambda (arg) (interactive "P") (oma-shell "9" arg)))
(define-key omakey-map "0" '(lambda (arg) (interactive "P") (oma-shell "0" arg)))

;;(defun oma-shell (name arg)
;;  (interactive)
;;  (shell name))

(defun oma-buffer-exist-p (buf)
  "Return non-nil iff buffer BUF exists"
  (member buf (mapcar (function buffer-name) (buffer-list))))

(defun oma-shell (name arg)
 (interactive)
 (if (oma-buffer-exist-p name)
     (switch-to-buffer name)
   (setq explicit-shell-file-name '"/bin/zsh")
   ;;(setq explicit-shell-file-name '"C:/Program Files/Git/bin/bash.exe")
   (setq ansi-color-for-comint-mode 't)
   (setq shell-font-lock-keywords 'nil)
   (shell)
   (rename-buffer name)))

(defvar oma-shell-exec-target 'nil "*Target buffer for oma-shell-exec-line")
(defun oma-shell-exec-line (arg)
 "Executes current line in a target buffer. With prefix, you will always
be asked about which the target buffer. Without prefix, the last target
buffer, if any, will be used."
 (interactive "P")
 (if (or arg (not oma-shell-exec-target) (not (oma-buffer-exist-p oma-shell-exec-target)))
     (setq oma-shell-exec-target (read-from-minibuffer "Target buffer name:")))
 (if (not (oma-buffer-exist-p oma-shell-exec-target))
     (error "Target buffer \"%s\" does not exist" oma-shell-exec-target)
   (let ( (pos (point)) (beg) (end))
     (beginning-of-line)
     (setq beg (point))
     (end-of-line)
     (setq end (point))
     (let ((cmd (buffer-substring beg end)) (curbuf (current-buffer)))
       (switch-to-buffer-other-window oma-shell-exec-target)
       (end-of-buffer)
       (execute-kbd-macro (concat cmd "\r"))
       (pop-to-buffer curbuf))
     (goto-char pos))
   (forward-line 1)
   (end-of-line)))

(define-key omakey-map "j" 'oma-shell-exec-line)
(global-set-key (kbd "C-æ") #'oma-shell-exec-line)

(defun oma-shell-exec-string (arg)
  "Executes a given string into buffer named 1"
  (interactive "P")
  (save-buffer)
  (let (curbuf (current-buffer))
    (switch-to-buffer "1")
    (end-of-buffer)
    (execute-kbd-macro "c++ tour.cpp && ./a.out\r")
    (switch-to-buffer curbuf)))

;;
;; auto-mode-alist
;;

(setq auto-mode-alist
 (append '(("\\.emacs" . emacs-lisp-mode)
           ("makefile" . makefile-mode)
           ("genmake.def" . python-mode)
           ("\\.asm$" . nasm-mode)
           ("\\.inc$" . nasm-mode)
           ("\\.m$" . octave-mode)
           ("\\.html$" . web-mode)
           ) auto-mode-alist))

;;
;; from randomize-region.el by Joe Corneli
;;

(defun randomize-region (beg end)
  (interactive "r")
  (if (> beg end)
      (let (mid) (setq mid end end beg beg mid)))
  (save-excursion
    ;; put beg at the start of a line and end and the end of one --
    ;; the largest possible region which fits this criteria
    (goto-char beg)
    (or (bolp) (forward-line 1))
    (setq beg (point))
    (goto-char end)
    ;; the test for bolp is for those times when end is on an empty
    ;; line; it is probably not the case that the line should be
    ;; included in the reversal; it isn't difficult to add it
    ;; afterward.
    (or (and (eolp) (not (bolp)))
        (progn (forward-line -1) (end-of-line)))
    (setq end (point-marker))
    (let ((strs (shuffle-list 
                 (split-string (buffer-substring-no-properties beg end)
                             "\n"))))
      (delete-region beg end)
      (dolist (str strs)
        (insert (concat str "\n"))))))

(defun shuffle-list (list)
  "Randomly permute the elements of LIST. All permutations equally likely."
  (let ((i 0)
  j
  temp
  (len (length list)))
    (while (< i len)
      (setq j (+ i (random (- len i))))
      (setq temp (nth i list))
      (setcar (nthcdr i list) (nth j list))
      (setcar (nthcdr j list) temp)
      (setq i (1+ i))))
  list)

;;
;; final stuff
;;

(define-key emacs-lisp-mode-map (kbd "C-<return>") 'eval-last-sexp)

(setq ring-bell-function 'ignore)

(defun myssh (host)
  (interactive "sHost: ")
  (let ((default-directory (format "/ssh:%s:~" host)))
    (shell (format "*shell:%s*" host))))

(global-set-key (kbd "C-c s") #'myssh)

(set-face-attribute 'variable-pitch nil :family (face-attribute 'default :family))  ;; to avoid variable-pitch face on help buffer

;;(define-key emacs-lisp-mode-map (kbd "C-<return>") 'eval-last-sexp)

;;(add-to-list 'exec-path "/opt/homebrew/bin")
;;(add-to-list 'exec-path "/opt/homebrew/sbin")
;;(setenv "PATH" (concat "/opt/homebrew/bin:/opt/homebrew/sbin:" (getenv "PATH")))

;;
;; Install vterm (might need "brew install libvterm cmake")
;;

;; (require 'package)
;; (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; (package-initialize)

(use-package vterm
  :ensure t
  :custom
  (vterm-always-compile-module t))

;;
;; Done
;;

(message ".emacs completed")
