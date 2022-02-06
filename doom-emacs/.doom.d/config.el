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
(setq doom-font (font-spec :family "iosevka term ss08" :size 18)
      doom-variable-pitch-font ()
      doom-unicode-font (font-spec :family "noto sans devanagri")
      doom-big-font (font-spec :family "iosevka term ss08" :size 22))

(setq default-text-properties '(line-spacing 0.1 line-height 1.1))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-miramare)
;; Other themes I like: miramare, monokai-ristretto, flatwhite, challenger-deep

(setq evil-normal-state-cursor '(box "#ccc")
      evil-insert-state-cursor '(bar "#ccc")
      evil-visual-state-cursor '(hollow "#ccc"))

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

(load! "mine/enhance.el")
(load! "mine/org.el")
(load! "mine/langs.el")

 ;;  josh
 ;;  sam
 ;;  jed         →    "josh", "jed", "sam", "C.J.", "toby"
 ;;  C.J.
 ;;  toby
 ;;
 ;; Entering a quote is optional
(defun arrayify (start end quote)
  "Turn strings on newlines into a QUOTEd, comma-separated one-liner."
  (interactive "r\nMQuote: ")
  (let ((insertion
         (mapconcat
          (lambda (x) (format "%s%s%s" quote x quote))
          (split-string (buffer-substring start end)) ", ")))
    (delete-region start end)
    (insert insertion)))


;; from https://tecosaur.github.io/emacs-config/config.html
;; or https://github.com/tecosaur/emacs-config
(setq undo-limit 80000000                         ; Raise undo-limit to 80M, for reason see https://www.dr-qubit.org/Lost_undo-tree_history.html
      truncate-string-ellipsis "…"
      scroll-preserve-screen-position nil         ; Don't have point jump around. There's ~'always~ too (use mouse scroll to see the difference).
)
