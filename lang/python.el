;;; Python -- setup
;;; Documentation:

(require 'anaconda-mode)
(require 'company-anaconda)

;;; Code:
;; Anaconda mode
(eval-after-load "company"
 '(add-to-list 'company-backends 'company-anaconda))
(add-hook 'python-mode-hook 'anaconda-mode)

;;; python.el ends here
