;;
;; .emacs, olve maudal (Dec 2020)
;;

(setq inhibit-startup-screen 't)
(setq inhibit-startup-message 't)
(setq make-backup-files 'nil)
(setq auto-save-default 'nil)
(setq sentence-end-double-space 'nil)
(column-number-mode 1)
(line-number-mode 1)
(menu-bar-mode 1)
(tool-bar-mode 0)
(scroll-bar-mode -1)

;;
;; Take control of C-q, from now on it is my personal key prefix
;;

(setq omakey-map (make-keymap))
(define-key global-map "\C-q" omakey-map)
(define-key omakey-map "q" 'quoted-insert)

;;
;; rebind set mark to C-l because C-Space often does not work (eg wt)
;;

(define-key global-map (kbd "C-SPC") 'nil)
(define-key global-map (kbd "C-@") 'nil)
(define-key global-map [(control l)] 'set-mark-command)

;;
;; C-h is my backspace. Rebind help to C-q h instead
;;

(define-key global-map [(control h)] 'backward-delete-char-untabify)
(define-key omakey-map "h" 'help-for-help)

;;
;; Redefine C-o
;;

(define-key global-map (kbd "C-o") '(lambda () (interactive) (other-window 1)))
(define-key global-map (kbd "C-O") '(lambda () (interactive) (other-window -1)))

;;
;; who needs to to suspend emacs? C-z is a nice key for undo
;; also because C-_ sometimes does not work
;;

(define-key global-map [(control z)] 'undo)

;;
;; bind C-x C-r to open recent files (and increase recent files to 50)
;;

(recentf-mode 1)
(setq recentf-max-menu-items 50)
(global-set-key "\C-x\ \C-r" 'recentf-open-files) ;; shadow find-file-read-only

;;
;; fix PAGER, when running shell, we do not want *less* or something similar
;;

(setenv "PAGER" "cat")

;;
;; Set default fonts
;;

(if (equal system-type 'windows-nt)
    (custom-set-faces
     '(default ((t (:family "Consolas" :foundry "outline" :slant normal :weight normal :height 150 :width normal))))))

;;
;; oma keys (after C-q)
;;

(define-key omakey-map "l"    'font-lock-mode)
(define-key omakey-map "L"    'hi-lock-face-buffer)
(define-key omakey-map "d"    '(lambda() (interactive) (message default-directory)))
(define-key omakey-map "s"    'search-forward-regexp)
(define-key omakey-map "r"    'query-replace-regexp)
(define-key omakey-map "b"    'rename-buffer)
(define-key omakey-map "\C-v" 'ff-find-other-file)
(define-key omakey-map "v"    'set-variable)
(define-key omakey-map "w"    'whitespace-mode)
(define-key omakey-map "t"    '(lambda() (interactive) (setq truncate-lines (if (eval truncate-lines) (eval nil) (eval 1) )) (redraw-display)))
(define-key omakey-map "\C-x\C-w" 'write-region)
(define-key omakey-map "\C-k" '(lambda() (interactive) (kill-buffer (current-buffer))))
(define-key omakey-map "c"    'compile)

(define-key omakey-map "o" '(lambda () (interactive) (other-window 1)))
(define-key omakey-map "\C-o" '(lambda () (interactive) (other-window -1)))

;;
;; Navigate between buffers
;;

(defun oma-buffer-exist-p (buf)
  "Return non-nil iff buffer BUF exists"
  (member buf (mapcar (function buffer-name) (buffer-list))))

(defun oma-buffer-rotate (list re)
  "Rotate to next buffer in LIST which pretty mode name matches RE."
  (let (ok)
    (while (and list (not ok))
      (switch-to-buffer (car list))
      (setq list (cdr list))
      (if (string-match re mode-name)
          (setq ok 't)))))

(defun oma-buffer-rotate-next (&optional re)
  "Rotate to next buffer which mode matches RE."
  (interactive)
  (oma-buffer-rotate (reverse (buffer-list)) re))

(defun oma-buffer-rotate-prev (&optional re)
  "Rotate to previous buffer which mode matches RE."
  (interactive)
  (bury-buffer (current-buffer))
  (oma-buffer-rotate (buffer-list) re))

(define-key omakey-map "\C-l" '(lambda () (interactive) (oma-buffer-rotate-prev "Lisp")))
(define-key omakey-map "\C-L" '(lambda () (interactive) (oma-buffer-rotate-next "Lisp")))
(define-key omakey-map "\C-i" '(lambda () (interactive) (oma-buffer-rotate-prev "^idl$")))
(define-key omakey-map "\C-I" '(lambda () (interactive) (oma-buffer-rotate-next "^idl$")))
(define-key omakey-map "\C-j" '(lambda () (interactive) (oma-buffer-rotate-prev "^java\\|JDE$")))
(define-key omakey-map "\C-J" '(lambda () (interactive) (oma-buffer-rotate-next "^java\\|JDE$")))
(define-key omakey-map "\C-h" '(lambda () (interactive) (oma-buffer-rotate-prev "Man\\|Help\\|Apropos\\|Info")))
(define-key omakey-map "\C-H" '(lambda () (interactive) (oma-buffer-rotate-next "Man\\|Help\\|Apropos\\|Info")))
(define-key omakey-map "\C-w" '(lambda () (interactive) (oma-buffer-rotate-prev "Web\\|Javascript\\|CSS")))
(define-key omakey-map "\C-W" '(lambda () (interactive) (oma-buffer-rotate-next "Html\\|WWW")))
(define-key omakey-map "\C-p" '(lambda () (interactive) (oma-buffer-rotate-prev "Python\\|Perl")))
(define-key omakey-map "\C-P" '(lambda () (interactive) (oma-buffer-rotate-next "Python\\|Perl")))
(define-key omakey-map "\C-c" '(lambda () (interactive) (oma-buffer-rotate-prev "^C/\\|^C\\+\\+/")))
(define-key omakey-map "\C-C" '(lambda () (interactive) (oma-buffer-rotate-next "^C/\\|^C\\+\\+/")))
(define-key omakey-map "\C-s" '(lambda () (interactive) (oma-buffer-rotate-prev "^.sh$")))
(define-key omakey-map "\C-S" '(lambda () (interactive) (oma-buffer-rotate-next "^.sh$")))
(define-key omakey-map "\C-d" '(lambda () (interactive) (oma-buffer-rotate-prev "debug")))
(define-key omakey-map "\C-D" '(lambda () (interactive) (oma-buffer-rotate-next "debug")))

(define-key omakey-map "\C-s" '(lambda () (interactive) (find-file-existing "~/scratchpad.txt")))
(if (equal system-type 'windows-nt)
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

(setq shell-mode-hook 
     '(lambda ()
        (setq comint-input-ring-size 1024)
        ;;(setq comint-output-filter-functions '(ansi-color-process-output comint-strip-ctrl-m oma-strip-ctrl-h comint-postoutput-scroll-to-bottom comint-watch-for-password-prompt))
	;;(setq explicit-shell-file-name '"/bin/bash")
	(setq explicit-shell-file-name '"C:/Program Files/Git/bin/bash.exe")
        (local-set-key [(meta p)] 'comint-previous-matching-input-from-input)
        (local-set-key [(meta n)] 'comint-next-matching-input-from-input)))


(if (equal system-type 'windows-nt)
   (progn
     (setq comint-completion-addsuffix '("\\" . " "))))

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

(defun oma-shell (name arg)
 (interactive)
 (if (oma-buffer-exist-p name)
     (switch-to-buffer name)
   (setq explicit-shell-file-name '"C:/Program Files/Git/bin/bash.exe")
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Loft - after this, everything should be commented out
;;

;;;;
;;;; c and c++ modes
;;;;
;;
;;(defun my-c-mode-hook()
;;  (require 'font-lock)
;;  (font-lock-mode 1)
;;  (define-key c-mode-map "\C-m" 'newline-and-indent)
;;  (define-key c-mode-map "\M-n" 'next-error)
;;  (define-key c-mode-map "\M-p" 'previous-error)
;;  (define-key c++-mode-map "\M-n" 'next-error)
;;  (define-key c++-mode-map "\M-p" 'previous-error)
;;  (define-key c-mode-map "\C-c\C-d" 'gdb)
;;  (define-key c++-mode-map "\C-m" 'newline-and-indent)
;;  ;; (setq compile-command "make EXTRACFLAGS=-DPLATFORM_SOLO NOOPTIMIZE=1 DEBUGMAKE=1 MAKENOLOOP=1 TTCOMPILER=gcc -C ~/sandbox/dev/make/fanta/host")
;;  (define-key c-mode-map "\C-c\C-c" 'compile)
;;  (define-key c++-mode-map "\C-c\C-c" 'compile)
;;  (setq c-basic-offset 4))
;;
;;(add-hook 'c-mode-hook 'my-c-mode-hook)
;;(add-hook 'c++-mode-hook 'my-c-mode-hook)
;;
;; Make a non-standard key binding.  We can put this in
;; c-mode-base-map because c-mode-map, c++-mode-map, and so on,
;; inherit from it.
;;
;;(defun my-c-initialization-hook ()
;;  (define-key c-mode-base-map "\C-m" 'c-context-line-break))
;;(add-hook 'c-initialization-hook 'my-c-initialization-hook)
;;
;; offset customizations not in my-c-style
;; This will take precedence over any setting of the syntactic symbol
;; made by a style.
;;(setq c-offsets-alist '((member-init-intro . ++)))
;;
;;;;
;;;; Create my personal style.
;;;;
;;
;;(defconst my-c-style
;; '((c-tab-always-indent        . t)
;;   (c-comment-only-line-offset . 0)
;;   (c-hanging-braces-alist     . ((substatement-open after)
;;                                  (brace-list-open)))
;;   (c-hanging-colons-alist     . ((member-init-intro before)
;;                                  (inher-intro)
;;                                  (case-label after)
;;                                  (label after)
;;                                  (access-label after)))
;;   (c-cleanup-list             . (scope-operator
;;                                  empty-defun-braces
;;                                  defun-close-semi))
;;   (c-offsets-alist            . ((arglist-close . c-lineup-arglist)
;;                                  (substatement-open . 0)
;;                                  (case-label        . 0)
;;                                  (innamespace       . -)
;;                                  (block-open        . 0)
;;                                  (knr-argdecl-intro . -)))
;;   (c-echo-syntactic-information-p . t))
;; "My C Programming Style")
;;(c-add-style "PERSONAL" my-c-style)
;;;;
;;;; Customizations for all modes in CC Mode.
;;;;
;;(defun my-c-mode-common-hook ()
;; ;;(define-key c-mode-base-map "\C-m" 'newline-and-indent)
;; (define-key c-mode-base-map "\C-c\C-c" 'compile)
;; ;; set my personal style for the current buffer
;; (c-set-style "PERSONAL")
;; (setq tab-width 4)
;; (setq c-basic-offset 4)
;; (setq indent-tabs-mode nil)
;; ;; we like auto-newline, but not hungry-delete
;; ;;(c-toggle-auto-newline 0)
;; )
;;(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)
;;
;;;;
;;;; simple XML coloring
;;;;
;;
;;(setq xml-font-lock-keywords
;;     '(("\\(<!--\\(.\\|\n\\)*?-->\\)" 1 font-lock-comment-face)
;;       ("</?\\([^= >]+\\)" 1 font-lock-function-name-face)
;;       ("\\(</?\\|/?>\\)" 1 font-lock-preprocessor-face)
;;       ("\\( [^= ]+=\\)" 1 font-lock-variable-name-face)))
;;
;;(setq xml-mode-hook
;;     '(lambda ()
;;        (setq font-lock-keywords xml-font-lock-keywords)))
;;
;;;;
;;;; hi-lock
;;;;
;;
;;(defun hi-lock-siptrace()
;;  (interactive)
;;  (hi-lock-face-buffer "^.* SIP/2.0$" 'hi-blue)
;;  (hi-lock-face-buffer "^SIP/2.0 [0-9]{3} .*$" 'hi-green))
;;
;;;;
;;;; edit c++ code in latex
;;;;
;;
;;(defun oma-latex-edit-cpp-code ()
;; (interactive)
;; (let ((cur (point)) (beg) (end))
;;   (LaTeX-find-matching-begin)
;;   (beginning-of-line 2)
;;   (setq beg (point))
;;   (goto-char cur)
;;   (LaTeX-find-matching-end)
;;   (beginning-of-line)
;;   (setq end (point))
;;   (copy-region-as-kill beg end)
;;   (find-file "scratch.cpp")
;;   (erase-buffer)
;;   (c++-mode)
;;   (yank)
;;   (save-buffer)))
;;(define-key omakey-map "\C-e" 'oma-latex-edit-cpp-code)
;;
;;;;
;;;; useful Lisp snippets
;;;;
;;
;;(insert (number-to-string (+ 1000 (random 1000))))
;;
;;(load-file "~/.elisp/nasm-mode.el")
;;
;;(require 'tramp)
;;(setq tramp-default-method "scp")
;;(setq-default yank-excluded-properties 't)
;;
;;;;
;;;; Mac stuff
;;;;
;;
;;(setq mac-option-key-is-meta nil)
;;(setq mac-command-key-is-meta 't)
;;(setq mac-command-modifier 'meta)
;;(setq mac-option-modifier nil)
;;
;;;;
;;;; XML
;;;;
;;
;;(defun pretty-print-xml-region (begin end)
;;  "Pretty format XML markup in region. You need to have nxml-mode
;;http://www.emacswiki.org/cgi-bin/wiki/NxmlMode installed to do
;;this.  The function inserts linebreaks to separate tags that have
;;nothing but whitespace between them.  It then indents the markup
;;by using nxml's indentation rules."
;;  (interactive "r")
;;  (save-excursion
;;    (nxml-mode)
;;    (goto-char begin)
;;    ;; split <foo><foo> or </foo><foo>, but not <foo></foo>
;;    (while (search-forward-regexp ">[ \t]*<[^/]" end t)
;;      (backward-char 2) (insert "\n") (incf end))
;;    ;; split <foo/></foo> and </foo></foo>
;;    (goto-char begin)
;;    (while (search-forward-regexp "<.*?/.*?>[ \t]*<" end t)
;;      (backward-char) (insert "\n") (incf end))
;;    (indent-region begin end nil)
;;    (normal-mode))
;;  (message "All indented!"))
;;
;;;;
;;;; org-mode
;;;;
;;
;;(set-variable 'org-regexp "^[=]+")
;;(set-variable 'org-outline-regexp "=+ ")
;;(set-variable 'org-outline-regexp-bol "^=+ ")
;;
;;(require 'octave)
;;(define-key octave-mode-map [(control h)] 'backward-delete-char-untabify)
;;
;;(when (load "flymake" t)
;; (defun flymake-pylint-init ()
;;   (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                      'flymake-create-temp-inplace))
;;          (local-file (file-relative-name
;;                       temp-file
;;                       (file-name-directory buffer-file-name))))
;;         (list "/opt/local/bin/pep8" (list "--repeat" local-file))))
;;
;; (add-to-list 'flymake-allowed-file-name-masks
;;              '("\\.py\\'" flymake-pylint-init)))
;;
;;(defun my-flymake-show-help ()
;;  (when (get-char-property (point) 'flymake-overlay)
;;    (let ((help (get-char-property (point) 'help-echo)))
;;      (if help (message "%s" help)))))
;;
;;(add-hook 'post-command-hook 'my-flymake-show-help)
;;
;;(require 'xcscope)
;;
;;(load "~/.emacs.d/web-mode.el")
;;
;;(defun my-web-mode-hook ()
;;  "Hooks for Web mode."
;;  (setq web-mode-markup-indent-offset 2))
;;
;;(add-hook 'web-mode-hook  'my-web-mode-hook)
;;
;;(setq pop-up-frames 'nil)
;;
;; ensure that we use only rtags checking
;; https://github.com/Andersbakken/rtags#optional-1
;;(defun setup-flycheck-rtags ()
;;  (interactive)
;;  (flycheck-select-checker 'rtags)
;;  ;; RTags creates more accurate overlays.
;;  (setq-local flycheck-highlighting-mode nil)
;;  (setq-local flycheck-check-syntax-automatically nil))
;;
;; only run this if rtags is installed
;; (load "~/sb/rtags/src/rtags.el")
;; (when (require 'rtags nil :noerror)
;;   ;; make sure you have company-mode installed
;;   ;;(require 'company)
;;   (define-key c-mode-base-map (kbd "M-.")
;;     (function rtags-find-symbol-at-point))
;;   (define-key c-mode-base-map (kbd "M-,")
;;     (function rtags-find-references-at-point))
;;   ;; disable prelude's use of C-c r, as this is the rtags keyboard prefix
;;   ;(define-key prelude-mode-map (kbd "C-c r") nil)
;;   ;; install standard rtags keybindings. Do M-. on the symbol below to
;;   ;; jump to definition and see the keybindings.
;;   (rtags-enable-standard-keybindings)
;;   ;; comment this out if you don't have or don't use helm
;;   (setq rtags-use-helm t)
;;   ;; company completion setup
;;   ;;(setq rtags-autostart-diagnostics t)
;;   ;;(rtags-diagnostics)
;;   (setq rtags-completions-enabled t))
;;   ;;(push 'company-rtags company-backends)
;;   ;;(global-company-mode)
;;   ;;(define-key c-mode-base-map (kbd "<C-tab>") (function company-complete)))
;;   ;; use rtags flycheck mode -- clang warnings shown inline
;;   ;(require 'flycheck-rtags)
;;   ;; c-mode-common-hook is also called by c++-mode
;;   ;(add-hook 'c-mode-common-hook #'setup-flycheck-rtags))
;;
;;(defun my-find-file-at-point-with-line ()
;;  "Opens the file at point and goes to line-number."
;;  (interactive)
;;  (let ((fname (ffap-guess-file-name-at-point)))
;;    (if fname
;;      (let ((line
;;             (save-excursion
;;               (goto-char (car ffap-string-at-point-region))
;;               (and (re-search-forward ":\\([0-9]+\\)"
;;                                       (line-end-position) t)
;;                    ;(error (match-string 1))
;;                    (string-to-number (match-string 1))))))
;;               ;;(goto-char (cadr ffap-string-at-point-region))
;;               ;;(and (re-search-backward ":\\([0-9]+\\)"
;;               ;;                         (line-beginning-position) t)
;;               ;;    (string-to-int (match-string 1))))))
;;        (message "file:%s,line:%s" fname line)
;;        (find-file fname)
;;        (when line (goto-line line)))
;;      (error "File does not exist."))))
;;
;;
;;
;;(defun get-point (symbol &optional arg)
;;  "get the point"
;;  (funcall symbol arg)
;;  (point))
;;     
;;(defun copy-thing (begin-of-thing end-of-thing &optional arg)
;;  "copy thing between beg & end into kill ring"
;;  (save-excursion
;;    (let ((beg (get-point begin-of-thing 1))
;;          (end (get-point end-of-thing arg)))
;;      (copy-region-as-kill beg end))))
;;     
;;(defun copy-sexp (&optional arg)
;;  "Copy sexp at point into kill-ring"
;;  (interactive "P")
;;  (copy-thing 'backward-sexp 'forward-sexp arg))
;;
;;(global-set-key (kbd "C-c w")         (quote copy-sexp))
;;
;;(defun vc-git-print-log (files buffer &optional shortlog start-revision limit)
;;  "Print commit log associated with FILES into specified BUFFER.
;;If SHORTLOG is non-nil, use a short format based on `vc-git-root-log-format'.
;;\(This requires at least Git version 1.5.6, for the --graph option.)
;;If START-REVISION is non-nil, it is the newest revision to show.
;;If LIMIT is non-nil, show no more than this many entries."
;;  (let ((coding-system-for-read
;;         (or coding-system-for-read vc-git-log-output-coding-system)))
;;    ;; `vc-do-command' creates the buffer, but we need it before running
;;    ;; the command.
;;    (vc-setup-buffer buffer)
;;    ;; If the buffer exists from a previous invocation it might be
;;    ;; read-only.
;;    (let ((inhibit-read-only t))
;;      (with-current-buffer
;;          buffer
;;	(apply 'vc-git-command buffer
;;	       'async files
;;	       (append
;;		'("log" "--no-color" "--follow")
;;		(when shortlog
;;		  `("--graph" "--decorate" "--date=short"
;;                    ,(format "--pretty=tformat:%s"
;;			     (car vc-git-root-log-format))
;;		    "--abbrev-commit"))
;;		(when limit (list "-n" (format "%s" limit)))
;;		(when start-revision (list start-revision))
;;		'("--")))))))
;;
;;(defun compilation-exit-autoclose (status code msg)
;;  (when (and (eq status 'exit) (zerop code))
;;    (bury-buffer)
;;    (delete-window (get-buffer-window (get-buffer "*compilation*"))))
;;  (cons msg code))
;;(setq compilation-exit-message-function 'compilation-exit-autoclose)
;;
;; pterm -title "A tour of Modern C++" --display :0 -geometry 40x25+1200+250 -fn "monospace 18" -e 'c++ tour.cpp && ./a.out; read'
;;
;;
;;(defun oma-shell (name arg)
;; (interactive)
;; (if (oma-buffer-exist-p name)
;;     (switch-to-buffer name)
;;   (ansi-term "/bin/bash")
;;   (term-line-mode)
;;   (rename-buffer name)))
;;
;;(defun oma-shell (name arg)
;;  (interactive)
;;  (if (oma-buffer-exist-p name)
;;      (switch-to-buffer name)
;;    ;(setq explicit-shell-file-name (and arg "C:/cygwin/bin/bash"))
;;    ;(setq ansi-color-for-comint-mode 't)
;;    (shell)
;;    (rename-buffer name)))
;;
;;(define-key omakey-map "\C-t" 'oma-toggle-tab-width)
;;(define-key omakey-map "\C-o" 'oma-toggle-basic-offset)
;;(define-key omakey-map "f"    'my-find-file-at-point-with-line)
;;(define-key omakey-map "="    '(insert "::printf(### %s %s:%d\n", __PRETTY_FUNCTION__, __FILE__, __LINE__)"))
;;(define-key omakey-map "c"    'oma-shell-exec-string)
;;(define-key omakey-map "\C-c" '(lambda() (interactive) (save-buffer) (shell-command "cd /home/olvmauda/cpptour; c++ tour.cpp && ./a.out")))
;;(define-key omakey-map "\C-n" 'next-error)
;;
;;(defun oma-toggle-tab-width ()
;;  "Toggle between different values (2,4,8) for tab-width."
;;  (interactive)
;;  (cond ((= tab-width 8) (setq tab-width 2))
;;	((= tab-width 2) (setq tab-width 4))
;;	(t (setq tab-width 8))))
;;
;;(defun oma-toggle-basic-offset ()
;;  "Toggle between different values (2,4,8) for c-basic-offset."
;;  (interactive)
;;  (cond ((= c-basic-offset 8) (setq c-basic-offset 2))
;;	((= c-basic-offset 2) (setq c-basic-offset 4))
;;	(t (setq c-basic-offset 8)))
;;  (message "c-basic-offset = %d" c-basic-offset))
;;
;;(define-key omakey-map "." 'my-browse-url)
;;(defun my-browse-url ()
;;  (interactive)
;;  (if (string-match "^[a-f0-9]*$" (thing-at-point 'word))
;;      (browse-url (concat "https://bitbucket-eng-gpk1.cisco.com/bitbucket/projects/ITVM/repos/testcode/commits/" (thing-at-point 'word)))))
;;      ;;(browse-url (concat "http://lys-review.cisco.com/rM" (thing-at-point 'word)))))
;;;;(browse-url (concat "http://lys-critic.cisco.com/system-trunk-main/" (thing-at-point 'word)))))
;;;;https://bitbucket-eng-gpk1.cisco.com/bitbucket/projects/ITVM/repos/testcode/commits/d86b1eef48c1377e876806de6db17f4a54541ad8
;;
;;(defun save-interrupt-and-compile ()
;;  "Save files, Interrupt old compilation, if any, and recompile."
;;  (interactive)
;;  (save-buffer)
;;  (ignore-errors 
;;    (process-kill-without-query 
;;      (get-buffer-process
;;        (get-buffer "*compilation*"))))
;;  (ignore-errors 
;;    (kill-buffer "*compilation*"))
;;  (recompile)
;;)
;;
;;
;;
;; oma-strip-ctrl-h
;;
;; Useful for removing annoying BS characters from the output of fex man pages.
;;
;;
;;(defun oma-strip-ctrl-h (&optional string)
;; "Strip trailing `^H' characters from the current output group.
;;This function could be on `comint-output-filter-functions' or bound to a key."
;; (interactive)
;; (let ((pmark (process-mark (get-buffer-process (current-buffer))))
;;	(pos (if (interactive-p) 
;;		  comint-last-input-end 
;;		comint-last-output-start)))
;;   (if (marker-position pos)
;;	(save-excursion
;;	  (goto-char pos)
;;	  (while (re-search-forward ".\b" pmark t)
;;	    (replace-match "" t t))))))
;;
;;
;;(defun oma-save-and-recompile ()
;; "Save current buffer and recompile"
;; (interactive)
;; (save-buffer)
;; (recompile))
;;
;;(global-set-key [(control W)] 'delete-region)
;;(global-set-key [(control N)] '(lambda () (interactive) (scroll-up 1) (next-line 1)))
;;(global-set-key [(control P)] '(lambda () (interactive) (scroll-down 1) (previous-line 1)))
;;(define-key global-map '[(control \.)] 'call-last-kbd-macro) ; does not work in WT
;;
;;(setq progress-feedback-use-echo-area 't)
;;(setq compilation-scroll-output 't)
;;(setq compilation-always-kill 't)
;;(setq compilation-window-height 5)
;;(setq split-width-threshold 20)
;;(setq split-height-threshold 20)
;;(paren-set-mode 'sexp)
;;(font-lock-mode 't)
;;(setq load-home-init-file 't)
;;(setq-default indent-tabs-mode 'nil)
;;(setq indent-tabs-mode 'nil)
;;(setq truncate-partial-width-windows 'nil)
;;(setq revert-without-query '(".java"))
;;(set-face-background 'default "white") ;; M-x list-colors-display
;;(set-face-background 'default "black") ;; M-x list-colors-display
;;(set-face-background 'default "light goldenrod")
;;(set-face-background 'default "white")
;;(set-default-font "-misc-fixed-medium-r-semicondensed--13-120-75-75-c-60-iso8859-1")
;;(set-default-font "-misc-fixed-medium-r-normal--13-120-75-75-c-70-iso8859-1")
;;
;;(setenv "PYTHONIOENCODING" "utf-8")

(message ".emacs completed")
