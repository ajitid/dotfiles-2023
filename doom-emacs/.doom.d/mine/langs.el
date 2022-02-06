;;; $DOOMDIR/mine/langs.el -*- lexical-binding: t; -*-

(add-hook! typescript-tsx-mode 'turn-on-evil-matchit-mode)

;; TypeScript LSP creates log files directly into project dir, this removes that
(setenv "TSSERVER_LOG_FILE" "/tmp/tsserver.log")

;; to rename a TS/JS file, there's code for that https://github.com/emacs-lsp/lsp-mode/commit/1d9da9f24fd477faa2a38b369842a27fe5bda160
;; only thing being to rename, it copies fileA to fileB, and doesn't deletes fileB by itself, which I should code it in
;; also mentioned here https://discord.com/channels/789885435026604033/789890622424219658/931959632937746522

;; don't format with LSP. By default if LSP is avialable, formatter (like prettier) isn't used
;; from https://docs.doomemacs.org/latest/modules/editor/format/
;; needs prettier installed globally, otherwise it will silently fail
(setq +format-with-lsp nil)
(setq lsp-enable-symbol-highlighting nil)
