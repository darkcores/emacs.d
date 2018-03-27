;;; C-C++ -- setup
;;; Documentation:

(require 'ycmd)
(require 'evil)
(require 'company-ycmd)
(require 'flycheck-ycmd)
(require 'helm-gtags)
(require 'srefactor)
;;; Code:

;; Variables
(set-variable 'ycmd-server-command `("/usr/bin/python2" ,(file-truename "/usr/share/vim/vimfiles/third_party/ycmd/ycmd/")))
(set-variable 'ycmd-global-config "/home/jorrit/Dev/shuttlemacs/.emacs.d/lang/ycm_conf.py")
(set-variable 'ycmd-extra-conf-whitelist '("/home/jorrit/Dev/*"))

;; Hooks
(add-hook 'c++-mode-hook 'ycmd-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'semantic-mode)
(add-hook 'c-mode-hook 'ycmd-mode)
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c-mode-hook 'semantic-mode)
(add-hook 'ycmd-mode-hook 'cppsetup)

(defun cpp-keys-setup ()
  "Setup keybindings for c-c++ development."
  (which-key-add-key-based-replacements
    ", g" "gtags"
    ", c" "clang")
  (define-key evil-normal-state-map (kbd ", f") 'helm-gtags-find-tag)
  (define-key evil-normal-state-map (kbd ", j") 'helm-gtags-dwim)
  (define-key evil-normal-state-map (kbd ", r") 'srefactor-refactor-at-point)
  (define-key evil-normal-state-map (kbd ", c f") 'clang-format-buffer)
  (define-key evil-normal-state-map (kbd ", g p") 'helm-gtags-find-pattern)
  (define-key evil-normal-state-map (kbd ", g r") 'helm-gtags-find-rtag)
  (define-key evil-normal-state-map (kbd ", g P") 'helm-gtags-find-files)
  (define-key evil-normal-state-map (kbd ", g p") 'helm-gtags-find-pattern)
  (define-key evil-normal-state-map (kbd ", g f") 'helm-gtags-parse-file)
  (define-key evil-normal-state-map (kbd ", g g") 'helm-gtags-create-tags)
  (define-key evil-normal-state-map (kbd ", g u") 'helm-gtags-update-tags)
  (define-key evil-normal-state-map (kbd ", g c") 'helm-gtags-clear-cache)
  )

(defun cppsetup()
  (cpp-keys-setup)
  (company-ycmd-setup)
  (flycheck-ycmd-setup)
  (setq-default tab-width 4)
  (setq-default c-basic-offset 4)
  (setq-default clang-format-style "{BasedOnStyle: llvm, IndentWidth: 4}")
  ;; (push 'company-semantic company-backends)
  (setq flycheck-clang-language-standard "c++11")
  (when (not (display-graphic-p))
    (setq flycheck-indication-mode nil)))


;;; cpp.el ends here
