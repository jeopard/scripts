(require 'package)
(add-to-list 'package-archives
  '("melpa" . "http://melpa.milkbox.net/packages/") t)

(package-initialize)

;; making Emacs' exec-path match $PATH
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

(desktop-save-mode 1)

;; (require 'helm-config)
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
(helm-mode 1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(csv-separators (quote ("," "	" "|")))
 '(custom-enabled-themes (quote (misterioso)))
 '(custom-safe-themes
   (quote
    ("a41b81af6336bd822137d4341f7e16495a49b06c180d6a6417bf9fd1001b6d2b" default)))
 '(package-selected-packages
   (quote
    (terraform-mode slim-mode dracula-theme elpy haskell-mode intero find-file-in-project rubocop csv-mode json-mode company flycheck tide ac-js2 rjsx-mode js2-mode markdown-mode ensime yaml-mode helm-ls-git autopair auto-complete))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#2d3743" :foreground "#e1e1e0" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 150 :width normal :foundry "nil" :family "Menlo")))))

;; Original idea from
;; http://www.opensubscriber.com/message/emacs-devel@gnu.org/10971693.html
(defun comment-dwim-line (&optional arg)
  "Replacement for the comment-dwim command.
        If no region is selected and current line is not blank and we are not at the end of the line,
        then comment current line.
        Replaces default behaviour of comment-dwim, when it inserts comment at the end of the line."
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))

(global-set-key "\M-;" 'comment-dwim-line)

(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))


(add-hook 'js-mode-hook 'js2-minor-mode)
(add-hook 'js2-mode-hook 'ac-js2-mode)

(setq-default js2-basic-offset 2)

;;; yasnippet
;;; should be loaded before auto complete so that they can work together
(require 'yasnippet)
(yas-global-mode 1)
;;; auto complete mod
;;; should be loaded after yasnippet so that they can work together
(require 'auto-complete)
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)
;;; set the trigger key so that it can work together with yasnippet on tab key,
;;; if the word exists in yasnippet, pressing tab will cause yasnippet to
;;; activate, otherwise, auto-complete will
(ac-set-trigger-key "TAB")
(ac-set-trigger-key "<tab>")

;; (add-to-list 'load-path "~/.emacs.d/") ;; comment if autopair.el is in standard load path 
(require 'autopair)
(autopair-global-mode) ;; enable autopair in all buffers


(require 'js2-refactor)
(js2r-add-keybindings-with-prefix "C-c r")

(show-paren-mode 1)


(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-hook 'yaml-mode-hook
	  '(lambda ()
	     (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

;; for not adding coding: utf-8 comments
(setq ruby-insert-encoding-magic-comment nil)

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(setq web-mode-markup-indent-offset 2)
(setq web-mode-code-indent-offset 2)
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)

(require 'midnight)

(require 'helm-ls-git)
(global-set-key (kbd "C-x C-d") 'helm-browse-project)

(add-hook 'ruby-mode-hook #'rubocop-mode)

;; yank and auto-indent
(dolist (command '(yank yank-pop))
  (eval `(defadvice ,command (after indent-region activate)
           (and (not current-prefix-arg)
                (member major-mode '(emacs-lisp-mode lisp-mode
                                                     clojure-mode    scheme-mode
                                                     haskell-mode    ruby-mode
                                                     rspec-mode      python-mode
                                                     c-mode          c++-mode
                                                     objc-mode       latex-mode
                                                     plain-tex-mode))
                (let ((mark-even-if-inactive transient-mark-mode))
                  (indent-region (region-beginning) (region-end) nil))))))

(setq js-indent-level 2)

(setq-default word-wrap t)

(menu-bar-mode -1)
(tool-bar-mode -1)

(set-face-attribute 'default nil :family "Inconsolata" :height 140)

(server-start)

;; use web-mode for .jsx files
(add-to-list 'auto-mode-alist '("\\.jsx$" . rjsx-mode))

;; http://www.flycheck.org/manual/latest/index.html
(require 'flycheck)

;; turn on flychecking globally
(add-hook 'after-init-hook #'global-flycheck-mode)

;; disable jshint since we prefer eslint checking
(setq-default flycheck-disabled-checkers
              (append flycheck-disabled-checkers
                      '(javascript-jshint)))

;; use eslint with web-mode for jsx files
(flycheck-add-mode 'javascript-eslint 'rjsx-mode)

;; customize flycheck temp file prefix
(setq-default flycheck-temp-prefix ".flycheck")

;; disable json-jsonlist checking for json files
(setq-default flycheck-disabled-checkers
              (append flycheck-disabled-checkers
                      '(json-jsonlist)))

;; ;; https://github.com/purcell/exec-path-from-shell
;; ;; only need exec-path-from-shell on OSX
;; ;; this hopefully sets up path and other vars better
;; (when (memq window-system '(mac ns))
;;   (exec-path-from-shell-initialize))

(require 'use-package)

(use-package elpy
             :ensure t
             :init
             (elpy-enable))

(global-set-key [C-prior] (lambda () (interactive) (scroll-down 1)))
(global-set-key [C-next] (lambda () (interactive) (scroll-up 1)))

(setq-default typescript-indent-level 2)
