;;; UI -- config and setup
;;; Documentation:

(require 'solarized-theme)
(require 'dashboard)
(require 'rainbow-delimiters)

;;; Code:
;; Disable toolbar / ui
(tool-bar-mode -1)
(menu-bar-mode -1)
(toggle-scroll-bar -1)

;; Font setup
(set-frame-font "Source Code Pro 11")

;; Theme
(load-theme 'solarized-light)

;; Start page / dashboard
(dashboard-setup-startup-hook)
(setq dashboard-banner-logo-title "Welcome to Shuttlemacs")
(setq dashboard-items '((recents  . 5)
                        (projects . 5)
                        (agenda . 5)))

;; Rainbow color braces in programming modes
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;;; ui.el ends here
