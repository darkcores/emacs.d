;; Nicer org
(add-hook 'org-mode-hook
	  (lambda ()
	    (org-bullets-mode 1)
	    (define-key evil-normal-state-map (kbd "SPC e") 'org-export-dispatch)
	    (define-key evil-normal-state-map (kbd "SPC '") 'org-edit-special)
	    ))

