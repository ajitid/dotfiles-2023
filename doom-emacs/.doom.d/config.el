;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-miramare)
;; miramare, monokai-ristretto, flatwhite, challenger-deep

(setq evil-normal-state-cursor '(box "#ccc")
      evil-insert-state-cursor '(bar "#ccc")
      evil-visual-state-cursor '(hollow "#ccc"))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq doom-font (font-spec :family "cartograph cf" :size 17)
      doom-variable-pitch-font ()
      doom-unicode-font ()
      doom-big-font (font-spec :family "cartograph cf" :size 21))

;; from https://github.com/syl20bnr/spacemacs/issues/10502#issuecomment-404453194
;; (setq default-text-properties '(line-spacing 0.1 line-height 1.1))
;; another (better option imo) is https://github.com/tam5/font-patcher

(setq display-line-numbers-type 'relative)

(defun lsp-ts-rename-file ()
  "Rename current file and all it's references in other files."
  (interactive)
  (let* ((name (buffer-name))
         (old (buffer-file-name))
         (basename (file-name-nondirectory old)))
    (unless (and old (file-exists-p old))
      (error "Buffer '%s' is not visiting a file." name))
    (let ((new (read-file-name "New name: " (file-name-directory old) basename nil basename)))
      (when (get-file-buffer new)
        (error "A buffer named '%s' already exists." new))
      (when (file-exists-p new)
        (error "A file named '%s' already exists." new))
      (lsp--send-execute-command
       "_typescript.applyRenameFile"
       (vector (list :sourceUri (lsp--buffer-uri)
                     :targetUri (lsp--path-to-uri new))))
      (mkdir (file-name-directory new) t)
      (rename-file old new)
      (rename-buffer new)
      (set-visited-file-name new)
      (set-buffer-modified-p nil)
      (lsp-disconnect)
      (setq-local lsp-buffer-uri nil)
      (lsp)
      (lsp--info "Renamed '%s' to '%s'." name (file-name-nondirectory new)))))

;; TypeScript LSP creates log files directly into project dir, this removes that
(setenv "TSSERVER_LOG_FILE" "/tmp/tsserver.log")

;; don't format with LSP
;; by default if LSP is avialable, formatter (like prettier) isn't used
;; from https://docs.doomemacs.org/latest/modules/editor/format/
;; needs prettier installed globally, otherwise it will silently fail
(setq +format-with-lsp nil)

(map! :nvo "0" #'evil-first-non-blank)
(map! :nvo "^" #'evil-beginning-of-line)
(map! :nvo "g0" #'evil-first-non-blank-of-visual-line)
(map! :nvo "g^" #'evil-beginning-of-visual-line)

(map! :nv ";" #'evil-ex)

;;;;;;;
;; there is (SPC s i), while non-LSP, it also shows parent symbol (like constructor's class name)
;; thus it is more useful
;; (evil-define-key 'normal 'global (kbd "SPC j") 'consult-lsp-file-symbols)

;; i don't think i would ever use it, also seems like (SPC s s) just does exactly this
;; (evil-define-key 'normal 'global (kbd "SPC l") 'consult-line)

;; didn't automatically detected projects for me
;; also need to add a tmp wksp which isn't ghq as it would be my playground
;; (setq projectile-project-search-path '("~/ghq"))
;;;;;;;

;; don't show a confirmation dialog on closing
(setq confirm-kill-emacs nil)

;; h and l to move up/down the directory
(map! :map dired-mode-map
      :n "h" 'dired-up-directory
      :n "l" 'dired-find-file)

;; start emacs maximized
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; just integrate system clipboard with emacs already https://www.reddit.com/r/emacs/comments/l46om0/utilise_wsl_clipboard_in_doom_emacs/gknmko6/
(setq save-interprogram-paste-before-kill t)

;; Don't cache file list projectile, because with it you show file names that
;; actually belong to other commits.
;;
;; Ajit, you can use SPC p i (projectile-invalidate-cache) if you're still seeing files that that project currently doesn't has
(setq projectile-enable-caching nil)
;; if you want to enable caching back, see https://emacs.stackexchange.com/questions/2164/projectile-does-not-show-all-files-in-project

;; Switch to the new window after splitting
;; taken from https://github.com/sagittaros/doom.d/blob/main/%2Beditor.el
(setq evil-split-window-below t
      evil-vsplit-window-right t)

;; TODO SPC r is available to use
;; use https://github.com/gbprod/substitute.nvim
;; or https://github.com/svermeulen/vim-subversive (preferable)

;; a partial solution for above https://emacs.stackexchange.com/questions/66647/create-a-function-that-deletes-word-on-point-and-replace-with-the-yank-register
(defun replace-word-at-point ()
  (interactive)
  (let ((bounds (bounds-of-thing-at-point 'word)))
    (if bounds
      (progn (delete-and-extract-region (car-safe bounds) (cdr-safe bounds))
             (yank))
      (message "No word at point"))))

(defun replace-evil-word-at-point ()
  "Select the word at point, remove it, and yank the most recent killed text. "
  (interactive)
  (let ((bounds (evil-inner-word)))
    (if bounds
      (progn (delete-and-extract-region (pop bounds) (pop bounds))
             (yank))
      (message "No word at point"))))

;; TODO not sure if paste mode is needed but what i certainly need is a way to paste on the same line,
;; meaning strip new line at the end if there's any
