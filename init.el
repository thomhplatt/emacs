;; Set Theme
(load-theme 'wombat t)

;; Don't show the splash screen
(setq inhibit-startup-message t)

;; Turn off screen-flash with bell
(setq visible-bell nil)

;; Turn on line numbers
(global-display-line-numbers-mode t)

;; Relative line numbers
(setq display-line-numbers-type 'relative)

;; Smooth scrolling
(setq scroll-step 1
      scroll-conservatively 10000)

;; Full screen
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Turn off ~ backups
(setq make-backup-files nil)
