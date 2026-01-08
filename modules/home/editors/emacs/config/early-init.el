;;; early-init.el --- Early Emacs initialization -*- lexical-binding: t; -*-

;; Silence native-comp spam
(setq native-comp-async-report-warnings-errors nil)

;; Redirect .eln cache to writable directory (CRITICAL for Nix)
(when (and (fboundp 'native-comp-available-p)
           (native-comp-available-p))
  (startup-redirect-eln-cache
   (expand-file-name "eln-cache/" user-emacs-directory)))

;; Faster startup defaults
(setq package-enable-at-startup nil)
(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message user-login-name)

;; Load main init.el (adjust the path as needed)
(load-file (expand-file-name "../.config/emacs/init.el" user-emacs-directory))

(provide 'early-init)
;;; early-init.el ends here
