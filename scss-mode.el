(require 'css-mode)

(defgroup scss nil
		 "SCSS editing mode."
		 :group 'languages)

;;; SCSS mode
(defface scss-variable '((t :inherit font-lock-variable-name-face :italic t))
	"Face to use for variables."
	:group 'scss)

(defvar scss-mode-syntax-table
	(let ((st (make-syntax-table css-mode-syntax-table)))
		(modify-syntax-entry ?/ ". 124" st)
		(modify-syntax-entry ?\n ">" st)
		st))

(defvar scss-font-lock-keywords
	(append `((,(concat "$" css-ident-re) . 'scss-variable))
					(css--font-lock-keywords 'sassy)
					`((,(concat "@mixin[ \t]+\\(" css-ident-re "\\)[ \t]*(")
						 (1 font-lock-function-name-face)))))

(defun scss-smie--not-interpolation-p ()
	(save-excursion
		(forward-char -1)
		(or (zerop (skip-chars-backward "-[:alnum:]"))
				(not (looking-back "#{\\$" (- (point) 3))))))

;;;###autoload (add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))
;;;###autoload
(define-derived-mode scss-mode css-mode "SCSS"
	"Major mode to edit \"Sassy CSS\" files."
	(setq-local comment-start "// ")
	(setq-local comment-end "")
	(setq-local comment-continue " *")
	(setq-local comment-start-skip "/[*/]+[ \t]*")
	(setq-local comment-end-skip "[ \t]*\\(?:\n\\|\\*+/\\)")
	(setq-local font-lock-defaults '(scss-font-lock-keywords nil t)))

(provide 'scss-mode)
