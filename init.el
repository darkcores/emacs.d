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
	(rust-mode flycheck-rust company-anaconda anaconda-mode company-php php-mode auctex-latexmk company-auctex tide typescript-mode general srefactor helm-gtags-mode helm-gtags ycmd org-ref org-bullets helm-projectile git-timemachine helm-tramp help-projectile fcitx which-key use-package solarized-theme rainbow-delimiters neotree helm flycheck evil-magit dashboard company ace-popup-menu))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

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
	(set-font emacs-english-font emacs-cjk-font emacs-font-size-pair)
    	(set-frame-font "Source Code Pro 11"))

;; Font setup for JP locale
(if (string= (getenv "LC_CTYPE") "ja_JP.UTF-8")
    (cjk-enable))

(set-frame-font "Source Code Pro 11")

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

;; Setup packages
(package-initialize)
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/"))
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
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-banner-logo-title "Welcome to Shuttlemacs")
  (setq dashboard-items '((recents  . 10)
                          (projects . 5)
                          (agenda . 5))))

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

;; Recent files
(use-package recentf
  :ensure t
  :commands (recentf-mode)
  :config
  (recentf-mode 1)
  (setq recentf-max-menu-items 25)
  (global-set-key "\C-x\ \C-r" 'recentf-open-files))

;; Nice ace popup
(use-package ace-popup-menu
  :ensure t
  :config
  (ace-popup-menu-mode 1))

;; Which key to show keyboard bindings
(use-package which-key
  :ensure t
  :config
  (setq which-key-idle-delay 0.3)
  (which-key-mode))

;; Global autocompletion
(use-package company
  :ensure t
  :config
  (add-hook 'after-init-hook 'global-company-mode)
  (setq company-minimum-prefix-length 2)
  (setq company-idle-delay 0.2))

;; Global syntax checking
(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode))

;; Fcitx input setup
(use-package fcitx
  :ensure t
  :init
  (setq fcitx-use-dbus t)
  :config
  (fcitx-aggressive-setup))

;; Nice things with helm
(use-package helm
  :ensure t
  :commands (helm-autoresize-mode)
  :init
  ;; (defvar helm-google-suggest-use-curl-p)
  (defvar helm-ff-search-library-in-sexp)
  (defvar helm-echo-input-in-header-line)
  (defvar helm-ff-file-name-history-use-recentf)
  :config
  ;; Bind executes to helm stuff
  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "M-:") 'helm-eval-expression)
  
  ;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
  ;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
  ;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
  (global-set-key (kbd "C-c h") 'helm-command-prefix)
  (global-unset-key (kbd "C-x c"))
  
  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
  (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal
  (define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

  (setq helm-split-window-inside-p           t ; open helm buffer inside current window, not occupy whole other window
	helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
	helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
	helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
	helm-ff-file-name-history-use-recentf t
	helm-echo-input-in-header-line t)
  
  (setq helm-autoresize-max-height 0)
  (setq helm-autoresize-min-height 20)
  (helm-autoresize-mode 1)

  (helm-mode 1))

(use-package helm-projectile
  :ensure t)

(use-package helm-tramp
  :ensure t)

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

(use-package evil
  :ensure t
  :after (which-key helm)
  :config
  (evil-mode 1)
  (which-key-add-key-based-replacements
    "SPC b" "buffer"
    "SPC g" "magit"
    "SPC f" "files")
  (define-key evil-normal-state-map (kbd "SPC b b") 'helm-buffers-list)
  (define-key evil-normal-state-map (kbd "SPC b k") 'kill-this-buffer)
  (define-key evil-normal-state-map (kbd "SPC b d") 'kill-other-buffers)
  (define-key evil-normal-state-map (kbd "SPC b h") 'switch-to-home-buffer)
  (define-key evil-normal-state-map (kbd "SPC b r") 'revert-buffer)
  (define-key evil-normal-state-map (kbd "SPC f f") 'helm-find-files)
  (define-key evil-normal-state-map (kbd "SPC f t") 'helm-tramp)
  (define-key evil-normal-state-map (kbd "SPC h") 'split-window-vertically)
  (define-key evil-normal-state-map (kbd "SPC v") 'split-window-horizontally)
  ;; General lang options
  (define-key evil-normal-state-map (kbd ", c") 'compile)
  ;; Projectile
  (define-key evil-normal-state-map (kbd "SPC r") 'projectile-grep)
  ;; CJK toggle
  (define-key evil-normal-state-map (kbd "SPC c") 'cjk-enable))

(use-package git-timemachine
  :ensure t)

(use-package evil-magit
  :ensure t
  :after (evil)
  :config
  (evil-magit-init)
  ;; Magit
  (define-key evil-normal-state-map (kbd "SPC g d") 'magit-dispatch-popup)
  (define-key evil-normal-state-map (kbd "SPC g s") 'magit-status)
  (define-key evil-normal-state-map (kbd "SPC g b") 'magit-blame)
  (define-key evil-normal-state-map (kbd "SPC g t") 'git-timemachine-toggle))

(use-package neotree
  :ensure t
  :after (evil)
  :config
  (define-key evil-normal-state-map (kbd "SPC t") 'neotree-toggle)
  (evil-define-key 'normal neotree-mode-map (kbd "TAB") 'neotree-enter)
  (evil-define-key 'normal neotree-mode-map (kbd "SPC") 'neotree-quick-look)
  (evil-define-key 'normal neotree-mode-map (kbd "q") 'neotree-hide)
  (evil-define-key 'normal neotree-mode-map (kbd "RET") 'neotree-enter))

(use-package org
  :ensure t
  :config
  ;; log todo items with timestamp
  (setq org-log-done 'time)

  ;; Compile command
  ;; (setq org-latex-pdf-process
  ;; '("pdflatex %f" "bibtex %b" "pdflatex %f" "pdflatex %f"))
  (setq org-latex-pdf-process
	'("pdflatex -interaction nonstopmode -output-directory %o %f"
          "bibtex %b"
          "pdflatex -interaction nonstopmode -output-directory %o %f"
          "pdflatex -interaction nonstopmode -output-directory %o %f"))

  (evil-define-key 'normal org-mode-map (kbd ", e") 'org-export-dispatch)
  (evil-define-key 'normal org-mode-map (kbd ", x") 'org-table-export)
  (evil-define-key 'normal org-mode-map (kbd ", .") 'org-time-stamp)
  (evil-define-key 'normal org-mode-map (kbd ", t") 'org-twbs-export-to-html)
  (evil-define-key 'normal org-mode-map (kbd ", s") 'org-schedule)
  (evil-define-key 'normal org-mode-map (kbd ", d") 'org-deadline)
  (evil-define-key 'normal org-mode-map (kbd ", c") 'org-ref-helm-cite)
  (evil-define-key 'normal org-mode-map (kbd ", '") 'org-edit-special))

(use-package org-bullets-mode
  :ensure org-bullets
  :hook org-mode)

(use-package org-ref
  :disabled
  ;; :ensure t
  :init
  ;; Bibtex references
  (setq reftex-default-bibliography '("~/Sync/Sync/references.bib")))

;; C and C++ config

(use-package ycmd-mode
  :ensure ycmd
  :hook (c-mode c++-mode)
  :init
  (set-variable 'ycmd-server-command `("/usr/bin/python2" ,(file-truename "/usr/share/vim/vimfiles/third_party/ycmd/ycmd/")))
  (set-variable 'ycmd-global-config "/home/jorrit/.emacs.d/lang/ycm_conf.py")
  (set-variable 'ycmd-extra-conf-whitelist '("/home/jorrit/Dev/*")))

(use-package company-ycmd-mode
  :ensure company-ycmd
  :commands (company-ycmd-setup)
  :hook (ycmd-mode . company-ycmd-setup))

(use-package clang-format
  :ensure t
  :general
  (local-leader-def
   :states 'normal
   :modes '(c-mode-map c++-mode-map)
   "b" '(:ignore t :which-key "clang")
   "bf" 'clang-format-buffer)
  :config
  (setq-default clang-format-style "{BasedOnStyle: llvm, IndentWidth: 4}"))

(use-package flycheck-ycmd
  :ensure t
  :after (flycheck)
  :commands (flycheck-ycmd-setup)
  :hook (ycmd-mode . flycheck-ycmd-setup)
  :config
  (flycheck-ycmd-setup)
  (setq flycheck-clang-language-standard "c++11")
  (when (not (display-graphic-p))
    (setq flycheck-indication-mode nil)))

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
   "gc" 'helm-gtags-clear-cache))

(use-package srefactor
  :ensure t
  :commands (srefactor-refactor-at-point)
  :hook ((c-mode c++-mode) . semantic-mode)
  :general
  (local-leader-def
   :states 'normal
   :keymaps '(c++-mode-map c-mode-map)
   "r" 'srefactor-refactor-at-point))

;; Javascript (typescript) config
(use-package typescript-mode
  :ensure t
  :mode "\\.ts\\'"
  :interpreter "typescript")

(use-package tide
  :ensure t
  :after (typescript-mode)
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
   "p" 'tide-project-errors))

;; Latex config
;; (use-package tex
;;  :ensure auctex
;;  :init
;;  (setq TeX-PDF-mode t)
;;  :general
;;  (local-leader-def
;;   :states 'normal
;;   :keymaps 'LaTeX-mode-map
;;   "c" 'Tex-command-master))

;; (use-package auctex-latexmk
;;   :ensure t
;;  :hook (LaTeX-mode . auctex-latexmk-setup))
;;  :general
;;  (local-leader-def
;;   :states 'normal
;;   :keymaps 'LaTeX-mode-map
;;   "c" 'output-pdf))

;;(use-package company-auctex
;;  :ensure t
;;  :commands (company-auctex-init)
;;  :hook (LaTeX-mode . company-auctex-init))

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
  :general
  (local-leader-def
   :states 'normal
   :keymaps 'rust-mode-map
   "f" 'rust-format-buffer))

;;; init.el ends here
