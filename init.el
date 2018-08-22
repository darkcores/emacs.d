;;; Init -- init.el:
;;; Documentation:
(require 'package)

;;; Code:
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/"))
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default)))
 '(package-selected-packages
   (quote
    (htmlize srefactor markdown-mode org-ref json-mode srefactor clang-format helm-gtags php-eldoc company-php cargo company-racer flycheck-rust ox-epub org auctex-latexmk company-auctex auctex tide typescript-mode git-timemachine flycheck-ycmd company-ycmd use-package helm-tramp ac-php rust-mode php-mode web-beautify web-mode ox-twbs fcitx helm-projectile flycheck dashboard ace-popup-menu company-anaconda company virtualenvwrapper anaconda-mode evil-magit magit rainbow-delimiters neotree org-bullets org-evil solarized-theme which-key helm evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Install selected packages
(unless package-archive-contents
  (package-refresh-contents))
(package-install-selected-packages)

;; Shuttle configs
(load "~/.emacs.d/shuttle/config.el")
(load "~/.emacs.d/shuttle/ui.el")
(load "~/.emacs.d/shuttle/evil.el")
(load "~/.emacs.d/shuttle/helm.el")

;; Language configs
(load "~/.emacs.d/lang/org.el")
(load "~/.emacs.d/lang/latex.el")
(load "~/.emacs.d/lang/python.el")
(load "~/.emacs.d/lang/php.el")
(load "~/.emacs.d/lang/cpp.el")
(load "~/.emacs.d/lang/javascript.el")
(load "~/.emacs.d/lang/rust.el")

;;; init.el ends here
