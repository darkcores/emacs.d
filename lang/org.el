;;; Org -- Nicer org
;;; Documentation:
(require 'org)
(require 'org-agenda)
(require 'org-bullets)
(require 'org-ref)
;; (require 'ox-bibtex)
(require 'evil)

;;; Code:

;; Bibtex references
(setq reftex-default-bibliography '("~/Sync/Sync/references.bib"))

;; log todo items with timestamp
(setq org-log-done 'time)

;; Compile command
;; (setq org-latex-pdf-process
;; '("pdflatex %f" "bibtex %b" "pdflatex %f" "pdflatex %f"))
(setq org-latex-pdf-process
      '("pdflatex -interaction nonstopmode -output-directory %o %f"
        "bibtex %b"
        "pdflatex -interaction nonstopmode -output-directory %o %f"
        "pdflatex -interaction nonstopmode -output-directory %o %f"))

;; Agenda setup (setq org-agenda-files
;; '("/home/jorrit/Documents/agenda"))

;; For now we disable org agenda to speed up startup (and we don't
;; really use it anyways)

;; keybindings
(defun org-keys-setup ()
  "Setup , keybinds for org."
  (define-key evil-normal-state-map (kbd ", e") 'org-export-dispatch)
  (define-key evil-normal-state-map (kbd ", x") 'org-table-export)
  (define-key evil-normal-state-map (kbd ", .") 'org-time-stamp)
  (define-key evil-normal-state-map (kbd ", t") 'org-twbs-export-to-html)
  (define-key evil-normal-state-map (kbd ", s") 'org-schedule)
  (define-key evil-normal-state-map (kbd ", d") 'org-deadline)
  (define-key evil-normal-state-map (kbd ", c") 'org-ref-helm-cite)
  (define-key evil-normal-state-map (kbd ", '") 'org-edit-special))

(defun org-setup ()
  "Setup org."
  (org-bullets-mode 1)
  (org-keys-setup))

(add-hook 'org-mode-hook 'org-setup)

;;; org.el ends here
