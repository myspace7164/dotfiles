(use-package package
  :init
  (when (getenv "EMACS_WORK")
    (setq package-gnupghome-dir "~/.emacs.d/elpa/gnupg"))
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
  :commands cape-file
  :init
  (add-hook 'completion-at-point-functions #'cape-file))

(use-package cdlatex
  :ensure t)

(use-package citar
  :ensure t
  :bind (("C-c w c" . citar-create-note)
         ("C-c w o" . citar-open)
         ("C-c w F" . citar-open-files)
         ("C-c w N" . citar-open-notes))
  :hook ((LaTeX-mode . citar-capf-setup)
         (org-mode . citar-capf-setup))
  :custom
  (citar-bibliography '("~/cloud/ref/books/references.bib"))
  (citar-library-paths '("~/cloud/ref/books"))
  (citar-notes-paths '("~/cloud/notes")))

(use-package citar-denote
  :ensure t
  :after citar denote
  :bind (("C-c w f" . citar-denote-open-file)
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
  :config
  (citar-denote-mode 1)

  (defun citar-denote-open-file (&optional prefix)
    (interactive "P")
    (let* ((file buffer-file-name)
           (citekey (citar-denote--retrieve-references file)))
      (if prefix (other-window-prefix))
      (citar-open-files citekey))))

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
  :custom
  (corfu-auto t)
  :config
  (defun corfu-enable-always-in-minibuffer ()
    "Enable Corfu in the minibuffer if Vertico/Mct are not active."
    (unless (or (bound-and-true-p mct--active)
                (bound-and-true-p vertico--input)
                (eq (current-local-map) read-passwd-map))
      ;; (setq-local corfu-auto nil) ;; Enable/disable auto completion
      (setq-local corfu-echo-delay nil ;; Disable automatic echo and popup
                  corfu-popupinfo-delay nil)
      (corfu-mode 1)))
  (add-hook 'minibuffer-setup-hook #'corfu-enable-always-in-minibuffer 1)
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
  :config
  ;; TODO: add optional extension
  ;; TODO: handle denote keywords properly
  ;; TODO: optional output-dir
  (defun my/denote-uml-file (description)
    (concat (file-name-sans-extension (file-name-nondirectory buffer-file-name)) "-" description "__"  "uml" ".svg"))

  (setq denote-directory "~/cloud/notes")
  (setq denote-dired-directories (list denote-directory)))

(use-package dired
  :bind (nil
         :map dired-mode-map
         ("b" . dired-up-directory))
  :hook (dired-mode . dired-hide-details-mode)
  :custom
  (dired-auto-revert-buffer t)
  (dired-recursive-copies 'always)
  (dired-recursive-deletes 'always)
  (dired-listing-switches "-AGhlv --group-directories-first")

  (dired-create-destination-dirs 'always)
  (dired-create-destination-dirs-on-trailing-dirsep t)

  (wdired-allow-to-change-permissions t))

(use-package dired
  :if (eq system-type 'darwin)
  :config
  (setq dired-use-ls-dired nil))

(use-package dired-subtree
  :ensure t
  :after dired
  :bind (nil
         :map dired-mode-map
         ("<tab>" . dired-subtree-toggle)
         ("<backtab>" . dired-subtree-cycle))
  :custom
  (dired-subtree-use-backgrounds nil))

(use-package direnv
  :if (member (system-name) '("thinkpad" "desktop"))
  :ensure t
  :config
  (direnv-mode 1))

(use-package display-line-numbers
  :hook ((conf-mode . display-line-numbers-mode)
         (prog-mode . display-line-numbers-mode)))

(use-package eglot
  :hook (python-mode . eglot-ensure))

(use-package eldoc
  :custom
  (eldoc-echo-area-prefer-doc-buffer t)
  (eldoc-echo-area-use-multiline-p nil))

(use-package elec-pair
  :hook ((comint-mode . electric-pair-local-mode)
         (minibuffer-mode . electric-pair-local-mode)
	     (prog-mode . electric-pair-local-mode)))

(use-package emacs
  :bind ("M-Q" . unfill-paragraph)
  :config
  (setq visible-bell t)

  (setq delete-by-moving-to-trash t)
  (setq enable-recursive-minibuffers t)
  (setq mac-right-option-modifier "none")
  (setq use-short-answers t)

  (setq-default tab-width 4)
  (setq tab-always-indent 'complete)

  (defun unfill-paragraph (&optional region)
    "Takes a multi-line paragraph and makes it into a single line of text."
    (interactive (progn (barf-if-buffer-read-only) '(t)))
    (let ((fill-column (point-max))
	      ;; This would override `fill-column' if it's an integer.
	      (emacs-lisp-docstring-fill-column t))
      (fill-paragraph nil region)))

  (add-to-list 'default-frame-alist '(font . "Iosevka-10"))

  (setq read-buffer-completion-ignore-case t))

(use-package emacs
  :if (getenv "EMACS_WORK")
  :config
  (prefer-coding-system 'utf-8)
  (set-default-coding-systems 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (setq coding-system-for-read 'utf-8)
  (setq coding-system-for-write 'utf-8))

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

(use-package faces
  :config
  (set-face-attribute 'default nil :font "Iosevka-10"))

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

(use-package ispell
  :custom
  (ispell-program-name "hunspell"))

(use-package json-mode
  :ensure t
  :mode "\\.json\\'")

(use-package magit
  :ensure t
  :defer t
  :config
  (setq magit-repository-directories '(("~/repos" . 1)
                                       ("~/.config/nvim" . 1))))

(use-package marginalia
  :ensure t
  :config
  (marginalia-mode 1))

(use-package markdown-mode
  :ensure t
  :mode "\\.md\\'")

(use-package matlab-mode
  :if (getenv "EMACS_WORK")
  :ensure t)

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

(use-package move-text
  :ensure t
  :bind (("M-<up>" . move-text-up)
         ("M-<down>" . move-text-down)))

(use-package mu4e
  :if (member (system-name) '("mailer"))
  :commands (mu4e)
  :hook (;; start mu4e in background, allows to immediately compose-mail
         (after-init . (lambda () (mu4e t)))
         (dired-mode . turn-on-gnus-dired-mode)
         (mu4e-compose-mode . flyspell-mode))
  :bind (nil
         :map mu4e-headers-mode-map
         ("C-c c" . mu4e-org-store-and-capture)
         :map mu4e-view-mode-map
         ("C-c c" . mu4e-org-store-and-capture))
  :init
  (setq mail-user-agent 'mu4e-user-agent)
  :config
  (setq message-mail-user-agent 'mu4e-user-agent)
  (set-variable 'read-mail-command 'mu4e)

  (setq mu4e-change-filenames-when-moving t)
  (setq mu4e-get-mail-command "mbsync -a")
  (setq mu4e-update-interval 300)
  (setq mu4e-attachment-dir "~/tmp")

  (setq mu4e-context-policy 'pick-first)
  (setq mu4e-compose-context-policy 'pick-first)

  (setq mu4e-read-option-use-builtin nil)
  (setq mu4e-completing-read-function 'completing-read)
  (setq mu4e-confirm-quit nil)
  (setq mu4e-notification-support t)

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
                        (message-signature . ,(plist-get auth-info :name))))))))

  (setq mu4e-sent-folder "/Sent")
  (setq mu4e-drafts-folder "/Drafts")
  (setq mu4e-trash-folder "/Trash")
  (setq mu4e-refile-folder "/Archive")
  
  (if (member (system-name) '("desktop" "thinkpad"))
      (setq sendmail-program "/run/current-system/sw/bin/msmtp")
    (setq sendmail-program "/usr/bin/msmtp"))
  (setq message-sendmail-f-is-evil t)
  (setq message-sendmail-extra-arguments '("--read-envelope-from"))
  (setq send-mail-function 'smtpmail-send-it)
  (setq message-send-mail-function 'message-send-mail-with-sendmail)
  (setq message-kill-buffer-on-exit t))

(use-package mu4e-icalendar
  :after mu4e org-agenda
  :config
  (mu4e-icalendar-setup)
  (setq gnus-icalendar-org-capture-file "~/cloud/org/calendar.org")
  (setq gnus-icalendar-org-capture-headline '("iCalendar events"))
  (gnus-icalendar-org-setup))

(use-package nix-mode
  :ensure t
  :defer t)

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
  :config
  (defun my/org-id-link-description (link desc)
  "Return description for `id:` links. Use DESC if non-nil, otherwise fetch headline.
This works across multiple Org files."
  (or desc
      (let* ((id (substring link 3)) ; remove "id:" prefix
             (location (org-id-find id 'marker)) ; Find the location of the ID
             headline)
        (when location
          (with-current-buffer (marker-buffer location)
            (goto-char (marker-position location))
            (setq headline (nth 4 (org-heading-components)))))
        headline)))

  (org-link-set-parameters "id"
                           :complete (lambda () (concat "id:" (org-id-get-with-outline-path-completion org-refile-targets)))
                           :insert-description 'my/org-id-link-description)
  (setq org-link-descriptive nil))

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
  :config
  (setq org-directory "~/cloud/org")
  (setq org-agenda-files (list org-directory))
  (when (file-exists-p "~/.local/share/org/caldav.org")
    (add-to-list 'org-agenda-files "~/.local/share/org/caldav.org" t))
  (setq org-complete-tags-always-offer-all-agenda-tags t)

  (setq org-special-ctrl-k t)

  (setq org-todo-keywords '((sequence "TODO(t)" "STARTED(s)" "WAITING(w@/!)" "|" "DONE(d)" "CANCELED(c@)")))
  (setq org-use-fast-todo-selection 'expert)

  (setq org-log-done 'time)
  (setq org-log-into-drawer t)
  (setq org-startup-indented t)
  (setq org-startup-folded t)

  (setq org-archive-location "archive/%s::")

  (setq org-image-actual-width nil)

  (add-to-list 'org-structure-template-alist '("p" . "src python") t)
  (add-to-list 'org-structure-template-alist '("P" . "src plantuml") t)

  (setq org-preview-latex-image-directory "~/.local/share/ltximg/")
  (setq org-preview-latex-default-process 'dvisvgm)

  (plist-put org-format-latex-options :foreground nil)
  (plist-put org-format-latex-options :background nil)
  (when (member (system-name) '("thinkpad"))
    (plist-put org-format-latex-options :scale 0.3))

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
        (org-paste-subtree 4)))))

(use-package org
  :if (member (system-name) '("WINDOWS"))
  :config
  (setq org-directory "~/Nextcloud/org")
  (setq org-agenda-files (list org-directory)))

(use-package org
  :if (getenv "EMACS_WORK")
  :config
  (setq org-directory "~/org")
  (setq org-agenda-files (list org-directory))

  (org-add-link-type "onenote" 'org-onenote-open)
  (defun org-onenote-open (link)
    "Open the OneNote item identified by the unique OneNote URL." 
    (w32-shell-execute "open" "C:\\Program Files (x86)\\Microsoft Office\\root\\Office16\\ONENOTE.exe" (concat "/hyperlink " "onenote:" (shell-quote-argument link)))))

(use-package org-agenda
  :bind ("C-c a" . org-agenda)
  :config
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

(use-package org-capture
  :bind ("C-c c" . org-capture)
  :config
  (setq org-capture-templates '(("i" "Inbox" entry (file "inbox.org")
                                 "* %?\n%U")
                                ("m" "Mail" entry (file "inbox.org")
                                 "* %:fromname\n%U\n%a\n%?")
                                ("j" "Journal" entry (file+olp+datetree "journal.org")
                                 "* %U %^{Title}\n%?")
                                ("J" "Journal (custom datetime)" entry (file+olp+datetree "journal.org")
                                 "* %U %^{Title}\n%?" :time-prompt t)
                                ("p" "Protocol" entry (file "inbox.org")
                                 "* %^{Title}\n%U\nSource: %u, %c\n #+BEGIN_QUOTE\n%i\n#+END_QUOTE\n\n\n%?")
	                            ("L" "Protocol Link" entry (file "inbox.org")
                                 "* %?[[%:link][%:description]] \n%U")
                                ("n" "Meeting notes" entry (file+headline "notes.org" "Meetings")
                                 "* %U %^{Title}\n%?")
                                ("N" "Meeting notes (custom datetime)" entry (file+headline "notes.org" "Meetings")
                                 "* %^U %^{Title}\n%?"))))

;; TODO This needs some fixing, org-latex-previews are toggled even when latex previews are disabled
;; Write a function toggle-org-fragtog (or similar) which when enabled, will generate all latex previews and enable org-fragtog-mode, if org-fragtog-mode is disabled, no latex previews should be generated
;; (use-package org-fragtog
;;   :ensure t
;;   :hook (org-mode . org-fragtog-mode))

(use-package org-caldav
  :if (member (system-name) '("caldav"))
  :ensure t
  :custom
  (org-caldav-inbox "~/.local/share/org/caldav.org")
  (org-caldav-sync-direction 'cal->org)
  (org-caldav-show-sync-results nil)
  :config
  (let ((auth-info (car (auth-source-search :host "caldav" :max 1))))
    (setq org-caldav-url (plist-get auth-info :url))
    (setq org-caldav-calendar-id (plist-get auth-info :id)))
  (run-at-time nil (* 5 60) 'org-caldav-sync))

(use-package org-faces
  :after org
  :config
  (setq org-todo-keyword-faces '(("STARTED" . "yellow4")
                                 ("WAITING" . "orange")
                                 ("CANCELED" . "gray"))))

(use-package org-id
  :after org
  :config
  (setq org-id-link-to-org-use-id t))

(use-package org-keys
  :after org
  :config
  (setq org-use-speed-commands t))

(use-package org-pdftools
  :ensure t
  :if (eq system-type 'gnu/linux)
  :hook (org-mode . org-pdftools-setup-link))

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
  :defer t
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
  :if (eq system-type 'gnu/linux)
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

(use-package saveplace-pdf-view
  :ensure t)

(use-package standard-themes
  :if (or window-system (daemonp))
  :ensure t
  :bind ("<f5>" . standard-themes-toggle)
  :init
  (when (member (system-name) '("WINDOWS"))
    (load-theme 'standard-light :no-confirm))
  (when (or (member (system-name) '("thinkpad" "desktop" "player"))
            (getenv "EMACS_WORK"))
    (load-theme 'standard-dark :no-confirm)))

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

(use-package warnings
  :config
  (setq warning-suppress-types '((defvaralias))))

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
