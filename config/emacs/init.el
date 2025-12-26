(use-package package
  :init
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
  (unless package--initialized
    (package-initialize)))

(use-package gcmh
  :ensure t
  :init
  (gcmh-mode 1))

(use-package auth-source
  :custom
  (auth-source-save-behavior nil))

(use-package autorevert
  :config
  (global-auto-revert-mode 1))

(use-package bibtex
  :hook (bibtex-mode . (lambda () (setq-local fill-column 10000))))

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

(use-package cdlatex :ensure t)

(use-package citar
  :ensure t
  :bind (("C-c w c" . citar-create-note)
         ("C-c w o" . citar-open)
         ("C-c w F" . citar-open-files)
         ("C-c w N" . citar-open-notes))
  :hook ((LaTeX-mode . citar-capf-setup)
         (org-mode . citar-capf-setup))
  :custom
  (citar-bibliography '("~/Nextcloud/ref/books/references.bib"))
  (citar-library-paths '("~/Nextcloud/ref/books"))
  (citar-notes-paths '("~/Nextcloud/notes")))

(use-package citar-denote
  :ensure t
  :after citar denote
  :bind (("C-c w f" . my/citar-denote-open-file)
         ("C-c w n" . citar-denote-open-note)
         ("C-c w d" . citar-denote-dwim)
         ("C-c w e" . citar-denote-open-reference-entry)
         ("C-c w a" . citar-denote-add-citekey)
         ("C-c w k" . citar-denote-remove-citekey)
         ("C-c w r" . citar-denote-find-reference)
         ("C-c w l" . citar-denote-link-reference)
         ("C-c w i" . citar-denote-find-citation)
         ("C-c w x" . citar-denote-nocite)
         ("C-c w y" . citar-denote-cite-nocite)
         ("C-c w z" . citar-denote-nobib))
  :preface
  (defun my/citar-denote-open-file (&optional prefix)
    (interactive "P")
    (let* ((file buffer-file-name)
           (citekey (citar-denote--retrieve-references file)))
      (if prefix (other-window-prefix))
      (citar-open-files citekey)))
  :config
  (citar-denote-mode 1))

(use-package citar-embark
  :ensure t
  :after citar embark
  :config
  (citar-embark-mode 1))

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
         ("M-s d" . consult-fd)
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
  (setq consult-fd-args '((if (executable-find "fdfind" 'remote) "fdfind" "fd")
                          "--full-path --color=never" "--hidden" "--exclude" ".git"))
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
  (setq custom-file (make-temp-file "emacs-custom-")))

(use-package dbus
  :if (not (eq system-type 'android))
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

(use-package denote
  :ensure t
  :bind (("C-c n n" . denote)
         ("C-c n o" . denote-open-or-create)
         ("C-c n c" . denote-region)
         ("C-c n N" . denote-type)
         ("C-c n d" . denote-date)
         ("C-c n z" . denote-signature)
         ("C-c n s" . denote-subdirectory)
         ("C-c n t" . denote-template)
         ("C-c n r" . denote-rename-file)
         ("C-c n R" . denote-rename-file-using-front-matter)
         :map org-mode-map :package org
         ("C-c n k" . denote-keywords-add)
         ("C-c n K" . denote-keywords-remove)
         ("C-c n i" . denote-link-or-create)
         ("C-c n I" . denote-add-links)
         ("C-c n b" . denote-backlinks)
         ("C-c n f f" . denote-find-link)
         ("C-c n f b" . denote-find-backlink)
         :map dired-mode-map :package dired
         ("C-c C-d C-i" . denote-link-dired-marked-notes)
         ("C-c C-d C-r" . denote-dired-rename-files)
         ("C-c C-d C-k" . denote-dired-rename-marked-files-with-keywords)
         ("C-c C-d C-R" . denote-dired-rename-marked-files-using-front-matter))
  :hook (dired-mode . denote-dired-mode-in-directories)
  :preface
  ;; TODO: add optional extension
  ;; TODO: handle denote keywords properly
  ;; TODO: optional output-dir
  (defun my/denote-uml-file (description)
    (concat (file-name-sans-extension (file-name-nondirectory buffer-file-name)) "-" description "__"  "uml" ".svg"))
  :config
  (setq denote-directory "~/Nextcloud/org/notes")
  (setq denote-dired-directories (list denote-directory)))

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
  :if (not (eq system-type 'android))
  :hook ((conf-mode . display-line-numbers-mode)
         (prog-mode . display-line-numbers-mode)))

(use-package easymenu
  :if (eq system-type 'android)
  :config
  (easy-menu-define my-menu global-map
    "My Customized Menu for using Emacs on Android."
    '("My"
      ("File"
       ["Save buffers" save-some-buffers])
      ("Org"
       ["Capture" org-capture]
       ["Agenda List" org-agenda-list]
       ["Global TODO List" org-todo-list]
       ["Search for Keywords" org-search-view]
       ["Refile" org-refile])
      ("Magit"
       ["Status" magit-status]))))

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

  (when (or (find-font (font-spec :name "Iosevka"))
            (member system-name '("desktop" "thinkpad"))) ;; Workaround because emacsclient doesnt find iosevka on sway at startup

    (cond ((eq system-type 'android)
           (add-to-list 'default-frame-alist '(font . "Iosevka-12"))
           (set-face-attribute 'default nil :font "Iosevka-12"))
          (t
           (add-to-list 'default-frame-alist '(font . "Iosevka-10"))
           (set-face-attribute 'default nil :font "Iosevka-10"))))

  (setq read-buffer-completion-ignore-case t)

  (cond ((eq system-type 'android)
         (load-theme 'modus-vivendi :no-confirm))
        ((equal system-name "wsl")
         (load-theme 'modus-vivendi :no-confirm))))

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
  (setq delete-old-versions t)

  (auto-save-visited-mode)
  (setq auto-save-visited-interval 1))

(use-package flyspell
  :bind (nil
         :map ctl-x-x-map
         ("s" . flyspell-mode)))

(use-package frame
  :if (eq system-type 'android)
  :config
  ;; Small hack to show the screen keyboard when first opening emacs on android
  (frame-toggle-on-screen-keyboard (selected-frame) nil))

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

(use-package mm-decode
  :config
  (add-to-list 'mm-discouraged-alternatives "text/html")
  (add-to-list 'mm-discouraged-alternatives "text/richtext"))

(use-package mu4e
  :if (executable-find "mu") ;; when there is mu, there should be mu4e
  :demand t
  :hook ((dired-mode . turn-on-gnus-dired-mode)
         (mu4e-compose-mode . flyspell-mode)
         (after-init . (lambda () (mu4e 'background))))
  :bind (:map mu4e-headers-mode-map
         ("C-c c" . mu4e-org-store-and-capture)
         :map mu4e-view-mode-map
         ("C-c c" . mu4e-org-store-and-capture))
  :config
  (setq mail-user-agent 'mu4e-user-agent)
  (setq message-mail-user-agent 'mu4e-user-agent)
  (set-variable 'read-mail-command 'mu4e)

  (setq mu4e-change-filenames-when-moving t)
  (setq mu4e-get-mail-command "mbsync -a")
  (setq mu4e-update-interval 300)
  (setq mu4e-attachment-dir "~/Downloads")

  (setq mu4e-context-policy 'pick-first)
  (setq mu4e-compose-context-policy 'pick-first)

  (setq mu4e-read-option-use-builtin nil)
  (setq mu4e-completing-read-function 'completing-read)
  (setq mu4e-confirm-quit nil)
  (setq mu4e-notification-support t)

  (when (and (auth-source-search :host "127.0.0.1" :max 1) (auth-source-search :host "personal" :max 1))
    (setq mu4e-contexts
          `(,(let ((auth-info (car (auth-source-search :host "127.0.0.1" :max 1))))
               (when auth-info
                 (make-mu4e-context
                  :name (plist-get auth-info :user)
                  :vars `((user-mail-address . ,(plist-get auth-info :user))
                          (user-full-name . ,(plist-get auth-info :name))
                          (message-signature . ,(plist-get auth-info :name))))))
            ,(let ((auth-info (car (auth-source-search :host "personal" :max 1))))
               (when auth-info
                 (make-mu4e-context
                  :name (plist-get auth-info :user)
                  :vars `((user-mail-address . ,(plist-get auth-info :user))
                          (user-full-name . ,(plist-get auth-info :name))
                          (message-signature . ,(plist-get auth-info :name)))))))))

  (setq mu4e-sent-folder "/Sent")
  (setq mu4e-drafts-folder "/Drafts")
  (setq mu4e-trash-folder "/Trash")
  (setq mu4e-refile-folder "/Archive")

  (when (executable-find "msmtp")
    (setq sendmail-program (executable-find "msmtp")))
  (setq message-sendmail-f-is-evil t)
  (setq message-sendmail-extra-arguments '("--read-envelope-from"))
  (setq send-mail-function 'smtpmail-send-it)
  (setq message-send-mail-function 'message-send-mail-with-sendmail)
  (setq message-kill-buffer-on-exit t)

  (setq mu4e-org-contacts-file (concat org-directory "/contacts.org"))
  (add-to-list 'mu4e-headers-actions '("org-contact-add" . mu4e-action-add-org-contact) t)
  (add-to-list 'mu4e-view-actions '("org-contact-add" . mu4e-action-add-org-contact) t))

(use-package mu4e-icalendar
  :after mu4e org org-agenda
  :config
  (mu4e-icalendar-setup)
  (setq gnus-icalendar-org-capture-file (concat org-directory "/calendar.org"))
  (setq gnus-icalendar-org-capture-headline '("iCalendar events"))
  (gnus-icalendar-org-setup))

(use-package nix-mode :ensure t)

(use-package ob-core
  :hook (org-babel-after-execute . org-redisplay-inline-images))

(use-package ob-java
  :after org
  :config
  (org-babel-do-load-languages 'org-babel-load-languages '((java . t)))
  (nconc org-babel-default-header-args:java '((:dir . nil))))

(use-package ob-python
  :after org
  :config
  (org-babel-do-load-languages 'org-babel-load-languages '((python . t))))

(use-package ob-plantuml
  :after (org plantuml-mode)
  :config
  (setq org-plantuml-jar-path plantuml-jar-path)
  (add-to-list 'org-src-lang-modes '("plantuml" . plantuml))
  (org-babel-do-load-languages 'org-babel-load-languages '((plantuml . t))))

(use-package oc
  :after citar org
  :bind (:map org-mode-map :package org
         ("C-c b" . org-cite-insert))
  :custom
  (org-cite-global-bibliography citar-bibliography)
  (org-cite-insert-processor 'citar)
  (org-cite-follow-processor 'citar)
  (org-cite-activate-processor 'citar))

(use-package ol
  :after org-id
  :bind ("C-c l" . org-store-link)
  :preface
  (defun my/org-id-complete-link (&optional arg)
    "Create an id: link using completion"
    (concat "id:"
            (org-id-get-with-outline-path-completion org-refile-targets)))
  (defun my/org-id-link-description (link desc)
    "Return description for `id:` links. Use DESC if non-nil, otherwise fetch headline.
This works across multiple Org files."
    (or desc
        (let* ((id (substring link 3)) ; remove "id:" prefix
               (location (org-id-find id 'marker)) ; Find the location of the ID
               headline)
          (when location
            (with-current-buffer (marker-buffer location)
              (save-excursion
                (goto-char (marker-position location))
                (setq headline (nth 4 (org-heading-components))))))
          headline)))
  :config
  (org-link-set-parameters "id"
                           :complete #'my/org-id-complete-link
                           :insert-description #'my/org-id-link-description))

(use-package ol-man :after org)

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package org
  :bind (nil
         :repeat-map org-mode-repeat-map
         ("<tab>" . org-cycle)
         ("<backtab>" . org-shifttab)
         ("C-n" . org-next-visible-heading)
         ("C-p" . org-previous-visible-heading)
         ("n" . org-next-visible-heading)
         ("p" . org-previous-visible-heading))
  :hook ((org-mode . turn-on-org-cdlatex)
         (org-mode . visual-line-mode))
  :preface
  (defun my/org-refile-to-datetree-with-prompt ()
    "Prompt for a date and refile the current entry into a datetree."
    (interactive)
    (let* ((org-datetree-file "journal.org")
           (date-string (org-read-date nil nil nil "Select date:"))
           (parsed-date (calendar-gregorian-from-absolute (org-time-string-to-absolute date-string))))
      (save-excursion
        (org-cut-subtree)
        (find-file org-datetree-file)
        (org-datetree-find-date-create parsed-date)
        (org-end-of-subtree)
        (newline)
        (org-paste-subtree 4))))

  (when (eq system-type 'ms-dos)
    (defun my/org-onenote-open (link)
      "Open the OneNote item identified by the unique OneNote URL."
      (w32-shell-execute "open" "C:\\Program Files (x86)\\Microsoft Office\\root\\Office16\\ONENOTE.exe" (concat "/hyperlink " "onenote:" (shell-quote-argument link)))))
  :config
  (when (file-directory-p "/sdcard/Documents/Org")
    (setq org-directory "/sdcard/Documents/Org"))

  (setq org-default-notes-file (concat org-directory "/inbox.org"))
  (setq org-agenda-files (list org-directory))

  (when (eq system-type 'ms-dos)
    (org-add-link-type "onenote" 'my/org-onenote-open))

  (setq org-complete-tags-always-offer-all-agenda-tags t)

  (setq org-special-ctrl-k t)

  (setq org-todo-keywords '((sequence "TODO(t)" "STARTED(s)" "WAITING(w@/!)" "|" "DONE(d)" "CANCELED(c@)")))
  (setq org-use-fast-todo-selection 'expert)

  (setq org-log-done 'time)
  (setq org-log-into-drawer t)

  (setq org-archive-location "archive/%s::")

  (setq org-image-actual-width nil)

  (add-to-list 'org-structure-template-alist '("p" . "src python") t)
  (add-to-list 'org-structure-template-alist '("P" . "src plantuml") t)

  (setq org-preview-latex-image-directory "~/.local/share/ltximg/")

  (when (not (eq system-type 'android))
    (setq org-preview-latex-default-process 'dvisvgm)
    (plist-put org-format-latex-options :foreground nil)
    (plist-put org-format-latex-options :background nil))

  (when (eq system-type 'android)
    (setq org-preview-latex-process-alist
          '((dvipng :programs ("latex" "dvipng") :description "dvi > png"
                    :message
                    "you need to install the programs: latex and dvipng."
                    :image-input-type "dvi" :image-output-type "png"
                    :image-size-adjust (1.0 . 1.0) :latex-compiler
                    ("latex -interaction nonstopmode -output-directory %o %f")
                    :image-converter ("dvipng -D 300 -T tight -o %O %f")
                    :transparent-image-converter
                    ("dvipng -D 300 -T tight -bg Transparent -o %O %f")))))

  (add-to-list 'org-default-properties "CREATED" t))

(use-package org-agenda
  :bind ("C-c a" . org-agenda)
  :config
  (setq org-agenda-todo-keyword-format "%7s")

  (setq org-agenda-todo-ignore-deadlines 'future)
  (setq org-agenda-todo-ignore-scheduled 'future)
  (setq org-agenda-todo-ignore-timestamp 'future)

  (setq org-agenda-custom-commands '(("i" "Inbox" tags-todo "+inbox")
	                                 ("s" "Shopping List" tags-todo "+buy")
                                     ("o" "Todo" tags-todo "-project-someday-@aabacka/!-WAITING"
                                      ((org-agenda-skip-function '(org-agenda-skip-subtree-if 'scheduled))
                                       (org-agenda-skip-function '(org-agenda-skip-subtree-if 'deadline))
                                       (org-agenda-skip-function '(org-agenda-skip-subtree-if 'timestamp))))
                                     ("w" "Waiting" tags "/WAITING")
                                     ("S" "Someday" tags-todo "+someday"))))

(use-package org-agenda
  :if (eq system-type 'android)
  :preface
  (defun my/org-category-truncate (s &optional width)
    "Truncate category S to WIDTH (default 12)."
    (let ((w (or width 12)))
      (if (> (length s) w)
          (substring s 0 (- w 1))
        (truncate-string-to-width s w))))
  :config
  (setf (alist-get 'todo org-agenda-prefix-format) "%(my/org-category-truncate (org-get-category) 4) "))

(use-package org-capture
  :after org-contacts
  :bind ("C-c c" . org-capture)
  :preface
  (defvar my/org-contacts-template
    (concat "* %(org-contacts-template-name)\n"
            ":PROPERTIES:\n"
            ":EMAIL: %(org-contacts-template-email)\n"
            ":PHONE:\n"
            ":ALIAS:\n"
            ":NICKNAME:\n"
            ":IGNORE:\n"
            ":ICON:\n"
            ":NOTE: %^{NOTE}\n"
            ":ADDRESS: %^{123 Street, 0001 State, Country}\n"
            ":BIRTHDAY: %^{YYYY-MM-DD}\n"
            ":END:") "Template for a contact.")

  (defvar my/org-capture-created-property
    (concat ":PROPERTIES:\n"
            ":CREATED:  %U\n"
            ":END:\n"))
  :custom
  (org-capture-templates
   `(("i" "Inbox" entry (file "inbox.org")
      ,(concat "* %?\n" my/org-capture-created-property))
     ("e" "Errand" entry (file "errands.org")
      ,(concat "* TODO %?\n" my/org-capture-created-property))
     ("s" "Shopping List" entry (file "shopping_list.org")
      ,(concat "* TODO %?\n" my/org-capture-created-property))

     ;; journaling
     ("j" "Journal")
     ("jj" "Journal entry" entry (file+olp+datetree "journal.org")
      "* %U %^{Title}\n%?")
     ("jJ" "Journal entry (time-prompt)" entry (file+olp+datetree "journal.org")
      "* %U %^{Title}\n%?" :time-prompt t)
     ("jd" "Daily review" entry (file+olp+datetree "journal.org")
      "* %U Daily review\n%?")
     ("jD" "Daily review (time-prompt)" entry (file+olp+datetree "journal.org")
      "* %U Daily review\n%?" :time-prompt t)
     ("jt" "Daily todo" entry (file+olp+datetree "journal.org")
      ,(concat "* TODO Todo for today\nSCHEDULED: %t\n" my/org-capture-created-property "%?"))
     ("jT" "Daily todo (time-prompt)" entry (file+olp+datetree "journal.org")
      ,(concat "* TODO Todo for today\nSCHEDULED: %t\n" my/org-capture-created-property "%?") :time-prompt t)

     ;; meeting notes
     ("n" "Meeting notes" entry (file+headline "notes.org" "Meetings")
      "* %U %^{Title}\n%?")
     ("N" "Meeting notes (custom datetime)" entry (file+headline "notes.org" "Meetings")
      "* %^U %^{Title}\n%?")

     ;; mu4e
     ("m" "Mail" entry (file "inbox.org")
      "* %:fromname\n%U\n%a\n%?")

     ;; org-capture-extension specific (https://github.com/sprig/org-capture-extension)
     ("p" "Protocol" entry (file "inbox.org")
      ,(concat "* %^{Title}\n" my/org-capture-created-property "\nSource: %u, %c\n #+BEGIN_QUOTE\n%i\n#+END_QUOTE\n\n\n%?"))
	 ("L" "Protocol Link" entry (file "inbox.org")
      ,(concat "* %?[[%:link][%:description]] \n" my/org-capture-created-property)))))

(use-package org-contacts
  :ensure t
  :after org
  :custom
  (org-contacts-files (list (concat org-directory "/contacts.org"))))

(use-package org-faces
  :after org
  :config
  (setq org-todo-keyword-faces '(("STARTED" . "yellow4") ("WAITING" . "orange") ("CANCELED" . "gray"))))

(use-package org-id
  :after org
  :config
  (setq org-id-link-to-org-use-id t))

(use-package org-inlinetask :after org)

(use-package org-keys
  :after org
  :config
  (setq org-use-speed-commands t))

(use-package org-protocol)

(use-package org-refile
  :commands (org-refile) ; not sure why this is required, without it, org-refile does not load lazily, and if i use :after org, the keybinding is not defined
  :bind ("C-c o" . (lambda () (interactive) (org-refile '(1))))
  :bind ("C-c C-w" . org-refile)
  :config
  (setq org-outline-path-complete-in-steps nil)
  (setq org-refile-use-outline-path 'file)
  (setq org-refile-allow-creating-parent-nodes 'confirm)
  (setq org-refile-targets '((org-agenda-files . (:maxlevel . 9)))))

(use-package org-src
  :after org
  :config
  (setq org-edit-src-content-indentation 0))

(use-package org-tempo :after org)

(use-package outline
  :bind (nil
         :repeat-map outline-navigation-repeat-map
         ("<tab>" . outline-cycle)
         ("<backtab>" . outline-cycle-buffer))
  :hook ((LaTeX-mode . outline-minor-mode)
         (prog-mode . outline-minor-mode))
  :custom
  (outline-minor-mode-cycle t))

(use-package ox-publish
  :config
  (setq org-publish-project-alist
        '(("org-notes"
           :base-directory "~/Documents/notes"
           :exclude ".*_nopublish.*"
           :publishing-directory "/tmp/public"
           :recursive t
           :publishing-function org-html-publish-to-html
           :headline-levels 4
           :auto-preamble t
           :auto-sitemap t
           :sitemap-filename "sitemap.html"
           :sitemap-title "Sitemap")
          ("images"
           :base-directory "~/Documents/notes/images"
           :base-extension "png\\|svg"
           :exclude ".*_nopublish.*"
           :publishing-directory "/tmp/public/images"
           :recursive t
           :publishing-function org-publish-attachment))))

(use-package pascal-mode
  :mode "\\.\\(pou\\|st\\)\\'")

(use-package pdf-tools
  :ensure t
  :magic ("%PDF" . pdf-view-mode)
  :config
  (pdf-tools-install :no-query))

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

(use-package tex
  :ensure auctex
  :hook ((LaTeX-mode . turn-on-reftex)
         (LaTeX-mode . turn-on-cdlatex)
         (LaTeX-mode . prettify-symbols-mode)
         (LaTeX-mode . (lambda () (TeX-fold-mode 1)))
         (LaTeX-mode . (lambda () (set (make-local-variable 'TeX-electric-math)
					                   (cons "\\(" "\\)")))))
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master nil)

  (setq LaTeX-electric-left-right-brace t))

(use-package tool-bar
  :if (eq system-type 'android)
  :custom
  (tool-bar-position 'bottom)
  (tool-bar-button-margin 16)
  (tool-bar-mode t)
  (modifier-bar-mode t))

(use-package touch-screen
  :if (eq system-type 'android)
  :custom
  (touch-screen-display-keyboard t))

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

(use-package vertico
  :if (eq system-type 'android)
  :custom
  (vertico-count 5)
  (vertico-resize t))

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
