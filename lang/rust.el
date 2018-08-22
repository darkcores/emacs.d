;;; rust -- setup
;;; Documentation:

(require 'evil)
(require 'flycheck-rust)

;;; Code:

(defun rust-keys-setup ()
  "Setup rust keybindings evil."
  (define-key evil-normal-state-map (kbd ", f") 'rust-format-buffer))

(with-eval-after-load 'rust-mode
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

;;; rust.el ends here
