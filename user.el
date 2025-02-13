(paradox-require 'go-mode)
(paradox-require 'helm-go-package)
(paradox-require 'swiper-helm)
(paradox-require 'yasnippet)
(paradox-require 'go-eldoc)
(paradox-require 'sr-speedbar)
(paradox-require 'bm)
(paradox-require 'racket-mode)
(paradox-require 'graphviz-dot-mode)
(paradox-require 'plantuml-mode)
(paradox-require 'make-mode)
(paradox-require 'ox-reveal)
(paradox-require 'cheatsheet)
(paradox-require 'paredit)
(paradox-require 'projectile)
(paradox-require 'clojure-mode)
(paradox-require 'lsp-mode)
(paradox-require 'lsp-ui)
(paradox-require 'clj-refactor)
(paradox-require 'exec-path-from-shell)
(paradox-require 'company)

(use-package elpy
	:ensure t
	:pin melpa-stable)

(use-package cider
	:ensure t
	:pin melpa-stable)
(use-package hcl-mode
    :ensure t
    :pin melpa-stable)

;; Clojure

(use-package lsp-mode
  :ensure t
  :hook ((clojure-mode . lsp)
         (clojurec-mode . lsp)
         (clojurescript-mode . lsp))
  :config
  ;; add paths to your local installation of project mgmt tools, like lein
  (setenv "PATH" (concat
                  "/usr/local/bin" path-separator
                  (getenv "PATH")))
  (dolist (m '(clojure-mode
               clojurec-mode
               clojurescript-mode
               clojurex-mode))
    (add-to-list 'lsp-language-id-configuration `(,m . "clojure")))
  (setq lsp-enable-file-watchers nil)
  (setq company-idle-delay 0)
  (setq lsp-prefer-capf t)
  (setq lsp-enable-suggest-server-download nil)
  (setq gc-cons-threshold (* 100 1024 1024)
        read-process-output-max (* 1024 1024)
        company-minimum-prefix-length 1
      ; lsp-enable-indentation nil ; uncomment to use cider indentation instead of lsp
      ; lsp-enable-completion-at-point nil ; uncomment to use cider completion instead of lsp
      ))


(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

(defun clojure-hook ()
  ; paredit
  (local-set-key "\M-\"" 'paredit-meta-doublequote)
  (local-set-key "\C-[]" 'paredit-forward-slurp-sexp)
  ;;(local-set-key "\C-[[" 'paredit-backward-slurp-sexp)
  (local-set-key "\C-[}" 'paredit-forward-barf-sexp)
  (local-set-key "\C-[{" 'paredit-backward-barf-sexp))

(add-hook 'clojure-mode-hook 'clojure-hook)

;; projectile
(projectile-global-mode)
(setq projectile-completion-system 'helm)

; drag stuff
(use-package drag-stuff
    :ensure t)
(drag-stuff-global-mode 1)
(global-set-key "\C-c\C-d\C-p" 'drag-stuff-up)
(global-set-key "\C-c\C-d\C-n" 'drag-stuff-down)

(display-time-mode)
(set-face-attribute 'default nil :height 100)

'(paradox-require 'unicode-fonts)
'(unicode-fonts-setup)

; PlantUML
(add-to-list
    'org-src-lang-modes '("plantuml" . plantuml))

; Powerline
(paradox-require 'powerline)
(paradox-require 'airline-themes)
(load-theme 'airline-papercolor)

(setq powerline-utf-8-separator-left        #xe0b0
      powerline-utf-8-separator-right       #xe0b2
      airline-utf-glyph-separator-left      #xe0b0
      airline-utf-glyph-separator-right     #xe0b2
      airline-utf-glyph-subseparator-left   #xe0b1
      airline-utf-glyph-subseparator-right  #xe0b3
      airline-utf-glyph-branch              #xe0a0
      airline-utf-glyph-readonly            #xe0a2
      airline-utf-glyph-linenumber          #xe0a1)

; bm bookmarks
(setq bm-restore-repository-on-load t)
(setq bm-cycle-all-buffers t)

; Clojure(script)
(setq cider-default-repl-command "lein")

; yasnippets
(setq yas-snippet-dirs '("~/.emacs.d/snippets"))
(yas-global-mode 1)

; Terraform
(paradox-require 'terraform-mode)
(custom-set-variables
   '(terraform-indent-level 4))

; Protobuf
(paradox-require 'protobuf-mode)

; Expand region
(paradox-require 'expand-region)
(require 'expand-region)

; Org mode
(paradox-require 'org)
(require 'org)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

; Org-babel
(paradox-require 'ob-http)
(require 'ob-http)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (http . t)))

; sr-speedbar
(setq speedbar-show-unknown-files t) ; show all files
(setq speedbar-use-images nil) ; use text for buttons
(setq sr-speedbar-right-side nil) ; put on left side

; ElPy
(elpy-enable)

; Cider

(setq cider-cljs-lein-repl
	"(do (require 'figwheel-sidecar.repl-api)
         (figwheel-sidecar.repl-api/start-figwheel!)
         (figwheel-sidecar.repl-api/cljs-repl))")

; Go stuff
(setq gofmt-command "goimports")
(defun my-go-mode-hook ()
  ; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet"))
  ; Go oracle
  ; (load-file "$GOPATH/src/golang.org/x/tools/cmd/oracle/oracle.el")
  ; Godef jump key binding
  (speedbar-add-supported-extension ".go")
  (setq imenu-generic-expression
    '(("type" "^type *\\([^ \t\n\r\f]*\\)" 1)
    ("func" "^func *\\(.*\\) {" 1)))
  )

(add-hook 'go-mode-hook 'my-go-mode-hook)
(add-hook 'go-mode-hook 'go-eldoc-setup)
(add-hook 'go-mode-hook (lambda ()
                            (local-set-key (kbd "M-.") 'godef-jump)
                            (local-set-key (kbd "M-*") 'pop-tag-mark)
                            (local-set-key (kbd "C-c d") 'godoc-at-point)
                            (local-set-key (kbd "C-c C-d") 'godoc)
                            (setq show-trailing-whitespace t)
                            (setq ethan-wspace-errors (remove 'tabs ethan-wspace-errors))
                            (add-hook 'before-save-hook 'gofmt-before-save)
                          ))

(setq hc-highlight-tabs-mode '(not go-mode terraform-mode))
(setq ethan-wspace-highlight-tabs-mode '(not go-mode terraform-mode))

;(paradox-require 'auto-complete)
; (paradox-require 'go-autocomplete)
;(paradox-require 'auto-complete-config)
;(defun autocomplete-for-go ()
;  (auto-complete-mode 1))
;(add-hook 'go-mode-hook 'autocomplete-for-go)
;(with-eval-after-load 'go-mode
; (require 'go-autocomplete))
; (global-set-key "\C-c\C-h" 'auto-complete)
; (ac-config-default)

; "company" for go auto-completion

;; (paradox-require 'company-go)

;; (add-hook 'go-mode-hook (lambda ()                          (company-mode)                          (set (make-local-variable 'company-backends) '(company-go))))

                                        ; Custom behaviour
                                        ; Mac keys
(setq mac-command-modifier 'super)

; Change M-f to something sensible
(defun next-word (p)
   "Move point to the beginning of the next word, past any spaces"
   (interactive "d")
   (forward-word)
   (forward-word)
   (backward-word))
(global-set-key "\M-f" 'next-word)

; Key bindings
(global-set-key "\C-c\C-b" 'compile)
(global-set-key "\C-c\C-e" 'sr-speedbar-toggle)
(global-set-key "\C-c\C-s\C-c" 'avy-goto-char)
(global-set-key "\C-c\C-s\C-t" 'avy-goto-char-timer)
(global-set-key "\C-c\C-s\C-w" 'avy-goto-word-0)
(global-set-key "\C-c\C-s\C-l" 'avy-goto-line)
(global-set-key "\C-c\C-s\C-rc" 'avy-copy-region)
(global-set-key "\C-c\C-s\C-rm" 'avy-move-region)
(global-set-key "\C-c\C-s\C-p" 'avy-pop-mark)

(global-set-key "\C-c\C- " 'er/expand-region)
(global-set-key "\C-xo" 'ace-select-window)
(global-set-key "\C-xf" 'helm-projectile)
(global-set-key "\C-c\C-i" 'yas-insert-snippet)
(global-set-key "\C-c\C-m" 'bm-toggle)
(global-set-key "\C-c\C-n"   'bm-next)
(global-set-key "\C-\M-l" 'move-to-window-line-top-bottom)
(global-set-key "\C-xwn" 'windmove-down)
(global-set-key "\C-xwp" 'windmove-up)

; Cheatsheet
(global-set-key "\C-h\C-s"   'cheatsheet-show)
(cheatsheet-add-group 'Cheatsheet
                      '(:key "C-h C-s" :description "show cheatsheet")
                      '(:key "C-q" :description "quit cheatsheet")
                      )

(cheatsheet-add-group 'Clojure
                      '(:key "C-c SPC" :description "align format")
                      '(:key "M-q" :description "align around point")
                      )

(cheatsheet-add-group 'Golang
                      '(:key "C-c C-b" :description "build")
                      )

(cheatsheet-add-group 'Cider
                      '(:key "C-x C-e" :description "Evaluate sexp")
                      '(:key "C-c M-n" :description "Set name space")
                      '(:key "C-c C-k" :description "Compile current file")
                      '(:key "C-c C-d C-d" :description "Doc at point")
                      '(:key "C-c C-d C-a" :description "Apropos search")
                      '(:key "M-." :description "Follow source")
                      '(:key "M-," :description "Pop follow source")
                      )

(cheatsheet-add-group 'helm
                      '(:key "C-xf" :description "helm find file")
                      '(:key "C-xcf" :description "helm multi find file")
                      '(:key "C-xci" :description "helm imenu")
                      )

(cheatsheet-add-group 'bookmarks
                      '(:key "C-xr m" :description "set bookmark")
                      '(:key "C-xr l" :description "list bookmarks")
                      '(:key "C-xr b" :description "jump to bookmark")
                      '(:key "C-c (C-)m" :description "Toggle bookmark")
                      '(:key "C-c C-n" :description "Jump to next bookmark")
                      )

(cheatsheet-add-group 'registers
                      '(:key "C-xr s" :description "store region")
                      '(:key "C-xr i" :description "Insert register")
                      '(:key "C-xr SPC" :description "Store point")
                      '(:key "C-xr j" :description "jump to register")
                      )

(cheatsheet-add-group 'nav
                      '(:key "C-c C-s C-t" :description "avy-goto-char-timer")
                      '(:key "C-c C-s C-w" :description "avy-goto-word")
                      '(:key "C-c C-s C-c" :description "avy-goto-char")
                      '(:key "C-c C-s C-l" :description "avy-goto-line")
                      '(:key "C-c C-s C-rm" :description "avy-move-region")
                      '(:key "C-c C-s C-rc" :description "avy-copy-region")
                      '(:key "C-c C-s C-p" :description "avy-pop-mark")
                      '(:key "C-l" :description "Re-centre point middle/top/bottom")
                      )

(cheatsheet-add-group 'general-code
                      '(:key "C-x C-i" :description "insert snippet")
                      '(:key "C-c C-e" :description "speedbar toggle")
                      )

(cheatsheet-add-group 'misc
                      '(:key "C-u SPC" :description "Pop mark")
                      '(:key "M-SPC" :description "Delete whitespace")
                      )

(cheatsheet-add-group 'regions
                      '(:key "C-SPC" :description "Start region")
                      '(:key "C-x SPC" :description "Start rectangular region")
                      '(:key "C-u SPC" :description "Jump to mark")
                      '(:key "C-x C-x" :description "Exchange point and mark")
                      '(:key "C-c C- " :description "Expand region")
                      '(:key "C-x TAB" :description "Indent region")
                      '(:key "C-c C-d C-p" :description "Drag up")
                      '(:key "C-c C-d C-n" :description "Drag down")
                      )

(cheatsheet-add-group 'sexp
                      '(:key "C-M-f" :description "Move forward by sexp")
                      '(:key "C-M-b" :description "Movekward by sexp")
                      '(:key "C-M-u" :description "Move up out of a list")
                      '(:key "C-M-d" :description "Move down into a list")
                      '(:key "C-M-n" :description "Move forward to next sexp")
                      '(:key "C-M-p" :description "Move backward to previous sexp")
                      '(:key "C-M-p" :description "Move backward to previous sexp")
                      '(:key "M-s" :description "Splice sexp")
                      '(:key "M-(" :description "Wrap sexp")
                      '(:key "M-\"" :description "Wrap string")
                      '(:key "ESC-]" :description "Forward slurp")
                      '(:key "ESC-[" :description "Backward slurp")
                      '(:key "ESC-}" :description "Forward barf")
                      '(:key "ESC-{" :description "Backward barf")
                      '(:key "M-r" :description "Raise sexp")
                      '(:key "M-S" :description "Split sexp")
                      '(:key "M-J" :description "Join sexp")
                      )

; Line numbers
(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))


; ace-isearch

;(global-ace-isearch-mode +1)
;(setq ace-isearch-function 'avy-goto-char)

; Sort out tabs to be 4 spaces
(setq default-tab-width 4)

;; Change the error colour
(custom-set-faces!
  '(flycheck-error :underline (:color "yellow" :style wave)))
