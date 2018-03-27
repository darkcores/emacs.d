;;; Latex -- latex.el
;;; Documentation:
(require 'company-auctex)
(require 'evil)

;;; Code:

(setq TeX-PDF-mode t)

(defun latex-keys0-setup ()
  "Setup latex keybindings."
  (define-key evil-normal-state-map (kbd ", c") 'output-pdf))

(add-hook 'LaTeX-mode-hook 'company-auctex-init)
;;; latex.el ends here
