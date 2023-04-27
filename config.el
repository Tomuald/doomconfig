;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Thomas Garriss"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-zenburn)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
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
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;;;; Here BEGINS my configuration!

(setq! company-global-modes '(not esh-mode org-mode))
(after! org
  ;;(setq org-src-window-setup 'split-window-sensibly)
  (set-popup-rule! "^\\*Org Src" :ignore t)
  (setq! fill-column 70)
  (if (require 'toc-org nil t)
    (progn
      (add-hook 'org-mode-hook 'toc-org-mode)
      ;; enable in markdown, too
      (add-hook 'markdown-mode-hook 'toc-org-mode))))

;;;; Keybindings
(map! "C-x e" 'eshell)
(map! "M-g M-b" 'org-mark-ring-goto)
(map! "C-c C-v C-g" 'org-babel-goto-named-src-block)
(map! :mode (org-mode c++-mode c-mode python-mode) "C-c C-c" #'comment-line)
(map! "C-c C-d" 'treemacs)

;; function to toggle visibility for code blocks
(defvar org-blocks-hidden t)
(defun org-toggle-blocks ()
  (interactive)
  (if org-blocks-hidden
      (org-fold-show-all)
    (org-hide-all))
  (setq-local org-blocks-hidden (not org-blocks-hidden)))
(add-hook! 'org-mode-hook 'org-toggle-blocks)
(map! :mode org-mode "C-c C-b" 'org-toggle-blocks)

(set-face-attribute 'default nil :font "Monaco" :height 135)

(custom-set-faces
  '(org-level-1 ((t (:inherit outline-1 :height 1.25))))
  '(org-level-2 ((t (:inherit outline-2 :height 1.20))))
  '(org-level-3 ((t (:inherit outline-3 :height 1.15))))
  '(org-level-4 ((t (:inherit outline-4 :height 1.10))))
  '(org-level-5 ((t (:inherit outline-5 :height 1.05))))
)

(setq! projectile-project-search-path '("~/Projects/"))
(projectile-discover-projects-in-search-path)

(setq! org-agenda-custom-commands
       '(("h" "Daily Agenda"
          ((agenda "" ((org-agenda-span 1)))
           (todo)))
         ("o" "other agenda"
          ((agenda "")
           (tags-todo "work")
           (tags "office")))))

;; (add-hook! 'org-mode-hook 'docker-compose-mode)

(defun fix-c-indent-offset-according-to-syntax-context (key val)
  ;; remove the old element
  (setq c-offsets-alist (delq (assoc key c-offsets-alist) c-offsets-alist))
  ;; new value
  (add-to-list 'c-offsets-alist (cons key val)))

(add-hook! 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
              ;; indent
              (fix-c-indent-offset-according-to-syntax-context 'substatement-open 0))
            ))

(map! "C-S-c C-S-c" 'mc/edit-lines)
