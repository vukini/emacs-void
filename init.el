(message "init.el is loading...")

;; We stop annoy bell noises and inhibit all start screens.
;; We ensure that inital scratch message has no text in the buffer, leaving a clean interface. 
;; We also enable `save-place-mode` to:
;; Automatically save place in files, so that visiting them later
;; (even during a different Emacs session) automatically moves point
;; to the saved position, when the file is first found.  Uses the
;; value of buffer-local variable save-place-mode to determine whether to
;; save position or not.
;; We remove menu bars, tool bars, and scroll bars. Re-enable them by commmenting out each line if you need.

(setq ring-bell-function 'ingore)  ;Stop the bell sound
(setq visible-bell t)                ; Show a visible bell instead 
(setq inhibit-startup-screen t)    ; Disables the startup splash screen
(setq inhibit-splash-screen t)     ; Disables the splash screen (older Emacs)
(setq inhibit-startup-message t)   ; Disables the startup message
(setq initial-scratch-message nil) ; Removes the initial scratch message
(save-place-mode 1)
(menu-bar-mode -1)		
(tool-bar-mode -1)
(scroll-bar-mode -1)
(windmove-default-keybindings) ;; usually Shift+arrow keys
(desktop-save-mode 1)
(require 'org)  ;; ensure Org is available
(org-babel-load-file (expand-file-name "config.org" user-emacs-directory)) ;launch config.org

