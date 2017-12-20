;;; C-C++ -- setup
;;; Documentation:

(require 'ycmd)
(require 'company-ycmd)
(require 'flycheck-ycmd)
;;; Code:

(set-variable 'ycmd-server-command `("/usr/bin/python2" ,(file-truename "/usr/share/vim/vimfiles/third_party/ycmd/ycmd/")))
(set-variable 'ycmd-global-config "/home/jorrit/Dev/shuttlemacs/.emacs.d/lang/ycm_conf.py")
(set-variable 'ycmd-extra-conf-whitelist '("/home/jorrit/Dev/*"))
(add-hook 'c++-mode-hook 'ycmd-mode)
(add-hook 'ycmd-mode-hook 'cppsetup)

(defun cppsetup()
  (company-ycmd-setup)
  (flycheck-ycmd-setup)
  (when (not (display-graphic-p))
    (setq flycheck-indication-mode nil)))

;;; cpp.el ends here
