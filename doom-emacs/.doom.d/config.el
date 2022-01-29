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
(setq display-line-numbers-type 'relative)

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

(setq doom-font (font-spec :family "iosevka term ss08" :size 18)
      doom-variable-pitch-font ()
      doom-unicode-font ()
      doom-big-font (font-spec :family "iosevka term ss08" :size 22))

(setq default-text-properties '(line-spacing 0.1 line-height 1.1))

;; TypeScript LSP creates log files directly into project dir, this removes that
(setenv "TSSERVER_LOG_FILE" "/tmp/tsserver.log")

;; to rename a TS/JS file, there's code for that https://github.com/emacs-lsp/lsp-mode/commit/1d9da9f24fd477faa2a38b369842a27fe5bda160
;; only thing being to rename, it copies fileA to fileB, and doesn't deletes fileB by itself, which I should code it in
;; also mentioned here https://discord.com/channels/789885435026604033/789890622424219658/931959632937746522

;; don't format with LSP. By default if LSP is avialable, formatter (like prettier) isn't used
;; from https://docs.doomemacs.org/latest/modules/editor/format/
;; needs prettier installed globally, otherwise it will silently fail
(setq +format-with-lsp nil)

(map! :nvo "0" #'evil-first-non-blank)
(map! :nvo "^" #'evil-beginning-of-line)
(map! :nvo "g0" #'evil-first-non-blank-of-visual-line)
(map! :nvo "g^" #'evil-beginning-of-visual-line)

(map! :nv ";" #'evil-ex)

(map! :leader :nv "v" "\"0p")
(map! :leader :nv "V" "\"0P")

;; I don't even use `s` for snipe, so let's revert it to what vim does
(evil-define-key '(normal motion) evil-snipe-local-mode-map
  "s" nil
  "S" nil)

(map! :leader "j" #'evil-avy-goto-char-2)

(map! :i "M-o" #'evil-open-below)
(map! :i "M-O" #'evil-open-above)

;; don't show a confirmation dialog on closing
(setq confirm-kill-emacs nil)

;; vim like scrolloff
(setq scroll-margin 2)
;; there's more at https://www.reddit.com/r/emacs/comments/4hpjwp/vim_like_scrolling_in_emacs/d2rh8g4/

;; h and l to move up/down the directory
(map! :map dired-mode-map
      :n "h" 'dired-up-directory
      :n "l" 'dired-find-file
      :n "M-l" 'dired-display-file)

(map! :leader :n "e" #'flycheck-explain-error-at-point)

;; start emacs maximized
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; just integrate system clipboard with emacs already https://www.reddit.com/r/emacs/comments/l46om0/utilise_wsl_clipboard_in_doom_emacs/gknmko6/
(setq save-interprogram-paste-before-kill t)

;; Projectile, you do a terrible job of caching file names. I'll manually enable it when I'd need to.
;; If you want to enable caching back, see this first: https://emacs.stackexchange.com/questions/2164/projectile-does-not-show-all-files-in-project
;; Use SPC p i (projectile-invalidate-cache) if you're still seeing files that the project currently doesn't has.
(setq projectile-enable-caching nil)
;; also see https://docs.projectile.mx/projectile/configuration.html#project-indexing-method

;; Switch to the new window after splitting. Taken from https://github.com/sagittaros/doom.d/blob/main/%2Beditor.el
(setq evil-split-window-below t
      evil-vsplit-window-right t)

 ;;  josh
 ;;  sam
 ;;  jed         →    "josh", "jed", "sam", "C.J.", "toby"
 ;;  C.J.
 ;;  toby
 ;;
 ;; entering a quote is optional
(defun arrayify (start end quote)
  "Turn strings on newlines into a QUOTEd, comma-separated one-liner."
  (interactive "r\nMQuote: ")
  (let ((insertion
         (mapconcat
          (lambda (x) (format "%s%s%s" quote x quote))
          (split-string (buffer-substring start end)) ", ")))
    (delete-region start end)
    (insert insertion)))

(map! :leader :nv "r" #'evil-replace-with-register)

;; M-<numeral> to insert from completion
(setq company-show-quick-access t)
