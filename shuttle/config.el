;; General config stuff

;; Recent files
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

;; Nicer (ace) popup
(ace-popup-menu-mode 1)

;; Which key show shortcuts with commands
(which-key-mode)
(setq which-key-idle-delay 0.3)

;; Auto completion setup
(ac-config-default)
(setq ac-auto-show-menu 0.3)

