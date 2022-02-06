;;; $DOOMDIR/mine/org.el -*- lexical-binding: t; -*-

(setq org-directory "~/ghq/github.com/ajitid/notes-org/")

;; for M-x org-timer-set-timer
;; shorthand: 0:3 for sec and 23 for mins
;; more on this comment https://www.youtube.com/watch?v=JbHE819kVGQ&lc=UgyZXlkdtn31Y8elk8V4AaABAg.9QYI1Vgfhg59QYJARNFmZx
(setq org-clock-sound "~/scripts/bell.wav")
(setq org-show-notification-handler 'message)

;; otherwise operations like `dj` would behave differently
(add-hook! 'org-mode-hook
  (visual-line-mode -1))
