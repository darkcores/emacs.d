;; Evil mode
(require 'evil)
(evil-mode 1)
(require 'org-evil)

;; General evil keybindings
(define-key evil-normal-state-map (kbd "SPC b") 'helm-buffers-list)
(define-key evil-normal-state-map (kbd "SPC d") 'kill-this-buffer)
(define-key evil-normal-state-map (kbd "SPC o") 'helm-find-files)
(define-key evil-normal-state-map (kbd "SPC v") 'split-window-vertically)
(define-key evil-normal-state-map (kbd "SPC h") 'split-window-horizontally)
(define-key evil-normal-state-map (kbd "SPC t") 'neotree)
