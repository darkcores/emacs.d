;;; rust -- setup
;;; Documentation:

(require 'flycheck-rust)

;;; Code:

(with-eval-after-load 'rust-mode
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

;;; rust.el ends here
