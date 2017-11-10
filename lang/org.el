;;; Org -- Nicer org
;;; Documentation:
(require 'org-bullets)
(require 'evil)

;;; Code:

;; keybindings
(defun org-keys-setup ()
  "Setup SPC keybinds for org."
  (define-key evil-normal-state-map (kbd "SPC e") 'org-export-dispatch)
  (define-key evil-normal-state-map (kbd "SPC '") 'org-edit-special))

(defun org-setup ()
  "Setup org."
  (org-bullets-mode 1)
  (org-keys-setup))

(add-hook 'org-mode-hook 'org-setup)

;;; org.el ends here
