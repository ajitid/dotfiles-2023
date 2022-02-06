;;; $DOOMDIR/mine/enhance.el -*- lexical-binding: t; -*-

(setq display-line-numbers-type 'relative)

;; don't show a confirmation dialog on closing
(setq confirm-kill-emacs nil)

;; start emacs maximized
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; just integrate system clipboard with emacs already https://www.reddit.com/r/emacs/comments/l46om0/utilise_wsl_clipboard_in_doom_emacs/gknmko6/
;; i don't think it is actually needed
;; (setq save-interprogram-paste-before-kill t)

(map! :nvo "0" #'evil-first-non-blank
      :nvo "^" #'evil-beginning-of-line
      :nvo "g0" #'evil-first-non-blank-of-visual-line
      :nvo "g^" #'evil-beginning-of-visual-line)

(map! :nv ";" #'evil-ex)

(map! :leader :nv "v" "\"0p")
(map! :leader :nv "V" "\"0P")

;; I don't even use `s` for snipe, so let's revert it to what vim does
(evil-define-key '(normal motion) evil-snipe-local-mode-map
  "s" nil
  "S" nil)

(map! :ni "M-o" #'evil-open-below)
(map! :ni "M-O" #'evil-open-above)

;; Switch to the new window after splitting. Taken from https://github.com/sagittaros/doom.d/blob/main/%2Beditor.el
(setq evil-split-window-below t
      evil-vsplit-window-right t)

;; vim like scrolloff. More at https://www.reddit.com/r/emacs/comments/4hpjwp/vim_like_scrolling_in_emacs/d2rh8g4/
(setq scroll-margin 2)

(map! :map dired-mode-map
      :n "h" 'dired-up-directory
      :n "l" 'dired-find-file
      :n "M-l" 'dired-display-file
      :n "C-k" 'dired-do-kill-lines)

;; by default it is bound to epa, https://www.gnu.org/software/emacs/manual/html_mono/epa.html
;; but i don't use it
(after! dired (map! :map dired-mode-map :nv ";" 'evil-ex))

;; if two dired for dir d1 and d2 are open,
;; upon copy file from d1, dired would by default suggest to put it into d2
(setq dired-dwim-target t)

(map! :leader :nv "r" #'evil-replace-with-register)

(map! :leader :n "e" #'flycheck-explain-error-at-point
      :leader :n "E" #'flycheck-buffer)
(map! :m "[e" #'flycheck-previous-error
      :m "]e" #'flycheck-next-error)

;; taken from https://gist.github.com/Blaisorblade/c7349438b06e7b1e034db775408ac4cb
;; // BEG flycheck
(defun flycheck-next-error-loop-advice (orig-fun &optional n reset)
  (condition-case err
      (apply orig-fun (list n reset))
    ((user-error)
     (let ((error-count (length flycheck-current-errors)))
       (if (and
            (> error-count 0)
            (equal (error-message-string err) "No more Flycheck errors"))
           (let* ((req-n (if (numberp n) n 1))
                  (curr-pos (if (> req-n 0) (- error-count 1) 0))
                  (next-pos (mod (+ curr-pos req-n) error-count)))
             (apply orig-fun (list (+ 1 next-pos) 'reset)))
         (signal (car err) (cdr err)))))))

(advice-add 'flycheck-next-error :around #'flycheck-next-error-loop-advice)
;; // END flycheck

;; see https://discord.com/channels/406534637242810369/406554085794381833/937168709326340146
;; a vimmy bind would be `g/`, but I would prefer ergonomics here
(map! :nv "gh" (kbd! "g s SPC"))
;; putting space between gh `g h` works too

;; Taken from https://stackoverflow.com/a/65685019
;; Equivalent to `:noa w`
;; After running this command, if the buffer is in saved state
;; but you want to run the formatter, use `:w!`
(defun save-buffer-as-is ()
  "Save file \"as is\", that is in read-only-mode."
  (interactive)
  (if buffer-read-only
      (save-buffer)
    (read-only-mode 1)
    (save-buffer)
    (read-only-mode 0)))

(evil-ex-define-cmd "noa w" #'save-buffer-as-is)

;; from https://github.com/hlissner/doom-emacs/issues/581#issuecomment-645448095
(defun doom/ediff-init-and-example ()
  "ediff the current `init.el' with the example in doom-emacs-dir"
  (interactive)
  (ediff-files (concat doom-private-dir "init.el")
               (concat doom-emacs-dir "init.example.el")))

(define-key! help-map
  "di"   #'doom/ediff-init-and-example
  )

;; TODO remove this tmp fix
;; from https://www.reddit.com/r/DoomEmacs/comments/shp6ez/comment/hv5lmat/?utm_source=share&utm_medium=web2x&context=3
;; best to be viewed using new reddit
(add-hook! 'doom-init-ui-hook
           :append ;; ensure it gets added to the end.
           #'(lambda () (require 'uniquify) (setq uniquify-buffer-name-style 'forward)))
;; https://www.r-bloggers.com/2009/10/making-emacs-buffer-names-unique-using-the-uniquify-package/

;; from http://pragmaticemacs.com/emacs/uniquify-your-buffer-names/
(setq uniquify-ignore-buffers-re "^\\*") ;; don't muck with with special buffers

;; // BEG search preview
;; taken from https://github.com/minad/consult/wiki#toggle-preview-during-active-completion-session
;; only useful for lists with automatic preview enabled, behaves oddly with manually invoked previews (using `C-space`)
(defvar-local consult-toggle-preview-orig nil)

(defun consult-toggle-preview ()
  "Command to enable/disable preview."
  (interactive)
  (if consult-toggle-preview-orig
      (setq consult--preview-function consult-toggle-preview-orig
            consult-toggle-preview-orig nil)
    (setq consult-toggle-preview-orig consult--preview-function
          consult--preview-function #'ignore)))

(after! vertico
  (define-key vertico-map (kbd "M-P") #'consult-toggle-preview))
;; // END search preview

(map! :ni "M-u" #'universal-argument)

;; M-<numeral> to insert from completion
(setq company-show-quick-access t)

;; Projectile, you do a terrible job of caching file names. I'll manually enable it when I'd need to.
;; If you want to enable caching back, see this first: https://emacs.stackexchange.com/questions/2164/projectile-does-not-show-all-files-in-project
;; Use SPC p i (projectile-invalidate-cache) if you're still seeing files that the project currently doesn't has.
(setq projectile-enable-caching nil)
;; Also see https://docs.projectile.mx/projectile/configuration.html#project-indexing-method
