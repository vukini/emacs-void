(message "init.el is loading...")
(setq ring-bell-function 'ingore)  ;Stop the bell sound
(setq visible-bell) ; Show a visible bell instead 
(setq inhibit-startup-screen t)    ; Disables the startup splash screen
(setq inhibit-splash-screen t)     ; Disables the splash screen (older Emacs)
(setq inhibit-startup-message t)   ; Disables the startup message
(setq initial-scratch-message nil) ; Removes the initial scratch message
(save-place-mode 1)
(menu-bar-mode -1)		
(tool-bar-mode -1)
(scroll-bar-mode -1)

(require 'org)  ;; ensure Org is available
(org-babel-load-file (expand-file-name "config.org" user-emacs-directory))

(getenv "BASH")
