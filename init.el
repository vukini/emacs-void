;;; init.el --- personal Emacs init  -*- lexical-binding: t; -*-

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

(setq ring-bell-function 'ignore)  ;Stop the bell sound
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
(message "Requiring Org")
(require 'org)  ;; ensure Org is available
(message "Tangling....")
(org-babel-load-file (expand-file-name "config.org" user-emacs-directory)) ;launch config.org

(put 'set-goal-column 'disabled nil)

;; New frames (emacs, and emacsclient -c from Super+x) come back as the last
;; frame closed (Super+q) left them: its windows, buffers and places. With
;; nothing to come back to, *scratch* in ~. Esploro's frames are left out.
;; desktop-save-mode keeps the layout across Emacs restarts too.
(defvar my/last-frame-state nil
  "Window layout of the last frame closed, for the next new frame.")
(add-to-list 'desktop-globals-to-save 'my/last-frame-state)

(defun my/remember-frame (frame)
  (when (and (display-graphic-p frame)
             (not (frame-parameter frame 'esploro))
             (not (frame-parameter frame 'parent-frame)))
    (setq my/last-frame-state
          (cons (window-state-get (frame-root-window frame) t)
                (seq-position (window-list frame 'nomini (frame-first-window frame))
                              (frame-selected-window frame))))))
(add-hook 'delete-frame-functions #'my/remember-frame)

(defun my/home-scratch ()
  (with-current-buffer (get-scratch-buffer-create)
    (setq default-directory "~/")
    (current-buffer)))

(defun my/last-frame-or-scratch ()
  (if (and (consp my/last-frame-state)
           (ignore-errors
             (window-state-put (car my/last-frame-state) (frame-root-window) 'safe)
             t))
      (let ((window (nth (or (cdr my/last-frame-state) 0)
                         (window-list nil 'nomini (frame-first-window)))))
        (when (window-live-p window) (select-window window))
        (window-buffer (selected-window)))
    (my/home-scratch)))
(setq initial-buffer-choice #'my/last-frame-or-scratch)
