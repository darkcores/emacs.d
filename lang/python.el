;;; Python -- setup
;;; Documentation:

(require 'flycheck)
(require 'evil)
(require 'anaconda-mode)
(require 'company-anaconda)
(require 'which-key)

;;; Code:
;; Anaconda mode
(eval-after-load "company"
 '(add-to-list 'company-backends 'company-anaconda))
(add-hook 'python-mode-hook 'anaconda-mode)

;; Python 2 support when wanted
(defun python2-enable ()
  "Set python2 as default python."
  (interactive)
  (setq flycheck-python-pycompile-executable "/usr/bin/python2")
  (setq flycheck-python-flake8-executable "/usr/bin/flake8-python2")
  (setq flycheck-python-pylint-executable "/usr/bin/pylint2")
  (setq python-shell-interpreter "/usr/bin/python2")
  (flycheck-buffer))

(defun python2-disable ()
  "Go back to default python."
  (interactive)
  (setq flycheck-python-pycompile-executable "/usr/bin/python")
  (setq flycheck-python-flake8-executable "/usr/bin/flake8")
  (setq flycheck-python-pylint-executable "/usr/bin/pylint")
  (setq python-shell-interpreter "/usr/bin/python")
  (flycheck-buffer))

;; Keybindings
(defun python-keys-setup ()
  "Setup python , keys."
  (define-key evil-normal-state-map (kbd ", e") 'python2-enable)
  (define-key evil-normal-state-map (kbd ", d") 'python2-disable)
  (define-key evil-normal-state-map (kbd ", r") 'run-python)
  (define-key evil-normal-state-map (kbd ", b") 'python-shell-send-buffer)
  (define-key evil-normal-state-map (kbd ", f") 'python-shell-send-file))

(add-hook 'python-mode-hook 'python-keys-setup)

;;; python.el ends here
