;;; Javascript -- setup
;;; Documentation:
(require 'typescript-mode)
(require 'tide)
(require 'evil)
;;; Code:

(defun ts-evil-setup ()
  "Setup evil keybindings for typescript mode."
  (define-key evil-normal-state-map (kbd ", c") 'tide-compile-file)
  (define-key evil-normal-state-map (kbd ", f") 'tide-format)
  (define-key evil-normal-state-map (kbd ", r") 'tide-restart-server)
  (define-key evil-normal-state-map (kbd ", m") 'tide-fix)
  (define-key evil-normal-state-map (kbd ", p") 'tide-project-errors)
  )

(defun ts-init ()
  "Initialize typescript mode."
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1)
  (ts-evil-setup))

(add-hook 'typescript-mode-hook 'ts-init)
;;; javascript.el ends here
