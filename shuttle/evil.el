;;; Evil -- evil config:
;;; Documentation:
;; Evil mode
(require 'evil)
(require 'which-key)
(require 'org-evil)
(require 'evil-magit)
(require 'git-timemachine)
(require 'neotree)

;;; Code:
(evil-mode 1)
(evil-magit-init)

;; General evil keybindings
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
(define-key evil-normal-state-map (kbd "SPC v") 'split-window-vertically)
(define-key evil-normal-state-map (kbd "SPC h") 'split-window-horizontally)

;; Magit
(define-key evil-normal-state-map (kbd "SPC g d") 'magit-dispatch-popup)
(define-key evil-normal-state-map (kbd "SPC g s") 'magit-status)
(define-key evil-normal-state-map (kbd "SPC g b") 'magit-blame)
(define-key evil-normal-state-map (kbd "SPC g t") 'git-timemachine-toggle)

;; Neotree
(define-key evil-normal-state-map (kbd "SPC t") 'neotree-toggle)
(evil-define-key 'normal neotree-mode-map (kbd "TAB") 'neotree-enter)
(evil-define-key 'normal neotree-mode-map (kbd "SPC") 'neotree-quick-look)
(evil-define-key 'normal neotree-mode-map (kbd "q") 'neotree-hide)
(evil-define-key 'normal neotree-mode-map (kbd "RET") 'neotree-enter)

;; Org agenda
(define-key evil-normal-state-map (kbd "SPC a") 'org-agenda-list)

;; General lang options
(define-key evil-normal-state-map (kbd ", c") 'compile)

;; Projectile
(define-key evil-normal-state-map (kbd "SPC r") 'projectile-grep)

;;; evil.el ends here
