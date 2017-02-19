;; set up global path variable
(if (not (getenv "TERM_PROGRAM"))
    (let ((path (shell-command-to-string
		 "$SHELL -cl \"printf %s \\\"\\\$PATH\\\"\"")))
      (setenv "PATH" path)))

;; enable C-x C-j to go to the parent directory of a file
(require 'dired-x)
(setq-default dired-omit-files-p t) ; Buffer-local variable
(setq dired-omit-files (concat dired-omit-files "\\|^\\..+$"))

;; open file by [Enter] or Up in the same directory
(require 'dired )
(define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file) ; was dired-advertised-find-file
(define-key dired-mode-map (kbd "^") (lambda () (interactive) (find-alternate-file "..")))  ; was dired-up-directory

;; hide welcome screen and message
(setq inhibit-startup-screen t)

;; save desktop on exit
(desktop-save-mode 1)

;; enable save history
(savehist-mode 1)
(setq savehist-additional-variables '(kill-ring search-ring regexp-search-ring))

(add-to-list 'load-path "./emacs.d/")
(show-paren-mode 1)
(load-theme 'tango-dark)


;; Emacs is not a package manager, and here we load its package manager!
(require 'package)
(dolist (source '(("marmalade" . "http://marmalade-repo.org/packages/")
                  ("elpa" . "http://tromey.com/elpa/")
                  ;; TODO: Maybe, use this after emacs24 is released
                  ;; (development versions of packages)
                  ("melpa" . "http://melpa.milkbox.net/packages/")
		  ;; ("org" . "http://orgmode.org/elpa/")
		  ("melpa-stable" . "http://stable.melpa.org/packages/")
                  ))
  (add-to-list 'package-archives source t))
(package-initialize)

;; Make Emacs use the $PATH set up by the user's shell
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; turning on ido-mode by default
(require 'ido)
(ido-mode t)

;; turning on ibuffer by default
(global-set-key (kbd "C-x C-b") 'ibuffer)
(autoload 'ibuffer "ibuffer" "List buffers." t)

;; run shell by [F1] key
(global-set-key [f1] 'shell)

;; disable toolbar
(tool-bar-mode -1)

;; dispaly buffer name in reverse order
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; enables compilation-shell-minor-mode
(add-hook 'shell-mode-hook 'compilation-shell-minor-mode)

;; allways show column number
(setq column-number-mode t)

;; disable the display of scroll bars
(scroll-bar-mode -1)

;; getting rid of the "yes or no" prompt and replace it with "y or n":
(fset 'yes-or-no-p 'y-or-n-p)

;; don't ask you if you want to kill a buffer with a live process attached to it
(setq kill-buffer-query-functions
  (remq 'process-kill-buffer-query-function
	kill-buffer-query-functions))

;; A persistent command history in Emacs
;; (defun comint-write-history-on-exit (process event)
;;   (comint-write-input-ring)
;;   (let ((buf (process-buffer process)))
;;     (when (buffer-live-p buf)
;;       (with-current-buffer buf
;;         (insert (format "\nProcess %s %s" process event))))))

;; (defun turn-on-comint-history ()
;;   (let ((process (get-buffer-process (current-buffer))))
;;     (when process
;;       (setq comint-input-ring-file-name
;;             (format "~/.emacs.d/inferior-%s-history"
;;                     (process-name process)))
;;       (comint-read-input-ring)
;;       (set-process-sentinel process
;;                             #'comint-write-history-on-exit))))

;; (add-hook 'inferior-haskell-mode-hook 'turn-on-comint-history)
;; (add-hook 'kill-buffer-hook 'comint-write-input-ring)

;; (defun mapc-buffers (fn)
;;   (mapc (lambda (buffer)
;;           (with-current-buffer buffer
;;             (funcall fn)))
;;         (buffer-list)))

;; (defun comint-write-input-ring-all-buffers ()
;;   (mapc-buffers 'comint-write-input-ring))

;; (add-hook 'kill-emacs-hook 'comint-write-input-ring-all-buffers)


;; ---------------- Haskell related settings ----------------------------

; Enable Windows-like bindings
(cua-mode 1)

(let ((my-node-path (expand-file-name "/usr/local/lib")))
  (setenv "PATH" (concat my-node-path ":" (getenv "PATH")))
  (add-to-list 'exec-path my-node-path))

; Make Emacs look in Cabal directory for binaries
(let ((my-cabal-path (expand-file-name "~/.cabal/bin")))
  (setenv "PATH" (concat my-cabal-path ":" (getenv "PATH")))
  (add-to-list 'exec-path my-cabal-path))

; HASKELL-MODE
; ------------

; Choose indentation mode
;; Use haskell-mode indentation
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;; Use hi2
;(require 'hi2)
;(add-hook 'haskell-mode-hook 'turn-on-hi2)
;; Use structured-haskell-mode
;(add-hook 'haskell-mode-hook 'structured-haskell-mode)

; Add F8 key combination for going to imports block
(eval-after-load 'haskell-mode
  '(define-key haskell-mode-map [f8] 'haskell-navigate-imports))

(custom-set-variables
 ; Set up hasktags (part 2)
 '(haskell-tags-on-save t)
 ; Set up interactive mode (part 2)
 '(haskell-process-auto-import-loaded-modules t)
 '(haskell-process-log t)
 '(haskell-process-suggest-remove-import-lines t)
 ; Set interpreter to be "cabal repl"
 '(haskell-process-type 'cabal-repl))

; Add key combinations for interactive haskell-mode
(eval-after-load 'haskell-mode '(progn
  (define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-or-reload)
  (define-key haskell-mode-map (kbd "C-`") 'haskell-interactive-bring)
  (define-key haskell-mode-map (kbd "C-c C-z") 'haskell-interactive-switch)
  (define-key haskell-mode-map (kbd "C-c C-n C-t") 'haskell-process-do-type)
  (define-key haskell-mode-map (kbd "C-c C-n C-i") 'haskell-process-do-info)
  (define-key haskell-mode-map (kbd "C-c C-n C-c") 'haskell-process-cabal-build)
  (define-key haskell-mode-map (kbd "C-c C-n c") 'haskell-process-cabal)))
(eval-after-load 'haskell-cabal '(progn
  (define-key haskell-cabal-mode-map (kbd "C-c C-z") 'haskell-interactive-switch)
  (define-key haskell-cabal-mode-map (kbd "C-c C-k") 'haskell-interactive-mode-clear)
  (define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
  (define-key haskell-cabal-mode-map (kbd "C-c c") 'haskell-process-cabal)))

(eval-after-load 'haskell-mode
  '(define-key haskell-mode-map (kbd "C-c C-o") 'haskell-compile))
(eval-after-load 'haskell-cabal
  '(define-key haskell-cabal-mode-map (kbd "C-c C-o") 'haskell-compile))
  
; GHC-MOD
; -------

(autoload 'ghc-init "ghc" nil t)
(autoload 'ghc-debug "ghc" nil t)
(add-hook 'haskell-mode-hook (lambda () (ghc-init)))

; COMPANY-GHC
; -----------

; Enable company-mode
(require 'company)
; Use company in Haskell buffers
; (add-hook 'haskell-mode-hook 'company-mode)
; Use company in all buffers
(add-hook 'after-init-hook 'global-company-mode)

(add-to-list 'company-backends 'company-ghc)
(custom-set-variables '(company-ghc-show-info t))


; Customization variable to enable tags generation on save
(custom-set-variables '(haskell-tags-on-save t))

; Jump to tags
; GHCi first and then if that fails to fallback to tags for jumping
(define-key haskell-mode-map (kbd "M-.") 'haskell-mode-jump-to-def-or-tag)


;; ============== Spell checking =================================
;; http://blog.binchen.org/posts/what-s-the-best-spell-check-set-up-in-emacs.html

;; find aspell and hunspell automatically
(cond
 ((executable-find "aspell")
  (setq ispell-program-name "aspell")
  (setq ispell-extra-args '("--sug-mode=ultra" "--lang=en_US")))
 ((executable-find "hunspell")
  (setq ispell-program-name "hunspell")
  (setq ispell-extra-args '("-d en_US")))
 )



;; A persistent command history in Emacs
;; https://oleksandrmanzyuk.wordpress.com/2011/10/23/a-persistent-command-history-in-emacs/

(defun comint-write-history-on-exit (process event)
  (comint-write-input-ring)
  (let ((buf (process-buffer process)))
    (when (buffer-live-p buf)
      (with-current-buffer buf
        (insert (format "\nProcess %s %s" process event))))))


(defun turn-on-comint-history ()
  (let ((process (get-buffer-process (current-buffer))))
    (when process
      (setq comint-input-ring-file-name
            (format "~/.emacs.d/inferior-%s-history"
                    (process-name process)))
      (comint-read-input-ring)
      (set-process-sentinel process
                            #'comint-write-history-on-exit))))

(add-hook 'inferior-haskell-mode-hook 'turn-on-comint-history)

(defun mapc-buffers (fn)
  (mapc (lambda (buffer)
          (with-current-buffer buffer
            (funcall fn)))
        (buffer-list)))

(defun comint-write-input-ring-all-buffers ()
  (mapc-buffers 'comint-write-input-ring))

(add-hook 'kill-emacs-hook 'comint-write-input-ring-all-buffers)

;;;; Configure w3m

;; Import w3m-haddock
(require 'w3m-haddock)

(setq w3m-mode-map (make-sparse-keymap))

(define-key w3m-mode-map (kbd "RET") 'w3m-view-this-url)
(define-key w3m-mode-map (kbd "q") 'bury-buffer)
(define-key w3m-mode-map (kbd "<mouse-1>") 'w3m-maybe-url)
(define-key w3m-mode-map [f5] 'w3m-reload-this-page)
(define-key w3m-mode-map (kbd "C-c C-d") 'haskell-w3m-open-haddock)
(define-key w3m-mode-map (kbd "M-<left>") 'w3m-view-previous-page)
(define-key w3m-mode-map (kbd "M-<right>") 'w3m-view-next-page)
(define-key w3m-mode-map (kbd "M-.") 'w3m-haddock-find-tag)

(defun w3m-maybe-url ()
  (interactive)
  (if (or (equal '(w3m-anchor) (get-text-property (point) 'face))
          (equal '(w3m-arrived-anchor) (get-text-property (point) 'face)))
      (w3m-view-this-url)))


;; Add a hook for w3m
(add-hook 'w3m-display-hook 'w3m-haddock-display)

(define-key haskell-mode-map (kbd "C-c C-d") 'haskell-w3m-open-haddock)

;; enable spell checking of strings and comments
(add-hook 'haskell-mode-hook 'flyspell-prog-mode)

;; activate haskell-decl-scan-mode automatically for Haskell buffers
(add-hook 'haskell-mode-hook 'haskell-decl-scan-mode)

(eval-after-load "which-func"
  '(add-to-list 'which-func-modes 'haskell-mode))
(put 'erase-buffer 'disabled nil)

(put 'dired-find-alternate-file 'disabled nil)
