(message "This is from config.org --> config.el")
  (message "you are in %s" (shell-command-to-string "uname -a")) 
  (message "Sytem type %s %s" system-type system-configuration)
  (message "----------------------------")

;;  (setq debug-on-error t)

  (add-to-list 'load-path "~/.emacs.d/local")
  (global-set-key (kbd "C-=") 'text-scale-increase)
  (global-set-key (kbd "C--") 'text-scale-decrease)
  ;;(global-set-key (kbd "C-\\") 'comment-region)
  ;;(global-set-key (kbd "C-M-\\") 'uncomment-region)
  ;;currently commented as using M-; 'comment-dwim (do what i mean)
  ;;(evil-mode nil) 
  ;;(server-start)                                    ;; Do I really need this?  
  (hl-line-mode t)

(require 'uniquify)

(setq package-archives
      '(("gnu"       . "https://elpa.gnu.org/packages/")
        ("nongnu"    . "https://elpa.nongnu.org/nongnu/")
        ("melpa"     . "https://melpa.org/packages/")
        ("elpa-devel". "https://elpa.gnu.org/devel/")
        ("org"       . "https://orgmode.org/elpa/")))

(package-initialize) ;this loads the installed packages and activates them
(setq use-package-always-ensure t) ; ensures that packages not installed are
(require 'package) ; use C-h P (to describe packages)
(unless package-archive-contents
  (package-refresh-contents))

(message "Window Management")
;(global-set-key (kbd "M-\\") 'other-window)
(global-set-key (kbd "M-\\") (lambda () (interactive) (other-window -1)))

(load "rc.el")
(message "Setting Theme")
(rc/require-theme 'gruber-darker)
;;(load-theme 'leuven-dark)

(rc/require 'which-key)
(which-key-mode)			

(rc/require 'projectile)

(rc/require
 'lua-mode
 'less-css-mode
 'cmake-ts-mode
 'markdown-mode
 ;'purescript-mode
 'go-mode
 'php-mode
 'racket-mode
 'rfc-mode) 
(setq lsp-racket-server-command '("racket" "-l" "racket-langserver"))
(add-hook 'racket-mode-hook #'racket-xp-mode)
(add-hook 'racket-repl-mode-hook
	  (lambda ()
	    (keymap-set racket-repl-mode-map (kbd "RET") 'racket-repl-submit)))

(message "Loading custom-file")
(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load-file custom-file)

(message "Backup Directories")
  (setq
   backup-by-copying t			; don't clobber symlinks
   backup-directory-alist
   '(("." . "~/.emacs.d/.saves/"))			; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups

(message "Corfu!")
(use-package corfu
  :ensure t
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-preselect-first t))

;  (rc/require 'vertico)
;  (vertico-mode 1)
(use-package vertico
  :custom
  (vertico-scroll-margin 0) ;; Different scroll margin
  (vertico-count 15) ;; Show more candidates
  (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
  (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
  :init
  (vertico-mode))

(use-package savehist
      :init
      (savehist-mode))

;; ;; Emacs minibuffer configurations.
;; (use-package emacs
;;   :custom
;;   ;; Enable context menu. `vertico-multiform-mode' adds a menu in the minibuffer
;;   ;; to switch display modes.
;;   (context-menu-mode t)
;;   ;; Support opening new minibuffers from inside existing minibuffers.
;;   (enable-recursive-minibuffers t)
;;   ;; Hide commands in M-x which do not work in the current mode.  Vertico
;;   ;; commands are hidden in normal buffers. This setting is useful beyond
;;   ;; Vertico.
;;   (read-extended-command-predicate #'command-completion-default-include-p)
;;   ;; Do not allow the cursor in the minibuffer prompt
;;   (minibuffer-prompt-properties
;;    '(read-only t cursor-intangible t face minibuffer-prompt)))

(use-package cape
  :ensure t
  :init
  :bind ("C-c p" . cape-prefix-map) ;; Alternative key: M-<tab>, M-p, M-+
  :after corfu)

(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)
   ("C-;" . embark-dwim)))

(use-package consult :ensure t)

(use-package marginalia
   :ensure t
   :init (marginalia-mode))

(setq projectile-project-search-path '("~/p/" "~/apps/" ("~/repos" . 1)))

(use-package kind-icon
   :ensure t
   :after corfu
   :config
   (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(message "PDF Tools")
(use-package pdf-tools
  :ensure t
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :init
  ;; Enable lazy loading for PDFs
  (use-package pdf-loader
    :ensure nil              ;; comes from pdf-tools
    :commands (pdf-loader-install)
    :init (pdf-loader-install))
  :config
  ;; Optional defaults
  (setq-default pdf-view-display-size 'fit-page))

(message "lsp-mode")
;; (use-package lsp-mode
;;   :ensure t
;;   :commands (lsp lsp-defered)
;;   :hook ((python-mode . lsp)
;;          (go-mode . lsp)
;;          (c-mode . lsp)
;;          (c++-mode . lsp)
;;  (lsp-completion-mode . my/lsp-use-orderless))
;;   :config
;;   (with-eval-after-load 'lsp-mode
;;     (setq lsp-clients-lua-language-server-bin "/usr/bin/lua-language-server"))
;;   :init
;;   (setq lsp-keymap-prefix "C-c l")
;;   (defun my/lsp-use-orderless ()
;;     (setf (alist-get 'style (alist-get 'lsp-capf completion-category-defaults))
;;       '(orderless))))
  
;;   (use-package lsp-ui :ensure t :commands lsp-ui-mode)
;;   (use-package lsp-ivy :ensure t :commands lsp-ivy-workspace-symbol)

(message "Yasnippet")
  (use-package yasnippet
    :ensure t
    :hook ((prog-mode text-mode conf-mode) . yas-minor-mode)
    :init
    (setq yas-snippet-dirs '("~/.emacs.d/snippets")))
  
  (use-package yasnippet-snippets
    :ensure t
    :after yasnippet)

(message "go-mode")
;; (message ”this is from go lsp”)
;; (use-package go-mode
;;   :ensure t
;;   :mode "\.go\'")

(message "Magit")
(use-package magit
  :ensure t
  :commands (magit-status magit-blame-addition)
  :init
  (setq magit-save-repository-buffers 'dontask ; save without asking
	  magit-no-confirm '(stage-all-changes)) ; fewer prompts
  (setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-topleft-v1
	  magit-section-visibility-indicator nil
	  magit-diff-refine-hunk 'all)
  (setq magit-bury-buffer-function 'magit-restore-window-configuration)
  (setq magit-repository-directories '(("~/p" . 2)
					 ("~/repos" . 2)))
  :config
  (global-set-key (kbd "C-x g") #'magit-status))

(message "PureScript")

(message "exec-path-from-shell")
(use-package exec-path-from-shell
  :ensure t)

(message "gptel")
(use-package gptel
  :ensure t
  :config
  ;; Perplexity backend
   (setq my-gptel-openai
        (gptel-make-openai "OpenAI"
          :key (exec-path-from-shell-getenv "OPENAI_API_KEY")
	  ;;:endpoint "/vi/chat/completions"
          :models '(gpt-4o gpt-4o-mini)))
  ;; Perplexity backend
  (setq my-gptel-perplexity
        (gptel-make-perplexity "Perplexity"
          :key (exec-path-from-shell-getenv "PERPLEXITY_API_KEY")
          :models '(sonar sonar-pro)))  ;; example models
  (setq gptel-backend my-gptel-openai
      gptel-model 'gpt-4o)
  (setq gptel-backend my-gptel-perplexity
      gptel-model 'sonar-pro))

(defun gp (alternative)
"choose your ai"
(interactive "MChoose backend: ")
(message alternative)
(if (equal alternative "o")
    (setq gptel-backend my-gptel-openai
        gptel-model 'gpt-4o))
    (setq gptel-backend my-gptel-perplexity
          gptel-model 'sonar-pro))

(message "Avy")
(use-package avy
  :ensure t
  :config
  (global-set-key (kbd "C-:") 'avy-goto-char)
  (global-set-key (kbd "C-'") 'avy-goto-char-2)
  (global-set-key (kbd "M-g f") 'avy-goto-line)
  (global-set-key (kbd "M-g w") 'avy-goto-word-1)
  (global-set-key (kbd "M-g e") 'avy-goto-word-0)
  (avy-setup-default)
  (global-set-key (kbd "C-c C-j") 'avy-resume))

;  (load (expand-file-name "~/quicklisp/slime-helper.el"))
  ;  ;; Replace "sbcl" with the path to your implementation
(setq inferior-lisp-program "sbcl")
(slime-setup '(slime-fancy))
(add-hook 'slime-load-hook
	    (lambda ()
	      (define-key
	       slime-prefix-map
	       (kbd "M-h")
	       'slime-documentation-lookup)))
(load "/home/vukini/quicklisp/clhs-use-local.el" t)

(message "Paredit")
  (add-to-list 'load-path "/home/vukini/repos/paredit")
  (autoload 'enable-paredit-mode "paredit"
    "Turn on pseudo-structural editing of Lisp Code"
    t)
  (add-hook 'M-mode-hook 'enable-paredit-mode)

    (eval-after-load 'paredit
      '(progn
         (define-key paredit-mode-map (kbd "ESC M-A-C-s-)")
          'paredit-dwim)))
  (add-hook 'racket-mode-hook #'paredit-mode)
  (add-hook 'racket-repl-mode-hook #'paredit-mode)
  (add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-mode-hook 'enable-paredit-mode)

(message "Haskell Unicode")
(add-to-list 'load-path "~/.emacs.d/local/emacs-haskell-unicode-input-method")
(require 'haskell-unicode-input-method)
(add-hook 'haskell-mode-hook 
  (lambda () (set-input-method "haskell-unicode")))

(use-package obsidian
  :ensure t
  :custom
  ;; Your Obsidian vault root
  (obsidian-directory "~/General")        ;; vault = ~/General 
   ;; Inbox folder inside the vault
  (obsidian-inbox-directory "Notes")      ;; inbox = ~/General/Notes
  (markdown-enable-wiki-links t)
  (obsidian-create-unfound-files-in-inbox t)
  (obsidian-use-update-timer`nil)
  (obsidian-use-pcache t)
  :config
  (global-obsidian-mode t)
  (obsidian-backlinks-mode t)
  (markdown-enable-wiki-links t)
  :bind
  (:map obsidian-mode-map
        ("C-c C-n" . obsidian-capture)
        ("C-c C-l" . obsidian-insert-wikilink)
        ("C-c C-o" . obsidian-follow-link-at-point)
        ("C-c C-j" . obsidian-jump)
        ("C-c C-b" . obsidian-backlink-jump)))

(defun my-obsidian-move-current-file ()
(interactive)
(let* ((vault obsidian-directory)
       (name  (file-name-nondirectory (buffer-file-name)))
       (new   (expand-file-name name vault)))
  (write-file new)
  (obsidian-update)))

(message "Orderless")
(use-package orderless
  :ensure t
  :custom
  (setq completion--styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles basic partial-completion))))
  (completion-pcm-leading-wildcard t))
(setq completion-styles '(orderless basic))

(message "emacs reader")
;(setq package-vc-allow-build-commands t)
;(add-to-list 'load-path "~/.emacs.d/local/emacs-reader")
;(require 'reader)

(message "nov.el")
;  (use-package nov
;    :ensure t
;    :mode '("\\.epub\\'" . nov-mode))
(message "nov.el")

(use-package nov
  :ensure t
  :mode ("\\.epub\\'" . nov-mode))

(message "python mode")
(use-package python
:mode ("\\.py\\'" . python-mode)
:interpreter ("python" . python-mode)
:custom
;; Always use python3 REPL
(python-shell-interpreter "ipython")
(python-shell-interpreter-args "-i --simple-prompt")
;; Disable native shell completion; let LSP/Corfu handle it
(python-shell-completion-native-enable nil)
(python-shell-completion-native-disabled-interpreters '("python" "python3" "ipython"))
:hook
;; LSP on Python files
(python-mode . eglot-ensure)
;; Example: enable indentation, etc. here if you want
)


