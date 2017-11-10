;;; Evil -- evil config:
;;; Documentation:
;; Evil mode
(require 'evil)
(require 'org-evil)
(require 'evil-magit)
(require 'neotree)

;;; Code:
(evil-mode 1)
(evil-magit-init)

;; General evil keybindings
(define-key evil-normal-state-map (kbd "SPC b") 'helm-buffers-list)
(define-key evil-normal-state-map (kbd "SPC d") 'kill-this-buffer)
(define-key evil-normal-state-map (kbd "SPC f") 'helm-find-files)
(define-key evil-normal-state-map (kbd "SPC v") 'split-window-vertically)
(define-key evil-normal-state-map (kbd "SPC h") 'split-window-horizontally)

;; Magit
(define-key evil-normal-state-map (kbd "SPC g d") 'magit-dispatch-popup)
(define-key evil-normal-state-map (kbd "SPC g s") 'magit-status)

;; Neotree
(define-key evil-normal-state-map (kbd "SPC t") 'neotree-toggle)
(evil-define-key 'normal neotree-mode-map (kbd "TAB") 'neotree-enter)
(evil-define-key 'normal neotree-mode-map (kbd "SPC") 'neotree-quick-look)
(evil-define-key 'normal neotree-mode-map (kbd "q") 'neotree-hide)
(evil-define-key 'normal neotree-mode-map (kbd "RET") 'neotree-enter)

;;; evil.el ends here
