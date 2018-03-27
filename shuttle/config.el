;;; Shuttle -- general config:
;;; Documentation:

(require 'company)
(require 'fcitx)
(require 'flycheck)
(require 'which-key)
(require 'ace-popup-menu)
(require 'recentf)

;;; Code:

;; Kill other buffers
(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

(defun switch-to-home-buffer ()
  "Switch to the dashboard buffer."
  (interactive)
  (switch-to-buffer "*dashboard*"))

(defun my-inhibit-startup-screen-file ()
  "Startup screen inhibitor for `command-line-functions`.
Inhibits startup screen on the first unrecognised option which
names an existing file."
  (ignore
   (setq inhibit-startup-screen
         (file-exists-p
          (expand-file-name argi command-line-default-directory)))))

(add-hook 'command-line-functions #'my-inhibit-startup-screen-file)

;; Recent files
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

;; Nicer (ace) popup
(ace-popup-menu-mode 1)

;; Which key show shortcuts with commands
(which-key-mode)
(setq which-key-idle-delay 0.3)

;; Company auto completion globally
(add-hook 'after-init-hook 'global-company-mode)
(setq company-minimum-prefix-length 2)
(setq company-idle-delay 0.2)

;; Flycheck syntex checking
(global-flycheck-mode)

;; Support for fcitx
(fcitx-aggressive-setup)
(setq fcitx-use-dbus t)

;; Indentation

;;; config.el ends here
