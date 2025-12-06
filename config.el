(message "This is from config.org --> config.el")
(message "Your in lenovo VOID")
(message "----------------------------")

(add-to-list 'load-path "~/.emacs.d/local")
(setq ring-bell-function 'ingore)
(setq visible-bell t)
(save-place-mode 1)

(require 'uniquify)

(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
;(global-set-key (kbd "C-\\") 'comment-region)
;(global-set-key (kbd "C-M-\\") 'uncomment-region)
(menu-bar-mode -1)		
(tool-bar-mode -1)
(scroll-bar-mode -1)
(windmove-default-keybindings) ;; usually Shift+arrow keys
(setq inhibit-startup-screen t)    ; Disables the startup splash screen
(setq inhibit-splash-screen t)     ; Disables the splash screen (older Emacs)
(setq inhibit-startup-message t)   ; Disables the startup message
(setq initial-scratch-message nil) ; Removes the initial scratch message
(desktop-save-mode 1)
(setq desktop-path '("~/.emacs.d/local/"))
;;(evil-mode nil)
(save-place-mode t)
(server-start)
(setq package-archives
      '(("gnu"       . "https://elpa.gnu.org/packages/")
        ("nongnu"    . "https://elpa.nongnu.org/nongnu/")
        ("melpa"     . "https://melpa.org/packages/")
        ("elpa-devel". "https://elpa.gnu.org/devel/")
        ("org"       . "https://orgmode.org/elpa/")))

(package-initialize)
(require 'package)
(unless package-archive-contents
  (package-refresh-contents))

(message "2----------------------------")
;(global-set-key (kbd "M-o") 'other-window)
;(global-set-key (kbd "M-O") (lambda () (interactive) (other-window -1)))

(load "rc.el")
(message "Setting Theme")
(rc/require-theme 'gruber-darker)
;;(load-theme 'leuven-dark)
(rc/require 'which-key)
(which-key-mode)			
(rc/require 'projectile)
(rc/require 'vertico)
(vertico-mode 1)
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

(use-package obsidian
  :ensure t
  :custom
  ;; Your Obsidian vault root
  (obsidian-directory "~/General")        ;; vault = ~/General [web:12]
   ;; Inbox folder inside the vault
  (obsidian-inbox-directory "Notes")      ;; inbox = ~/General/Notes [web:12]
  (markdown-enable-wiki-links t)
  (obsidian-create-unfound-files-in-inbox t)
  :config
  (global-obsidian-mode t)
  (obsidian-backlinks-mode t)
  :bind
  (:map obsidian-mode-map
        ("C-c C-n" . obsidian-capture)
        ("C-c C-l" . obsidian-insert-link)
        ("C-c C-o" . obsidian-follow-link-at-point)
        ("C-c C-j" . obsidian-jump)
        ("C-c C-b" . obsidian-backlink-jump)))

(message "4----------------------------")
(use-package corfu
  :ensure t
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-preselect-first t))

(use-package cape
  :ensure t
  :after corfu)

(use-package orderless
  :ensure t
  :custom
  (completion--styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package kind-icon
  :ensure t
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

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

(message "Yasnippet")
  (use-package yasnippet
    :ensure t
    :hook ((prog-mode text-mode conf-mode) . yas-minor-mode)
    :init
    (setq yas-snippet-dirs '("~/.emacs.d/snippets")))
  
  (use-package yasnippet-snippets
    :ensure t
    :after yasnippet)

;; (message ”this is from go lsp”)
;; (use-package go-mode
;;   :ensure t
;;   :mode "\.go\'")

(use-package lsp-mode
  :ensure t
  :hook ((python-mode . lsp)
         (go-mode . lsp)
         (c-mode . lsp)
         (c++-mode . lsp))
  :commands lsp)

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

(use-package lsp-mode
    :ensure t
    :commands (lsp lsp-deferred)
    :hook ((prog-mode . lsp-deferred))
    :config
    (with-eval-after-load 'lsp-mode
      (setq lsp-clients-lua-language-server-bin "/usr/bin/lua-language-server"))
    :init (setq lsp-keymap-prefix "C-c l"))
  
  (use-package lsp-ui :ensure t :commands lsp-ui-mode)
  (use-package lsp-ivy :ensure t :commands lsp-ivy-workspace-symbol)

(use-package exec-path-from-shell
  :ensure t)

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
          gptel-model 'sonar-pro)

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

(add-to-list 'load-path "~/.emacs.d/local/emacs-haskell-unicode-input-method")
(require 'haskell-unicode-input-method)
(add-hook 'haskell-mode-hook 
  (lambda () (set-input-method "haskell-unicode")))
