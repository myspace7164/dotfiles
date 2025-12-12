(use-package package
  :init
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
  (unless package--initialized
    (package-initialize)))

(use-package autorevert
  :config
  (global-auto-revert-mode 1))

(use-package calendar
  :config
  (setq calendar-week-start-day 1)
  (setq calendar-intermonth-text
        '(propertize
          (format "%2d"
                  (car
                   (calendar-iso-from-absolute
                    (calendar-absolute-from-gregorian (list month day year)))))
          'font-lock-face 'font-lock-function-name-face)))

(use-package cape
  :ensure t
  :bind ("C-c p" . cape-prefix-map)
  :init
  (add-hook 'completion-at-point-functions #'cape-emoji)
  (add-hook 'completion-at-point-functions #'cape-file))

(use-package comp
  :config
  (setq native-comp-async-report-warnings-errors nil))

(use-package consult
  :ensure t
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s a" . consult-org-agenda)
         ("M-s d" . consult-find)                  ;; Alternative: consult-fd
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         ;; Org-mode
         ("C-c s" . (lambda () (interactive) (consult-ripgrep (org-agenda-files))))
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history)
         :map org-mode-map :package org
         ("M-g o" . consult-org-heading))

  :init
  (setq register-preview-delay 0.5)
  (advice-add #'register-preview :override #'consult-register-window)

  (setq xref-show-xrefs-function #'consult-xref)
  (setq xref-show-definitions-function #'consult-xref)

  :config
  (setq consult-ripgrep-args "rg --null --line-buffered --color=never --max-columns=1000 --path-separator /   --smart-case --no-heading --with-filename --line-number --search-zip --hidden"))

(use-package corfu
  :ensure t
  :preface
  (defun my/corfu-enable-always-in-minibuffer ()
    "Enable Corfu in the minibuffer if Vertico/Mct are not active."
    (unless (or (bound-and-true-p mct--active)
                (bound-and-true-p vertico--input)
                (eq (current-local-map) read-passwd-map))
      ;; (setq-local corfu-auto nil) ;; Enable/disable auto completion
      (setq-local corfu-echo-delay nil ;; Disable automatic echo and popup
                  corfu-popupinfo-delay nil)
      (corfu-mode 1)))
  :custom
  (corfu-auto t)
  :config
  (add-hook 'minibuffer-setup-hook #'my/corfu-enable-always-in-minibuffer 1)
  (global-corfu-mode 1))

(use-package csv-mode
  :ensure t
  :mode "\\.csv\\'"
  :hook (csv-mode . csv-guess-set-separator)
  :bind (("C-c C-b" . csv-backward-field)
         ("C-c C-f" . csv-forward-field)
         :repeat-map csv-mode-repeat-map
         ("C-b" . csv-backward-field)
         ("C-f" . csv-forward-field)
         ("b" . csv-backward-field)
         ("f" . csv-forward-field)))

(use-package cus-edit
  :config
  (setq custom-file (locate-user-emacs-file "custom.el"))
  (load custom-file))

(use-package dbus
  :preface
  (defvar my/dark-theme 'modus-vivendi
    "Default dark theme.")

  (defvar my/light-theme 'modus-operandi
    "Default light theme.")

  (defun my/theme-from-dbus (value)
    "Change the theme based on a D-Bus property.

VALUE should be an integer or an arbitrarily nested list that
contains an integer.  When VALUE is equal to 2 then a light theme
will be selected, otherwise a dark theme will be selected."
    (load-theme (if (= 2 (car (flatten-list value)))
                    my/light-theme
                  my/dark-theme)
                t))
  :config
  ;; Set the current theme based on what the system theme is right now:
  (dbus-call-method-asynchronously
   :session "org.freedesktop.portal.Desktop"
   "/org/freedesktop/portal/desktop"
   "org.freedesktop.portal.Settings"
   "Read"
   #'my/theme-from-dbus
   "org.freedesktop.appearance"
   "color-scheme")

  ;; Register to be notified when the system theme changes:
  (dbus-register-signal
   :session "org.freedesktop.portal.Desktop"
   "/org/freedesktop/portal/desktop"
   "org.freedesktop.portal.Settings"
   "SettingChanged"
   (lambda (path var value)
     (when (and (string-equal path "org.freedesktop.appearance")
                (string-equal var "color-scheme"))
       (my/theme-from-dbus value)))))

(use-package delsel
  :config
  (delete-selection-mode 1))

(use-package dired
  :custom
  (dired-auto-revert-buffer t)
  (dired-create-destination-dirs 'always)
  (dired-create-destination-dirs-on-trailing-dirsep t)
  (dired-listing-switches "-AGhlv --group-directories-first")
  (dired-recursive-copies 'always)
  (dired-recursive-deletes 'always))

(use-package wdired
  :custom
  (wdired-allow-to-change-permissions t))

(use-package direnv
  :if (executable-find "direnv")
  :ensure t
  :config
  (direnv-mode 1))

(use-package display-line-numbers
  :hook ((conf-mode . display-line-numbers-mode)
         (prog-mode . display-line-numbers-mode)))

(use-package eglot
  :hook ((nix-mode . eglot-ensure)
         (python-mode . eglot-ensure))
  :config
  (add-to-list 'eglot-server-programs '(nix-mode . ("nil")))
  (add-to-list 'eglot-server-programs '(nix-mode . ("nixd"))))

(use-package eldoc
  :custom
  (eldoc-echo-area-prefer-doc-buffer t)
  (eldoc-echo-area-use-multiline-p nil))

(use-package elec-pair
  :hook ((comint-mode . electric-pair-local-mode)
         (minibuffer-mode . electric-pair-local-mode)
	     (prog-mode . electric-pair-local-mode)))

(use-package emacs
  :bind (("M-Q" . my/unfill-paragraph)
         ("<f5>" . modus-themes-toggle))

  :preface
  (defun my/unfill-paragraph (&optional region)
    "Takes a multi-line paragraph and makes it into a single line of text."
    (interactive (progn (barf-if-buffer-read-only) '(t)))
    (let ((fill-column (point-max))
	      ;; This would override `fill-column' if it's an integer.
	      (emacs-lisp-docstring-fill-column t))
      (fill-paragraph nil region)))

  :custom
  ;; Emacs 30 and newer: Disable Ispell completion function.
  (text-mode-ispell-word-completion nil)

  (read-extended-command-predicate #'command-completion-default-include-p)

  :config
  (setq visible-bell t)

  (setq delete-by-moving-to-trash t)
  (setq enable-recursive-minibuffers t)
  (setq use-short-answers t)

  (setq-default tab-width 4)
  (setq tab-always-indent 'complete)

  (when (find-font (font-spec :name "Iosevka"))
    (add-to-list 'default-frame-alist '(font . "Iosevka-10"))
    (set-face-attribute 'default nil :font "Iosevka-10"))

  (setq read-buffer-completion-ignore-case t)

  (when (equal system-name "wsl")
    (load-theme 'modus-vivendi :no-confirm)))

(use-package embark
  :ensure t
  :bind (("C-." . embark-act)
	     ("C-;" . embark-dwim)
	     ("C-h B" . embark-bindings))
  :config
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :ensure t
  :hook (embark-collect-mode . consult-preview-at-point-mode))

(use-package files
  :config
  (make-directory (locate-user-emacs-file "lock-files") t)
  (setq lock-file-name-transforms `((".*" ,(locate-user-emacs-file "lock-files/\\1") t)))
  (setq backup-directory-alist `(("." . ,(locate-user-emacs-file "backups"))))
  (setq backup-by-copying t)
  (setq version-control t)
  (setq delete-old-versions t))

(use-package flyspell
  :bind (nil
         :map ctl-x-x-map
         ("s" . flyspell-mode)))

(use-package hl-line
  :hook ((dired-mode . hl-line-mode)
         (org-agenda-mode . hl-line-mode)
         (prog-mode . hl-line-mode)
         (tabulated-list-mode . hl-line-mode)))

(use-package json-mode :ensure t)

(use-package lua-mode :ensure t)

(use-package magit
  :ensure t
  :config
  (setq magit-repository-directories '(("~/Repos" . 1))))

(use-package marginalia
  :ensure t
  :config
  (marginalia-mode 1))

(use-package markdown-mode :ensure t)

(use-package matlab-mode :ensure t)

(use-package minibuffer
  :config
  (setq completion-cycle-threshold 3)
  (setq read-file-name-completion-ignore-case t))

(use-package minions
  :ensure t
  :custom
  (minions-mode-line-lighter ":")
  :config
  (minions-mode 1))

(use-package nix-mode :ensure t)

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package outline
  :bind (nil
         :repeat-map outline-navigation-repeat-map
         ("<tab>" . outline-cycle)
         ("<backtab>" . outline-cycle-buffer))
  :hook ((LaTeX-mode . outline-minor-mode)
         (prog-mode . outline-minor-mode))
  :custom
  (outline-minor-mode-cycle t))

(use-package pascal-mode
  :mode "\\.\\(pou\\|st\\)\\'")

(use-package pixel-scroll
  :if (version<= "29.1" emacs-version)
  :config
  (pixel-scroll-precision-mode 1))

(use-package plantuml-mode
  :ensure t
  :demand t
  :mode "\\.plantuml\\'"
  :custom
  (plantuml-jar-path "~/.local/share/plantuml/plantuml.jar"))

(use-package python
  :bind (nil
         :repeat-map python-repeat-map
         ("<" . python-indent-shift-left)
         (">" . python-indent-shift-right)))

(use-package recentf
  :config
  (recentf-mode 1)
  (run-at-time nil (* 5 60) 'recentf-save-list))

(use-package repeat
  :config
  (repeat-mode 1))

(use-package savehist
  :config
  (savehist-mode 1))

(use-package saveplace
  :config
  (save-place-mode 1))

(use-package simple
  :config
  (setq-default indent-tabs-mode nil)
  (column-number-mode 1))

(use-package startup
  :no-require
  :config
  (setq inhibit-startup-message t))

(use-package tab-bar
  :bind (("C-c <left>" . tab-bar-history-back)
         ("C-c <right>" . tab-bar-history-forward)
         :repeat-map tab-bar-repeat-map
         ("<left>" . tab-bar-history-back)
         ("<right>" . tab-bar-history-forward))
  :custom
  (tab-bar-show 1)
  :config
  (tab-bar-mode 1)
  (tab-bar-history-mode 1))

(use-package vc
  :config
  (setq vc-follow-symlinks t))

(use-package vertico
  :ensure t
  :custom
  (vertico-cycle t)
  (vertico-sort-function #'vertico-sort-length-alpha)
  :config
  (vertico-mode 1))

(use-package vertico-mouse
  :after vertico
  :config
  (vertico-mouse-mode 1))

(use-package vertico-multiform
  :after vertico
  :config
  (vertico-multiform-mode 1))

(use-package which-key
  :ensure t
  :custom
  (which-key-show-early-on-C-h t)
  (which-key-idle-delay 10000)
  (which-key-idle-secondary-delay 0.05)
  :config
  (which-key-mode 1))

(use-package whitespace
  :bind (("<f6>" . whitespace-mode)
         ("C-c z" . delete-trailing-whitespace)))

(use-package window
  :bind ("M-o" . other-window))

(use-package yaml-mode :ensure t)
