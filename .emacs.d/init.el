;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

(require 'cask "~/.cask/cask.el")
(cask-initialize)

(require 'elscreen)
(elscreen-start)
(setq elscreen-prefix-key "\C-z")

(require 'undo-tree)
(global-undo-tree-mode)

(require 'browse-kill-ring)
(global-set-key "\C-cy" 'browse-kill-ring)

(require 'helm-config)
(require 'helm-gtags)
(global-set-key "\M-t" 'helm-gtags-find-tag)
(global-set-key "\M-r" 'helm-gtags-find-rtag)
(global-set-key "\M-s" 'helm-gtags-find-symbol)
(global-set-key "\M-p" 'helm-gtags-find-pattern)
(global-set-key "\M-f" 'helm-gtags-find-files)
(global-set-key "\M-q" 'helm-gtags-pop-stack)

(require 'zlc)

(require 'color-theme)
(color-theme-initialize)
(color-theme-ld-dark)

(require 'popwin)
(popwin-mode 1)
;; M-x anything
(setq anything-samewindow nil)
(push '("*anything*" :height 20) popwin:special-display-config)
;; M-x dired-jump-other-window
(push '(dired-mode :position top) popwin:special-display-config)
;; M-!
(push "*Shell Command Output*" popwin:special-display-config)
;; M-x compile
(push '(compilation-mode :noselect t) popwin:special-display-config)
;; undo-tree
(push '(" *undo-tree*" :width 0.3 :position right) popwin:special-display-config)

;; lang, encoding
(set-language-environment "japanese")
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)

;; base
(setq inhibit-startup-message t)
(setq ring-bell-function nil)
(setq visible-bell nil)
(blink-cursor-mode 0)
(menu-bar-mode 0)
(tool-bar-mode 0)
(line-number-mode t)
(column-number-mode t)
(setq make-backup-files nil)
(setq auto-save-default nil)
(delete-selection-mode 1)
(setq-default indent-tabs-mode nil)
(setq require-final-newline t)
(setq next-line-add-newlines nil)
(global-set-key "\C-h" 'delete-backward-char)
(global-set-key "\C-x?" 'help)
(auto-image-file-mode t)
(auto-compression-mode t)
(global-linum-mode t)
(setq linum-format " %d ")

;; window
(setq frame-title-format `(" %b ", " @ ",(system-name) " -- " ,emacs-version))
(setq truncate-partial-width-windows nil)
(setq scroll-conservatively 1)
(defun window-resizer ()
  "Control window size and position."
  (interactive)
  (let ((window-obj (selected-window))
        (current-width (window-width))
        (current-height (window-height))
        (dx (if (= (nth 0 (window-edges)) 0) 1
              -1))
        (dy (if (= (nth 1 (window-edges)) 0) 1
              -1))
        action c)
    (catch 'end-flag
      (while t
        (setq action
              (read-key-sequence-vector (format "size[%dx%d]"
                                                (window-width)
                                                (window-height))))
        (setq c (aref action 0))
        (cond ((= c ?l)
               (enlarge-window-horizontally dx))
              ((= c ?h)
               (shrink-window-horizontally dx))
              ((= c ?j)
               (enlarge-window dy))
              ((= c ?k)
               (shrink-window dy))
              ;; otherwise
              (t
               (let ((last-command-char (aref action 0))
                     (command (key-binding action)))
                 (when command
                   (call-interactively command)))
               (message "Quit")
               (throw 'end-flag t)))))))
(define-key global-map "\C-q" (make-sparse-keymap))
(global-set-key "\C-q\C-q" 'quoted-insert)
(global-set-key "\C-q\C-r" 'window-resizer)
(global-set-key "\C-ql" 'windmove-right)
(global-set-key "\C-qh" 'windmove-left)
(global-set-key "\C-qj" 'windmove-down)
(global-set-key "\C-qk" 'windmove-up)
(global-set-key "\C-xp" (lambda () (interactive) (other-window -1)))

;; mini buffer, mode line
(setq completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)
(setq-default mode-line-format
              '("-" mode-line-mule-info mode-line-modified
                mode-line-frame-identification  mode-line-buffer-identification
                " " global-mode-string " %[(" mode-name mode-line-process
                minor-mode-alist "%n" ")%]-" (which-func-mode ("" which-func-format "-"))
                (line-number-mode "L%l-")(column-number-mode "C%c-")(-3 . "%p")"-%-")
              )
(column-number-mode 1)
(line-number-mode t)
(setq display-time-string-forms
      '(month "/" day "(" dayname ")" 24-hours ":" minutes))
(display-time)
(add-hook 'lisp-interaction-mode-hook '(lambda () (setq mode-name "Lisp-Int")))
(add-hook 'emacs-lisp-mode-hook       '(lambda () (setq mode-name "Elisp")))
(let ((elem (assq 'encoded-kbd-mode minor-mode-alist)))
  (when elem    (setcar (cdr elem) "")))
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-ignore-buffers-re "*[^*]+*")
(setq line-number-display-limit 1000000)

;; highlight
(global-font-lock-mode t)
(show-paren-mode t)
;(set-face-background 'show-paren-match-face "RoyalBlue1")
;(set-face-foreground 'show-paren-match-face "AntiqueWhite")
;(set-face-background 'show-paren-mismatch-face "Red")
;(set-face-foreground 'show-paren-mismatch-face "black")
;(setq show-paren-ring-bell-on-mismatch t)
;(setq show-paren-style 'mixed)
(transient-mark-mode t)
(setq search-highlight t)
(setq query-replace-highlight t)
(defface my-face-b-1 '((t (:background "medium aquamarine"))) nil)
;(defface my-face-b-2 '((t (:background "gray"))) nil)
(defface my-face-u-1 '((t (:foreground "SteelBlue" :underline t))) nil)
(defvar my-face-b-1 'my-face-b-1)
;(defvar my-face-b-2 'my-face-b-2)
(defvar my-face-u-1 'my-face-u-1)
(defadvice font-lock-mode (before my-font-lock-mode ())
  (font-lock-add-keywords
   major-mode
   '(("　" 0 my-face-b-1 append)
;     ("\t" 0 my-face-b-2 append)
     ("\t" 0 my-face-u-1 append)
     ("[ \t]+$" 0 my-face-u-1 append)
     )))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)
(hl-line-mode 1)
(setq hl-line-face 'underline)
(defface my-face-f-2 '((t (:foreground "GreenYellow"))) nil)
(defvar my-face-f-2 'my-face-f-2)
(defun my-dired-today-search (arg)
  "Fontlock search function for dired."
  (search-forward-regexp
   (concat (format-time-string "%b %e" (current-time)) " [0-9]....") arg t))
(add-hook 'dired-mode-hook
          '(lambda ()
             (font-lock-add-keywords
              major-mode
              (list
               '(my-dired-today-search . my-face-f-2)
            ))))

;; coding(C/C++)
(defconst my-c-style
  '(
    (c-basic-offset             . 4)
    (c-tab-always-indent        . t)
    (c-comment-only-line-offset . 0)
;    (c-hanging-braces-alist     . ((substatement-open after)
;                                   (brace-list-open)))
    (c-hanging-colons-alist     . ((member-init-intro before)
                                   (inher-intro)
                                   (case-label after)
                                   (label after)
                                   (access-label after)))
    (c-cleanup-list             . (scope-operator
                                   empty-defun-braces
                                   defun-close-semi))
    (c-offsets-alist            . ((arglist-close . c-lineup-arglist)
                                   (substatement-open . 0)
                                   (label             . 0)
                                   (case-label        . 0)
                                   (block-open        . 0)
                                   (knr-argdecl-intro . -)))
    (c-echo-syntactic-information-p . t)
    )
  "My C Programming Style")
(setq fill-column 120)
(setq-default auto-fill-mode nil)
;; offset customizations not in my-c-style
(setq c-offsets-alist '((member-init-intro . ++)))
;; Customizations for all modes in CC Mode.
(defun my-c-mode-common-hook ()
  ;; add my personal style and set it for the current buffer
  (c-add-style "PERSONAL" my-c-style t)
  ;; other customizations
  (setq tab-width 8
        ;; this will make sure spaces are used instead of tabs
        indent-tabs-mode nil)
  ;; we like auto-newline and hungry-delete
  (c-toggle-auto-hungry-state t)
  ;; key bindings for all supported languages.  We can put these in
  ;; c-mode-base-map because c-mode-map, c++-mode-map, objc-mode-map,
  ;; java-mode-map, idl-mode-map, and pike-mode-map inherit from it.
  (define-key c-mode-base-map "\C-m" 'c-context-line-break)
  )
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)
;; .h in c++mode
(setq auto-mode-alist
      (append '(("\\.h$" . c++-mode))
              auto-mode-alist))

;; GDB
(setq gdb-many-windows t)
(setq gdb-use-separate-io-buffer t)

;; VC
(add-hook 'dired-mode-hook
          '(lambda ()
             (require 'dired-x)
             ;(define-key dired-mode-map "V" 'cvs-examine)
             (define-key dired-mode-map "V" 'vc-dir)
             (turn-on-font-lock)
             ))
(setq svn-status-hide-unmodified t)
(setq process-coding-system-alist
      (cons '("svn" . utf-8) process-coding-system-alist))
(setq svn-status-svn-process-coding-system 'utf-8)
(eval-after-load "vc-hooks"
   '(define-key vc-prefix-map "=" 'ediff-revision))
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
(setq ediff-split-window-function 'split-window-horizontally)
(setq ediff-keep-variants nil)

(add-hook 'log-view-mode-hook
          (lambda ()
            (local-set-key (kbd "RET") 'log-view-find-revision)
            (local-set-key (kbd "C-c C-c") 'log-view-find-revision)
            (local-set-key (kbd "=") 'log-view-diff)
            (local-set-key (kbd "g") 'log-view-annotate-version)))

(add-hook 'log-view-mode-hook
          (lambda ()
            (local-set-key (kbd "e") 'log-view-ediff)))

(defun log-view-ediff (beg end &optional startup-hooks)
  (interactive
   (list (if mark-active (region-beginning) (point))
         (if mark-active (region-end) (point))))
  (let ((fr (log-view-current-tag beg))
        (to (log-view-current-tag end)))
    (when (string-equal fr to)
      (save-excursion
        (goto-char end)
        (log-view-msg-next)
        (setq to (log-view-current-tag))))
    (require 'ediff-vers)
    (ediff-vc-internal fr to startup-hooks)))

(defun log-view-ediff-setup ()
  (set (make-local-variable 'ediff-keep-tmp-versions) t))

(defvar log-view-ediff-window-configuration nil)
(defun log-view-ediff-before-setup ()
  (setq log-view-ediff-window-configuration 
        (if (eq this-command 'log-view-ediff)
            (current-window-configuration)
          nil)))
(defun log-view-ediff-cleanup ()
  (when log-view-ediff-window-configuration
    (ignore-errors
      (set-window-configuration log-view-ediff-window-configuration)))
  (setq log-view-ediff-window-configuration nil))

(require 'ediff-init)
(add-hook 'ediff-mode-hook 'log-view-ediff-setup)
(add-hook 'ediff-before-setup-hook 'log-view-ediff-before-setup)
;; add it after ediff-cleanup-mess
(add-hook 'ediff-quit-hook 'log-view-ediff-cleanup t)
