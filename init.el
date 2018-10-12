;;; Init -- init.el:
;;; Documentation:
;; My Emacs config with evil.

;;; Code:

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
	("d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default)))
 '(package-selected-packages
   (quote
	(diminish flycheck-ycmd js2-mode ess ess-site powerline rainbow-mode web-mode json-reformat json-mode markdown-mode restart-emacs auctex clang-format evil auto-package-update rust-mode flycheck-rust company-anaconda anaconda-mode company-php php-mode auctex-latexmk company-auctex tide typescript-mode general srefactor helm-gtags-mode helm-gtags ycmd org-ref org-bullets helm-projectile git-timemachine helm-tramp help-projectile fcitx which-key use-package solarized-theme rainbow-delimiters neotree helm flycheck evil-magit dashboard company ace-popup-menu))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Larger garbage collection invocation buffer
(setq gc-cons-threshold-original gc-cons-threshold)
(setq gc-cons-threshold 100000000)
(setq file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)
;; Restore values after time
(run-with-idle-timer
 3 nil
 (lambda ()
   (setq gc-cons-threshold gc-cons-threshold-original)
   (setq file-name-handler-alist file-name-handler-alist-original)
   (makunbound 'gc-cons-threshold-original)
   (makunbound 'file-name-handler-alist-original)
   (message "gc-cons-threshold and file-name-handler-alist restored")))

;; UTF-8 please
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

(setq user-full-name "Jorrit Gerets"
      user-mail-address "contact@jorrit.info")

;; Disable toolbar / ui
(tool-bar-mode -1)
(menu-bar-mode -1)
(toggle-scroll-bar -1)

;; Tabs and width
(setq-default tab-width 4)
(setq-default c-basic-offset 4)

;; Fix cjk font thingies
;; From: https://coldnew.github.io/d5011be2/
(defvar emacs-english-font "Source Code Pro"
  "The font name of English.")

(defvar emacs-cjk-font "Source Han Code JP R"
  "The font name for CJK.")

(defvar emacs-font-size-pair '(15 . 18)
  "Default font size pair for (english . chinese).")

(defvar emacs-font-size-pair-list
  '(( 5 .  6) (10 . 12)
    (13 . 16) (15 . 18) (17 . 20)
    (19 . 22) (20 . 24) (21 . 26)
    (24 . 28) (26 . 32) (28 . 34)
    (30 . 36) (34 . 40) (36 . 44))
  "This list is used to store matching (english . chinese) font-size.")

(defun font-exist-p (fontname)
  "Test if FONTNAME exists or not."
  (if (or (not fontname) (string= fontname ""))
      nil
    (if (not (x-list-fonts fontname)) nil t)))

(defun set-font (english chinese size-pair)
  "Setup ENGLISH and CHINESE font in xorg for SIZE-PAIR."

  (if (font-exist-p english)
      (set-frame-font (format "%s:pixelsize=%d" english (car size-pair)) t))

  (if (font-exist-p chinese)
      (dolist (charset '(kana han symbol cjk-misc bopomofo))
        (set-fontset-font (frame-parameter nil 'font) charset
                          (font-spec :family chinese :size (cdr size-pair))))))

(defun emacs-step-font-size (step)
  "Increase/Decrease font size by STEP."
  (let ((scale-steps emacs-font-size-pair-list))
    (if (< step 0) (setq scale-steps (reverse scale-steps)))
    (setq emacs-font-size-pair
          (or (cadr (member emacs-font-size-pair scale-steps))
              emacs-font-size-pair))
    (when emacs-font-size-pair
      (message "emacs font size set to %.1f" (car emacs-font-size-pair))
      (set-font emacs-english-font emacs-cjk-font emacs-font-size-pair))))

(defun increase-emacs-font-size ()
  "Decrease font-size acording emacs-font-size-pair-list."
  (interactive) (emacs-step-font-size 1))

(defun decrease-emacs-font-size ()
  "Increase font-size acording emacs-font-size-pair-list."
  (interactive) (emacs-step-font-size -1))

(global-set-key (kbd "C-=") 'increase-emacs-font-size)
(global-set-key (kbd "C--") 'decrease-emacs-font-size)

;; Toggle CJK
(defun cjk-enable ()
	"Enable CJK input / font setup."
	(interactive)
	;; (setenv "LC_CTYPE"  "ja_JP.UTF-8")
	(set-font emacs-english-font emacs-cjk-font emacs-font-size-pair)
    	(set-frame-font "Source Code Pro 11"))

;; Font setup for JP locale
(if (string= (getenv "LC_CTYPE") "ja_JP.UTF-8")
    (cjk-enable))

(set-frame-font "Source Code Pro 11")
(setq default-frame-alist '((font . "Source Code Pro 11")))

(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

(defun switch-to-home-buffer ()
  "Switch to the dashboard buffer."
  (interactive)
  (switch-to-buffer "*dashboard*"))

(defun my-inhibit-startup-screen-file ()
  "Startup screen inhibitor for `command-line-functions`.
Inhibits startup screen on the first unrecognised option which
names an existing file."
  (ignore
   (setq inhibit-startup-screen
         (file-exists-p
          (expand-file-name argi command-line-default-directory)))))

(add-hook 'command-line-functions #'my-inhibit-startup-screen-file)

;; Debugging setup
(setq gdb-many-windows t)

;; Color in compilation buffer (for cmake mostly)
(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (toggle-read-only)
  (ansi-color-apply-on-region compilation-filter-start (point))
  (toggle-read-only))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

;; Setup packages
(package-initialize)
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
(package-install 'use-package))
(eval-when-compile
  (require 'use-package))

;; Setup theme
(use-package solarized-theme
  :ensure t
  :config
  (load-theme 'solarized-light))

;; Nice dashboard and overview
(use-package dashboard
  :ensure t
  :init
  (setq dashboard-items '((recents  . 15)
                          (projects . 10)
                          (bookmarks . 5)))
  (setq dashboard-banner-logo-title "Welcome to Shuttlemacs")
  :config
  (dashboard-setup-startup-hook))

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

;; Fold codeblocks
(use-package hideshow
  :hook (prog-mode . hs-minor-mode))

;; Easier keybindings so we can do more lazy loading
(use-package general
  :ensure t
  :config
  (general-create-definer my-leader-def
	;; :prefix my-leader
	:prefix "SPC")
  (general-create-definer local-leader-def
	;; :prefix local-leader
	:prefix ","))

;; Update packages
(use-package auto-package-update
  :ensure t
  :init
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  ;; (auto-package-update-maybe)
  :config
  (defun update-packages ()
	(interactive)
	(auto-package-update-maybe))
  :general
  (my-leader-def
	:states 'normal
	:keymaps 'dashboard-mode-map
	"U" 'update-packages))

(use-package restart-emacs
  :ensure t
  :general
  (my-leader-def
	:states 'normal
	:keymaps 'dashboard-mode-map
	"R" 'restart-emacs))

;; Recent files
(use-package recentf
  :ensure t
  :commands (recentf-mode)
  :hook (after-init . recentf-mode)
  :init
  (setq recentf-max-menu-items 25)
  :general
  (my-leader-def
	:states 'normal
	"bl" 'recentf-open-files)
  (general-define-key "\C-x\ \C-r" 'recentf-open-files))

;; Nice ace popup
(use-package ace-popup-menu
  :ensure t
  :hook (after-init . ace-popup-menu-mode))

;; Which key to show keyboard bindings
(use-package which-key
  :ensure t
  :hook (after-init . which-key-mode)
  :init
  (setq which-key-idle-delay 0.3))

;; Global autocompletion
(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :init
  (setq company-minimum-prefix-length 2)
  (setq company-idle-delay 0.2))

;; Global syntax checking
(use-package flycheck
  :ensure t
  :hook (after-init . global-flycheck-mode))

;; Fcitx input setup
(use-package fcitx
  :ensure t
  :init
  (setq fcitx-use-dbus t)
  :hook (after-init . fcitx-aggressive-setup))

;; Nice things with helm
(use-package helm
  :ensure t
  :hook (after-init . helm-mode)
  :commands (helm-autoresize-mode)
  :init
  ;; (defvar helm-google-suggest-use-curl-p)
  (defvar helm-ff-search-library-in-sexp)
  (defvar helm-echo-input-in-header-line)
  (defvar helm-ff-file-name-history-use-recentf)
  :general
  (general-define-key
   "M-x" 'helm-M-x
   "M-:" 'helm-eval-expression
   "C-c h" 'helm-command-prefix)
  (general-define-key
   :keymaps 'helm-map
   "<tab>" 'helm-execute-persistent-action
   "C-i" 'helm-execute-persistent-action
   "C-z" 'helm-select-action)
  (my-leader-def
	:states 'normal
	"bb" 'helm-buffers-list
	"ff" 'helm-find-files
	"p" 'helm-show-kill-ring)
  :config
  (setq helm-split-window-inside-p           t ; open helm buffer inside current window, not occupy whole other window
	helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
	helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
	helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
	helm-ff-file-name-history-use-recentf t
	helm-echo-input-in-header-line t)

  ;; Hide some autogenerated files from helm
  (setq helm-ff-skip-boring-files t)
  ;; (add-to-list 'helm-boring-file-regexp-list "\\~$")
  
  (setq helm-autoresize-max-height 0)
  (setq helm-autoresize-min-height 20)
  (helm-autoresize-mode 1)

  (use-package helm-projectile
	:ensure t
	:defer nil
	:general
	(my-leader-def
	  :states 'normal
      "r" 'helm-projectile-grep)
	:config
	(helm-projectile-on))
  
  (use-package helm-tramp
	:ensure t
	:general
	(my-leader-def
	  :states 'normal
	  "ft" 'helm-tramp))
  
  (use-package helm-gtags-mode
	:ensure helm-gtags
	:hook (c-mode c++-mode)
	:general
	(local-leader-def
	  :states 'normal
	  :keymaps '(c++-mode-map c-mode-map)
	  "f" 'helm-gtags-find-tag
	  "j" 'helm-gtags-dwim
	  "g" '(:ignore t :which-key "gtags")
	  "gp" 'helm-gtags-find-pattern
	  "gr" 'helm-gtags-find-rtag
	  "gP" 'helm-gtags-find-files
	  "gp" 'helm-gtags-find-pattern
	  "gf" 'helm-gtags-parse-file
	  "gg" 'helm-gtags-create-tags
	  "gu" 'helm-gtags-update-tags
	  "gc" 'helm-gtags-clear-cache)))


(use-package evil
  :ensure t
  :hook (after-init . evil-mode)
  :general
  (my-leader-def
	:states 'normal
    "b" '(:ignore t :which-key "buffer")
    "g" '(:ignore t :which-key "magit")
    "f" '(:ignore t :which-key "files")
	"bk" 'kill-this-buffer
	"bd" 'kill-other-buffers
	"bh" 'switch-to-home-buffer
	"br" 'revert-buffer
	"h" 'split-window-vertically
	"v" 'split-window-horizontally
    ;; CJK toggle
    "c" 'cjk-enable)
  (local-leader-def
	:states 'normal
    ;; General lang options
	"c" 'compile
	"d" (defun debugger ()
		  (interactive)
		  (select-frame (make-frame))
		  (command-execute 'gdb)))
  (local-leader-def
	:states 'normal
	:keymaps 'gdb-mode-map
	;; TODO gdb keymaps
	))

(use-package evil-magit
  :ensure t
  :hook (magit-mode . evil-magit-init)
  :general
  (my-leader-def
	:states 'normal
	;; Magit
	"gd" 'magit-dispatch-popup
	"gs" 'magit-status
	"gb" 'magit-blame))

(use-package git-timemachine
  :ensure t
  :general
  (my-leader-def
	:states 'normal
	"gt" 'git-timemachine-toggle))

(use-package neotree
  :ensure t
  :general
  (my-leader-def
	:states 'normal
	"t" 'neotree-toggle)
  (general-define-key
   :states 'normal
   :keymaps 'neotree-mode-map
   "TAB" 'neotree-enter
   "SPC" 'neotree-quick-look
   "q" 'neotree-hide
   "t" 'neotree-toggle
   "r" 'neotree-refresh
   "RET" 'neotree-enter))

(use-package powerline
  :ensure t
  :commands (powerline-default-theme)
  :hook (after-init . powerline-default-theme))

;;(use-package smart-mode-line
;;  :ensure t
;;  :config
;;  (sml/setup))

(use-package org
  :ensure t
  :pin "org"
  :general
  (local-leader-def
    :states 'normal
    :keymaps 'org-mode-map
	"e" 'org-export-dispatch
	"x" 'org-table-export
	"." 'org-time-stamp
	"t" 'org-twbs-export-to-html
	"s" 'org-schedule
	"d" 'org-deadline
	"'" 'org-edit-special)
  :config
  ;; log todo items with timestamp
  (setq org-log-done 'time)
  
  (setq org-latex-pdf-process
		'("pdflatex -interaction nonstopmode -output-directory %o %f"
		  "bibtex %b"
		  "pdflatex -interaction nonstopmode -output-directory %o %f"
		  "pdflatex -interaction nonstopmode -output-directory %o %f"))

  ;; Compile command
  ;; (setq org-latex-pdf-process
  ;; '("pdflatex %f" "bibtex %b" "pdflatex %f" "pdflatex %f"))
  (setq org-latex-pdf-process
		'("pdflatex -interaction nonstopmode -output-directory %o %f"
          "bibtex %b"
          "pdflatex -interaction nonstopmode -output-directory %o %f"
          "pdflatex -interaction nonstopmode -output-directory %o %f"))

  ;; Preamble template for documents
  (add-to-list 'org-structure-template-alist
			   '("P" "#+TITLE:
#+SUBTITLE:
#+AUTHOR: Jorrit Gerets
#+EMAIL: contact@jorrit.info
#+OPTIONS: \":t toc:nil
#+LATEX_CLASS: article
#+LATEX_CLASS_OPTIONS: [a4paper]
#+LATEX_HEADER: \\usepackage[margin=1.1in]{geometry}
#+LATEX_HEADER: \\renewcommand\\maketitle{}
#+LATEX_HEADER: \\usepackage{fancyhdr}
#+LATEX_HEADER: \\usepackage{vmargin}
#+LATEX_HEADER: \\graphicspath{/home/jorrit/Sync/Universiteit/Images}
"))
  (add-to-list 'org-structure-template-alist
			   '("T" "#+BEGIN_EXPORT latex
\\makeatletter
\\begin{titlepage}
  \\centering
  \\vspace*{0.5 cm}
  \\includegraphics[scale = 0.75]{logo.png}\\\\[1.0 cm]  % University Logo
  \\textsc{\\LARGE Universiteit Hasselt}\\\\[2.0 cm]  % University Name
  \\textsc{\\Large VAK/OPDRACHT}\\\\[0.5 cm]               % Course Code
  \\rule{\\linewidth}{0.2 mm} \\\\[0.4 cm]
  { \\huge \\bfseries \\@title}\\\\
  \\rule{\\linewidth}{0.2 mm} \\\\[1.5 cm]
  \\begin{minipage}{0.4\\textwidth}
    \\begin{flushleft} \\large
      \\emph{Submitted To:}\\\\
      Prof. ... whatever \\\\
      Dept. XYZ\\\\
    \\end{flushleft}
  \\end{minipage}~
  \\begin{minipage}{0.4\\textwidth}
    \\begin{flushright} \\large
      \\emph{Submitted By :} \\\\
      \\@author\\\\
      1541396\\\\
    \\end{flushright}
  \\end{minipage}\\\\[2 cm]
\\end{titlepage}
#+END_EXPORT"))

  (add-to-list 'org-structure-template-alist
			   '("B" "bibliographystyle:unsrt
bibliography:/home/jorrit/Sync/Universiteit/references.bib"))
	
  (use-package org-bullets-mode
	:ensure org-bullets
	:hook org-mode)

  (use-package org-ref
	:ensure t
	:config
	(local-leader-def
	  :states 'normal
	  "u" 'org-ref-helm-insert-cite-link)
	:init
	;; Bibtex references
	(setq org-ref-default-bibliography "/home/jorrit/Sync/Universiteit/references.bib")
	(setq reftex-default-bibliography '("/home/jorrit/Sync/Universiteit/references.bib"))))

;; C and C++ config
(use-package clang-format
  :ensure t
  :general
  (local-leader-def
   :states 'normal
   :modes '(c-mode-map c++-mode-map)
   "b" '(:ignore t :which-key "buffer")
   "bf" 'clang-format-buffer)
  :init
  (setq-default clang-format-style "{BasedOnStyle: llvm, IndentWidth: 4}"))


(use-package ycmd-mode
  :ensure ycmd
  :hook (c-mode c++-mode)
  :general
  (my-leader-def
	:states 'normal
	"y" 'ycmd-mode)
  :init
  (set-variable 'ycmd-server-command `("/usr/bin/python2" ,(file-truename "/usr/share/vim/vimfiles/third_party/ycmd/ycmd/")))
  (set-variable 'ycmd-global-config "/home/jorrit/.emacs.d/lang/ycm_conf.py")
  (set-variable 'ycmd-extra-conf-whitelist '("/home/jorrit/Dev/*" "/home/jorrit/Sync/Universiteit/*"))
;;   :config
  (use-package company-ycmd
	:ensure t
  	:commands (company-ycmd-setup)
  	:hook (ycmd-mode . company-ycmd-setup))
  
  (use-package flycheck-ycmd
	:ensure t
	:commands (flycheck-ycmd-setup)
	:hook (ycmd-mode . flycheck-ycmd-setup)
	:config
	;; (setq flycheck-clang-language-standard "c++11")
	(when (not (display-graphic-p))
      (setq flycheck-indication-mode nil))))

;; (use-package flex-mode
;;   :mode "\\.lex\\'"
;;   :interpreter "flex"
;;   :load-path "lang/")

(use-package bison-mode
  :mode "\\.lex\\'"
  :interpreter "bison"
  :load-path "lang/")

;; (use-package srefactor
;;   :ensure t
;;   :commands (srefactor-refactor-at-point)
;;   :hook ((c-mode c++-mode) . semantic-mode)
;;   :general
;;   (local-leader-def
;;    :states 'normal
;;    :keymaps '(c++-mode-map c-mode-map)
;;    "r" 'srefactor-refactor-at-point))

;; Javascript (typescript) config
(use-package typescript-mode
  :ensure t
  :mode "\\.ts\\'"
  :interpreter "typescript"
  :config
  (use-package tide
	:ensure t
	:commands (tide-setup)
	:hook (typescript-mode . tide-setup)
	:general
	(local-leader-def
	  :states 'normal
	  :keymaps 'typescript-mode-map
	  "c" 'tide-compile-file
	  "f" 'tide-format
	  "r" 'tide-restart-server
	  "m" 'tide-fix
	  "p" 'tide-project-errors)))

;; Latex config
(use-package tex
  :ensure auctex
  :init
  (setq TeX-PDF-mode t)
  :general
  (local-leader-def
	:states 'normal
	:keymaps 'LaTeX-mode-map
	"c" 'Tex-command-master)
  :config
  (use-package company-auctex
	:ensure t
	:commands (company-auctex-init)
	:hook (LaTeX-mode . company-auctex-init)))

;; (use-package auctex-latexmk
;;   :ensure t
;;  :hook (LaTeX-mode . auctex-latexmk-setup))
;;  :general
;;  (local-leader-def
;;   :states 'normal
;;   :keymaps 'LaTeX-mode-map
;;   "c" 'output-pdf))

;; PHP config
(use-package php-mode
  :ensure t
  :mode "\\.php\\'"
  :interpreter "php"
  :config
  (use-package company-php
    :ensure t
    :config
    (ac-php-core-eldoc-setup) ;; enable eldoc
    (make-local-variable 'company-backends)
    (add-to-list 'company-backends 'company-ac-php-backend)))

;; Python config
(use-package anaconda-mode
  :ensure t
  :hook python-mode
  :config
  (use-package company-anaconda
    :ensure t
    :config
    (eval-after-load "company"
      '(add-to-list 'company-backends 'company-anaconda)))
  
  (defun python2-enable ()
    "Set python2 as default python."
    (interactive)
    (setq flycheck-python-pycompile-executable "/usr/bin/python2")
    (setq flycheck-python-flake8-executable "/usr/bin/flake8-python2")
    (setq flycheck-python-pylint-executable "/usr/bin/pylint2")
    (setq python-shell-interpreter "/usr/bin/python2")
    (flycheck-buffer))

  (defun python2-disable ()
    "Go back to default python."
    (interactive)
    (setq flycheck-python-pycompile-executable "/usr/bin/python")
    (setq flycheck-python-flake8-executable "/usr/bin/flake8")
    (setq flycheck-python-pylint-executable "/usr/bin/pylint")
    (setq python-shell-interpreter "/usr/bin/python")
    (flycheck-buffer))
  :general
  (local-leader-def
   :states 'normal
   :keymaps 'python-mode-map
   "e" 'python2-enable
   "d" 'python2-disable
   "r" 'run-python
   "b" 'python-shell-send-buffer
   "f" 'python-shell-send-file))
    
;; Rust config
(use-package rust-mode
  :ensure t
  :mode "\\.rs\\'"
  :interpreter "rust"
  :config
  (use-package flycheck-rust
    :ensure t
    :hook (rust-mode . flycheck-rust-setup))
  (use-package racer
	:ensure t
	:hook (rust-mode . racer-mode))
  :general
  (local-leader-def
   :states 'normal
   :keymaps 'rust-mode-map
   "f" 'rust-format-buffer))

;; Markdown config
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode)
  :mode "\\.md\\'"
  :interpreter "markdown")

;; json config
(use-package json-mode
  :ensure t
  :commands (json-mode)
  :mode "\\.json\\'"
  :interpreter "json"
  :config
  (use-package json-reformat
	:ensure t
	:general
	(local-leader-def
	  :states '(normal visual)
	  :keymaps 'json-mode-map
	  "f" 'json-reformat-region)))

;; Javascript config
(use-package js2-mode
  :ensure t
  :mode "\\.js\\'"
  :interpreter "javascript")

;; Web mode config
(use-package web-mode
  :ensure t
  :mode "\\.html?\\'"
  :init
  (setq web-mode-markup-indent-offset 4)
  (setq web-mode-css-indent-offset 4)
  (setq web-mode-code-indent-offset 4))

(use-package rainbow-mode
  :ensure t
  :hook (css-mode web-mode))

;; R statistics config
(use-package ess-r-mode
  :ensure ess
  :mode "\\.r\\'"
  :general
  (local-leader-def
	:states '(normal visual)
	:keymaps 'ess-mode-map
	;; "e" '(:ignore t :which-key "eval")
	"b" 'ess-eval-buffer
	"r" 'ess-eval-region
	"l" 'ess-eval-line
	"f" 'ess-eval-function
	"F" 'ess-load-file
	"q" 'ess-quit
	"`" 'ess-show-traceback))

;; Hide some always used minor modes from mode line
(use-package diminish
  :ensure t
  :after (dashboard company)
  :config
  (diminish 'company-mode)
  (diminish 'helm-mode)
  (diminish 'flycheck-mode)
  (diminish 'undo-tree-mode)
  (diminish 'projectile-mode)
  (diminish 'eldoc-mode)
  (diminish 'which-key-mode)
  (diminish 'hs-minor-mode)
  (diminish 'page-break-lines-mode)
  (diminish 'abbrev-mode)
  (diminish 'helm-gtags-mode))

;;; init.el ends here
