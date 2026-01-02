(setq doom-theme 'kanagawa)
(setq doom-font (font-spec :family "Maple Mono NF" :size 13))

(use-package! org-auto-tangle
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t))

(map! :leader
      :desc "Comment line" "-" #'comment-line)

(map! :leader
      (:prefix ("t" . "toggle")
       :desc "Toggle eshell split"            "e" #'+eshell/toggle
       :desc "Toggle line highlight in frame" "h" #'hl-line-mode
       :desc "Toggle line highlight globally" "H" #'global-hl-line-mode
       :desc "Toggle line numbers"            "l" #'doom/toggle-line-numbers
       :desc "Toggle markdown-view-mode"      "m" #'dt/toggle-markdown-view-mode
       :desc "Toggle truncate lines"          "t" #'toggle-truncate-lines
       :desc "Toggle treemacs"                "T" #'+treemacs/toggle
       :desc "Toggle vterm split"             "v" #'+vterm/toggle))

(setq display-line-numbers-type t)

(map! :leader
      (:prefix ("o" . "open here")
       :desc "Open eshell here" "e" #'+eshell/here
       :desc "Open vterm here"  "v" #'+vterm/here))

(custom-set-faces
 '(markdown-header-face ((t (:inherit font-lock-function-name-face :weight bold :family "variable-pitch"))))
 '(markdown-header-face-1 ((t (:inherit markdown-header-face :height 1.6))))
 '(markdown-header-face-2 ((t (:inherit markdown-header-face :height 1.5))))
 '(markdown-header-face-3 ((t (:inherit markdown-header-face :height 1.4))))
 '(markdown-header-face-4 ((t (:inherit markdown-header-face :height 1.3))))
 '(markdown-header-face-5 ((t (:inherit markdown-header-face :height 1.2))))
 '(markdown-header-face-6 ((t (:inherit markdown-header-face :height 1.1)))))

(defun dt/toggle-markdown-view-mode ()
  "Toggle between `markdown-mode' and `markdown-view-mode'."
  (interactive)
  (if (eq major-mode 'markdown-view-mode)
      (markdown-mode)
    (markdown-view-mode)))

(setq org-directory "~/adxvz/Developer/org/")
(setq org-modern-table-vertical 1)
(setq org-modern-table t)
(add-hook 'org-mode-hook #'hl-todo-mode)

(custom-theme-set-faces!
 'kanagawa
 '(org-level-8 :inherit outline-3 :height 1.0)
 '(org-level-7 :inherit outline-3 :height 1.0)
 '(org-level-6 :inherit outline-3 :height 1.1)
 '(org-level-5 :inherit outline-3 :height 1.2)
 '(org-level-4 :inherit outline-3 :height 1.3)
 '(org-level-3 :inherit outline-3 :height 1.4)
 '(org-level-2 :inherit outline-2 :height 1.5)
 '(org-level-1 :inherit outline-1 :height 1.6)
 '(org-document-title :height 1.6 :bold t :underline nil))

(setq display-line-numbers-type t)
(setq confirm-kill-emacs nil)
;; (setq initial-buffer-choice 'eshell)
