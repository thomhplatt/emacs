;; Separate package dirs per Emacs version (prevents cross-version weirdness)
(setq package-user-dir
      (expand-file-name (format "elpa-%d.%d" emacs-major-version emacs-minor-version)
                        user-emacs-directory))

;; startup
(set-face-background 'default "old lace")

;; --- PACKAGE MANAGEMENT ---
(require 'package)

(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu"   . "https://elpa.gnu.org/packages/")))

(package-initialize)

;; Install use-package if missing
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; vterm
(use-package vterm
  :config
  (setq vterm-max-scrollback 10000)
  (setq vterm-shell "/bin/zsh"))

;; vterm-toggle
(use-package vterm-toggle
  :bind
  (("C-c t" . vterm-toggle-cd)))

;; Don't show the splash screen
(setq inhibit-startup-message t)

(add-hook 'emacs-startup-hook
          (lambda ()
            (find-file "~/org/agenda/life/daily.org")))

;; Turn off screen-flash with bell
(setq visible-bell nil)

;; Turn on line numbers
(global-display-line-numbers-mode t)

;; Reload buffers when files change on disk (poll; kqueue misses replaced files)
(setq auto-revert-use-notify nil)
(global-auto-revert-mode 1)

(with-eval-after-load 'vterm
  (setq vterm-max-scrollback 100000))

;; --- CSV MODE ---
(use-package csv-mode
  :mode "\\.csv\\'"
  :hook (csv-mode . csv-align-fields))

;; --- ORG MODE ---
;; source mode shortcut <s
(require 'org-tempo)
(require 'org-habit)

(add-to-list 'org-modules 'org-habit)
(setq org-habit-show-habits-only-for-today nil)
(setq org-habit-preceding-days 14)
(setq org-habit-following-days 7)
(setq org-habit-graph-column 70)

;; indents
(use-package org
  :hook
  ((org-mode . org-indent-mode)
   (org-mode . visual-line-mode)))

;; agendas!
(setq org-agenda-files
      (directory-files-recursively
       (expand-file-name "~/org/agenda/")
       "\\.org\\'"))

(defun my/update-org-agenda-files ()
  (setq org-agenda-files
        (directory-files-recursively
         "~/org/agenda"
         "\\.org$")))

(my/update-org-agenda-files)

(setq org-refile-targets
      '((org-agenda-files :maxlevel . 2)))

(auto-insert-mode 1)

(setq auto-insert-query nil)

(setq auto-insert-alist
      '((("\\.org\\'" . "Org template")
         . "#+TITLE: \n#+DESCRIPTION: \n#+FILETAGS: \n#+STARTUP: content\n\n* Inbox\n\n")))

;; Disable holidays in calendar
(setq calendar-mark-holidays-flag nil)
(setq mark-holidays-in-calendar nil)

;; Disable holidays in Org agenda / diary
(setq org-agenda-show-holidays nil)
(setq diary-holidays nil)

;; --- COMPLETION FRAMEWORK ---
(use-package vertico
  :init
  (vertico-mode))

(use-package marginalia
  :init
  (marginalia-mode))

(use-package orderless
  :init
  ;; Use orderless completion everywhere
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides
        '((file (styles partial-completion)))))

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

;; --- BABEL ---
(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

;; --- Org Babel language setup ---
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (C . t)))

;; --- Set Python3 explicitly ---
(setq org-babel-python-command (executable-find "python3"))
;; turn off confirm-run
(setq org-confirm-babel-evaluate nil)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   '("/Users/thomhplatt/org/agenda/health/fitness.org"
     "/Users/thomhplatt/org/agenda/health/habits.org"
     "/Users/thomhplatt/org/agenda/health/health.org"
     "/Users/thomhplatt/org/agenda/health/yums.org"
     "/Users/thomhplatt/org/agenda/life/apply.org"
     "/Users/thomhplatt/org/agenda/life/daily.org"
     "/Users/thomhplatt/org/agenda/life/finances.org"
     "/Users/thomhplatt/org/agenda/life/fix.org"
     "/Users/thomhplatt/org/agenda/life/life.org"
     "/Users/thomhplatt/org/agenda/life/masters.org"
     "/Users/thomhplatt/org/agenda/life/music.org"
     "/Users/thomhplatt/org/agenda/life/social.org"
     "/Users/thomhplatt/org/agenda/work/fernwood/fernwood.org"
     "/Users/thomhplatt/org/agenda/work/uveec/uveec.org"))
 '(package-selected-packages nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; --- TYPESCRIPT / TSX (built-in tree-sitter modes) ---
(setq treesit-language-source-alist
      '((typescript "https://github.com/tree-sitter/tree-sitter-typescript" "v0.23.2" "typescript/src")
        (tsx        "https://github.com/tree-sitter/tree-sitter-typescript" "v0.23.2" "tsx/src")))

;; Install grammars on first run if missing
(dolist (lang '(typescript tsx))
  (unless (treesit-language-available-p lang)
    (treesit-install-language-grammar lang)))

(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
(setq-default typescript-ts-mode-indent-offset 2)
