;;; CJK -- font settings
;;; Documentation:
;; Fix cjk font thingies
;; From: https://coldnew.github.io/d5011be2/
;;; Code:

(defvar emacs-english-font "Source Code Pro"
  "The font name of English.")

(defvar emacs-cjk-font "Source Han Code JP R"
  "The font name for CJK.")

(defvar emacs-font-size-pair '(15 . 18)
  "Default font size pair for (english . chinese).")

(defvar emacs-font-size-pair-list
  '(( 5 .  6) (10 . 12)
    (13 . 16) (15 . 18) (17 . 20)
    (19 . 22) (20 . 24) (21 . 26)
    (24 . 28) (26 . 32) (28 . 34)
    (30 . 36) (34 . 40) (36 . 44))
  "This list is used to store matching (english . chinese) font-size.")

(defun font-exist-p (fontname)
  "Test if FONTNAME exists or not."
  (if (or (not fontname) (string= fontname ""))
      nil
    (if (not (x-list-fonts fontname)) nil t)))

(defun set-font (english chinese size-pair)
  "Setup ENGLISH and CHINESE font in xorg for SIZE-PAIR."

  (if (font-exist-p english)
      (set-frame-font (format "%s:pixelsize=%d" english (car size-pair)) t))

  (if (font-exist-p chinese)
      (dolist (charset '(kana han symbol cjk-misc bopomofo))
        (set-fontset-font (frame-parameter nil 'font) charset
                          (font-spec :family chinese :size (cdr size-pair))))))

(set-font emacs-english-font emacs-cjk-font emacs-font-size-pair)

(defun emacs-step-font-size (step)
  "Increase/Decrease font size by STEP."
  (let ((scale-steps emacs-font-size-pair-list))
    (if (< step 0) (setq scale-steps (reverse scale-steps)))
    (setq emacs-font-size-pair
          (or (cadr (member emacs-font-size-pair scale-steps))
              emacs-font-size-pair))
    (when emacs-font-size-pair
      (message "emacs font size set to %.1f" (car emacs-font-size-pair))
      (set-font emacs-english-font emacs-cjk-font emacs-font-size-pair))))

(defun increase-emacs-font-size ()
  "Decrease font-size acording emacs-font-size-pair-list."
  (interactive) (emacs-step-font-size 1))

(defun decrease-emacs-font-size ()
  "Increase font-size acording emacs-font-size-pair-list."
  (interactive) (emacs-step-font-size -1))

(global-set-key (kbd "C-=") 'increase-emacs-font-size)
(global-set-key (kbd "C--") 'decrease-emacs-font-size)

;;; cjk.el ends here
