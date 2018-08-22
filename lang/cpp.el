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
  (evil-define-key 'normal c++-mode-map (kbd ", f") 'helm-gtags-find-tag)
  (evil-define-key 'normal c++-mode-map (kbd ", j") 'helm-gtags-dwim)
  (evil-define-key 'normal c++-mode-map (kbd ", r") 'srefactor-refactor-at-point)
  (evil-define-key 'normal c++-mode-map (kbd ", c f") 'clang-format-buffer)
  (evil-define-key 'normal c++-mode-map (kbd ", g p") 'helm-gtags-find-pattern)
  (evil-define-key 'normal c++-mode-map (kbd ", g r") 'helm-gtags-find-rtag)
  (evil-define-key 'normal c++-mode-map (kbd ", g P") 'helm-gtags-find-files)
  (evil-define-key 'normal c++-mode-map (kbd ", g p") 'helm-gtags-find-pattern)
  (evil-define-key 'normal c++-mode-map (kbd ", g f") 'helm-gtags-parse-file)
  (evil-define-key 'normal c++-mode-map (kbd ", g g") 'helm-gtags-create-tags)
  (evil-define-key 'normal c++-mode-map (kbd ", g u") 'helm-gtags-update-tags)
  (evil-define-key 'normal c++-mode-map (kbd ", g c") 'helm-gtags-clear-cache)
  )

(defun cppsetup()
  "Setup cpp stuff."
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
