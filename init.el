;; --- PACKAGE MANAGMENT ---
(require 'package)

;; Add MELPA and ELPA
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu"   . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)

;; Refresh package list if needed
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; --- USER INTERFACE ---
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

;; Window undo/redo
(winner-mode 1)

;; Workspaces (tabs)
(use-package eyebrowse
  :config
  (eyebrowse-mode t))

;; Repeat mode
(repeat-mode 1)

;; --- ORG MODE ---
;; source mode sohrcut <s
(require 'org-tempo)

;; indents
(use-package org
  :hook (org-mode . org-indent-mode))

;; agendas!
(setq org-agenda-files
      '("~/org/agendas/life.org"
	"~/org/agendas/school.org"))

(setq diary-file "~/.emacs.d/diary")

(setq org-agenda-include-diary t)

;; make diary accept short month names like "Nov"
(setq diary-date-forms
      '((month "/" day "/" year)
        (monthname " " day ", " year)
        (monthname " " day " " year)
        (day " " month " " year)
        (day " " monthname " " year)))

(setq org-format-latex-options
      '(:scale 1.5 :foreground "White" :background "Transparent" :bold t))


;; --- COMPLETION FRAMEWORK ---
(use-package vertico
  :init
  (vertico-mode))

(use-package savehist
  :init (savehist-mode))

(use-package corfu
  :ensure t
  :init
  (global-corfu-mode)
  (corfu-history-mode)
  :custom
  (corfu-cycle t)                ;; Enable cycling for completions
  (corfu-auto t)                 ;; Enable auto-completion
  (corfu-auto-prefix 2)         ;; Minimum chars before auto-popup
  (corfu-auto-delay 0.0))       ;; No delay before popup

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(eyebrowse calfw-org calfw exec-path-from-shell jupyter vertico)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; --- JUPYTER NOTEBOOKS ---

;(use-package jupyter
;;  :ensure t)

;; --- BABEL ---
;; --- Shell path fix (macOS-specific) ---
(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

;; --- Org Babel language setup ---
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (jupyter . t)
   (C . t)))  ;; add more if needed

;; --- Set Python3 explicitly (smart fix) ---
(setq org-babel-python-command (executable-find "python3"))
;; turn off confirm-run
(setq org-confirm-babel-evaluate nil)





