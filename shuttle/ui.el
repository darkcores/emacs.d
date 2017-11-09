;; Disable toolbar / ui
(tool-bar-mode -1)
(menu-bar-mode -1)
(toggle-scroll-bar -1)

;; Font setup
(set-default-font "Source Code Pro 11")

;; Theme
(load-theme 'solarized-light)

;; Start page / dashboard
(dashboard-setup-startup-hook)

;; Which key show shortcuts with commands
(which-key-mode)
(setq which-key-idle-delay 0.3)
