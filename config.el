;;; config.el --- generated from config.org  -*- lexical-binding: t; -*-

(message "== Bootstrap ==")
(message "This is from config.org --> config.el")
(message "you are in %s" (shell-command-to-string "uname -a"))
(message "Sytem type %s %s" system-type system-configuration)
(message "----------------------------")

(add-to-list 'load-path "~/.emacs.d/local")
(add-to-list 'load-path "~/.emacs.d/local/skewer-mode")

(require 'package) ; use C-h P to describe packages

(setq package-archives
      '(("gnu"       . "https://elpa.gnu.org/packages/")
        ("nongnu"    . "https://elpa.nongnu.org/nongnu/")
        ("melpa"     . "https://melpa.org/packages/")
        ("elpa-devel". "https://elpa.gnu.org/devel/")
        ("org"       . "https://orgmode.org/elpa/")))

(package-initialize)
(setq use-package-always-ensure t)

(unless package-archive-contents
  (package-refresh-contents))

(use-package exec-path-from-shell
  :ensure t)

(message "== Core ==")

(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(when (file-exists-p custom-file)
  (load custom-file))

(setq backup-by-copying t              ; don't clobber symlinks
      backup-directory-alist '(("." . "~/.emacs.d/.saves/"))
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)               ; use versioned backups

(require 'uniquify)

(defun my/face-attrs-nil->unspecified (attrs)
  "In face attribute plist ATTRS, replace nil values with `unspecified'."
  (if (and (consp attrs) (keywordp (car attrs)))
      (let (out)
        (while attrs
          (push (car attrs) out)
          (push (if (null (cadr attrs)) 'unspecified (cadr attrs)) out)
          (setq attrs (cddr attrs)))
        (nreverse out))
    attrs))

(defun my/face-spec-nil->unspecified (spec)
  "Sanitize a defface-style SPEC, replacing nil attribute values."
  (if (consp spec)
      (mapcar (lambda (entry)
                (if (and (consp entry) (cdr entry))
                    (cons (car entry)
                          (mapcar #'my/face-attrs-nil->unspecified (cdr entry)))
                  entry))
              spec)
    spec))

(defun my/sanitize-theme-faces (args)
  "Filter-args advice for `custom-theme-set-faces'."
  (cons (car args)
        (mapcar (lambda (a)
                  (if (and (consp a) (cdr a))
                      (cons (car a)
                            (cons (my/face-spec-nil->unspecified (cadr a))
                                  (cddr a)))
                    a))
                (cdr args))))

(advice-add 'custom-theme-set-faces :filter-args #'my/sanitize-theme-faces)

(use-package gruber-darker-theme
  :ensure t
  :config
  (load-theme 'gruber-darker t))

(global-hl-line-mode 1)

(with-eval-after-load 'org
  ;; Background + brighter foreground for all src blocks
  (set-face-attribute 'org-block nil
                      :background "#202020"
                      :foreground "#e0e0e0")
  ;; begin/end lines
  (set-face-attribute 'org-block-begin-line nil
                      :foreground "#888888"
                      :background "#181818")
  (set-face-attribute 'org-block-end-line nil
                      :foreground "#888888"
                      :background "#181818"))

(global-set-key (kbd "C-=") #'text-scale-increase)
(global-set-key (kbd "C--") #'text-scale-decrease)
(global-set-key (kbd "M-\\") (lambda () (interactive) (other-window -1)))

(use-package which-key
  :ensure nil
  :config
  (which-key-mode))

(message "== Completion ==")

(use-package vertico
  :ensure t
  :custom
  (vertico-scroll-margin 0)
  (vertico-count 15)                   ; show more candidates
  (vertico-resize t)                   ; grow and shrink the minibuffer
  (vertico-cycle t)                    ; cycle with vertico-next/previous
  :init
  (vertico-mode))

(use-package savehist
  :ensure nil
  :init
  (savehist-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles basic partial-completion))))
  (completion-pcm-leading-wildcard t))

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

(use-package consult
  :ensure t)

(use-package embark
  :ensure t
  :bind
  (("C-."   . embark-act)
   ("C-;"   . embark-dwim)))

(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-preselect-first t)
  :init
  (global-corfu-mode))

(use-package cape
  :ensure t
  :after corfu
  :bind ("C-c p" . cape-prefix-map))   ; alternatives: M-<tab>, M-p, M-+

(use-package kind-icon
  :ensure t
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(message "== Navigation ==")

(use-package avy
  :ensure t
  :bind (("C-:"     . avy-goto-char)
         ("C-'"     . avy-goto-char-2)
         ("M-g f"   . avy-goto-line)
         ("M-g w"   . avy-goto-word-1)
         ("M-g e"   . avy-goto-word-0)
         ("C-c C-j" . avy-resume))
  :config
  (avy-setup-default))

(use-package projectile
  :ensure t
  :defer t
  :custom
  (projectile-project-search-path '("~/p/" "~/apps/" ("~/repos" . 1))))

(use-package speedbar
  :ensure nil
  :defer t
  :custom
  (speedbar-show-unknown-files t)
  (speedbar-directory-unshown-regexp "^$")
  (speedbar-ignored-directory-expressions nil))

(message "== Editing ==")

(add-to-list 'load-path "/home/vukini/repos/paredit")
(autoload 'enable-paredit-mode "paredit"
  "Turn on pseudo-structural editing of Lisp code."
  t)

(dolist (hook '(emacs-lisp-mode-hook
                lisp-mode-hook
                racket-mode-hook
                racket-repl-mode-hook))
  (add-hook hook #'enable-paredit-mode))

(use-package yasnippet
  :ensure t
  :hook ((prog-mode text-mode conf-mode) . yas-minor-mode)
  :custom
  (yas-snippet-dirs '("~/.emacs.d/snippets")))

(use-package yasnippet-snippets
  :ensure t
  :after yasnippet)

(add-to-list 'load-path "~/.emacs.d/local/emacs-haskell-unicode-input-method")
(require 'haskell-unicode-input-method)

(add-hook 'haskell-mode-hook
          (lambda () (set-input-method "haskell-unicode")))

(message "== Languages ==")

(use-package eglot
  :ensure nil
  :custom
  (eglot-events-buffer-size 0)         ; 0 = unlimited event log
  :config
  (add-to-list 'eglot-server-programs '(zig-mode . ("zls")))
  (add-to-list 'eglot-server-programs '((odin-mode odin-ts-mode) . ("ols"))))

(when (boundp 'treesit-extra-load-path)
  (add-to-list 'treesit-extra-load-path
               (expand-file-name "tree-sitter" user-emacs-directory)))

(use-package slime
  :ensure t
  :init
  (setq inferior-lisp-program "sbcl")
  :config
  (slime-setup '(slime-fancy))
  (add-hook 'slime-load-hook
            (lambda ()
              (define-key slime-prefix-map (kbd "M-h")
                          #'slime-documentation-lookup))))

;; Local HyperSpec, if quicklisp has set one up. Missing file is not an error.
(load "/home/vukini/quicklisp/clhs-use-local.el" t)

(use-package racket-mode
  :ensure t
  :hook (racket-mode . racket-xp-mode)
  :bind (:map racket-repl-mode-map
              ("RET" . racket-repl-submit)))

(use-package python
  :ensure nil
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("python" . python-mode)
  :hook (python-mode . eglot-ensure)
  :custom
  (python-shell-interpreter "ipython")
  (python-shell-interpreter-args "-i --simple-prompt")
  ;; Let eglot/corfu handle completion instead of the native REPL protocol.
  (python-shell-completion-native-enable nil)
  (python-shell-completion-native-disabled-interpreters
   '("python" "python3" "ipython")))

(use-package pyvenv
  :ensure t
  :custom
  (pyvenv-mode-line-indicator
   '(pyvenv-virtual-env-name ("[venv:" pyvenv-virtual-env-name "] ")))
  :config
  (pyvenv-mode 1))

(use-package odin-ts-mode
  :ensure nil
  :mode "\\.odin\\'"
  :hook (odin-mode . eglot-ensure))

(use-package zig-mode
  :ensure t
  :mode "\\.zig\\'"
  :hook (zig-mode . eglot-ensure))

(use-package jinja2-mode
  :ensure t
  :mode ("\\.jinja\\'" "\\.j2\\'" "\\.tmpl\\'")
  :hook (jinja2-mode . (lambda ()
                         (setq-local comment-start "{# "
                                     comment-end   " #}"))))

(use-package csv-mode
  :ensure t
  :defer t)

(use-package lua-mode      :ensure t :defer t)
(use-package go-mode       :ensure t :defer t)
(use-package php-mode      :ensure t :defer t)
(use-package markdown-mode :ensure t :defer t)
(use-package rfc-mode      :ensure t :defer t)

(message "== Tools ==")

(use-package magit
  :ensure t
  :commands (magit-status magit-blame-addition)
  :bind ("C-x g" . magit-status)
  :custom
  (magit-save-repository-buffers 'dontask)   ; save without asking
  (magit-no-confirm '(stage-all-changes))    ; fewer prompts
  (magit-display-buffer-function
   #'magit-display-buffer-fullframe-status-topleft-v1)
  (magit-section-visibility-indicator nil)
  (magit-diff-refine-hunk 'all)
  (magit-bury-buffer-function 'magit-restore-window-configuration)
  (magit-repository-directories '(("~/p"     . 2)
                                  ("~/repos" . 2))))

(use-package pdf-tools
  :ensure t
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :init
  ;; pdf-loader ships with pdf-tools and enables lazy loading.
  (use-package pdf-loader
    :ensure nil
    :commands (pdf-loader-install)
    :init (pdf-loader-install))
  :config
  (setq-default pdf-view-display-size 'fit-page))

(use-package nov
  :ensure t
  :mode ("\\.epub\\'" . nov-mode))

(use-package gptel
  :ensure t
  :config
  (setenv "OPENAI_API_KEY"
          (or (getenv "OPENAI_API_KEY")
              (exec-path-from-shell-getenv "OPENAI_API_KEY")))
  (setenv "PERPLEXITY_API_KEY"
          (or (getenv "PERPLEXITY_API_KEY")
              (exec-path-from-shell-getenv "PERPLEXITY_API_KEY")))

  (setq my-gptel-openai
        (gptel-make-openai "OpenAI"
          :key (lambda () (getenv "OPENAI_API_KEY"))
          :models '(gpt-4o gpt-4o-mini)))

  (setq my-gptel-perplexity
        (gptel-make-perplexity "Perplexity"
          :key (lambda () (getenv "PERPLEXITY_API_KEY"))
          :models '(sonar sonar-pro)))

  ;; Default backend
  (setq gptel-backend my-gptel-perplexity
        gptel-model 'sonar-pro))
