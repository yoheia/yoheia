;; ロードパス
(setq load-path (cons "~/emacs/site-lisp" load-path))
(setq load-path (cons "~/emacs/site-lisp/w3m" load-path))

;; 行数表示
(line-number-mode t)
;; 列数表示
(column-number-mode 1)
;; #のバックアップファイルを作成しない
(setq make-backup-files nil)
;; バックアップファイルを作らない
(setq backup-inhibited t)
;; タブの設定
(setq c-tab-always-indent t)
(setq default-tab-width 2)
(setq indent-line-function 'indent-relative-maybe)
;; 選択範囲をインデント
(global-set-key "\C-x\C-i" 'indent-region)
;; リターンで改行とインデント
(global-set-key "\C-m" 'newline-and-indent)
(global-set-key "\C-j" 'newline)  ; 改行
;; C-ccで範囲指定コメント
(global-set-key "\C-cc" 'comment-region)
;; C-cuで範囲指定コメントを解除
(global-set-key "\C-cu" 'uncomment-region)
(transient-mark-mode t) ; 選択部分のハイライト
(setq require-final-newline t)          ; always terminate last line in file
;(setq default-major-mode 'text-mode)    ; default mode is text mode
(setq completion-ignore-case t) ; file名の補完で大文字小文字を区別しない
(setq partial-completion-mode 1) ; 補完機能を使う
;; シフト + 矢印で範囲選択
1(setq pc-select-selection-keys-only t)
(pc-selection-mode 1)

;; スタートアップページを表示しない
;;(setq inhibit-startup-message t)

;; Macのキーバインドを使う。optionをメタキーにする。
(mac-key-mode 1)
(setq mac-option-modifier 'meta)


(when (eq window-system 'mac)
  (add-hook 'window-setup-hook
            (lambda ()
;;              (setq mac-autohide-menubar-on-maximize t)
              (set-frame-parameter nil 'fullscreen 'fullboth)
              )))


(defun mac-toggle-max-window ()
  (interactive)
  (if (frame-parameter nil 'fullscreen)
      (set-frame-parameter nil 'fullscreen nil)
    (set-frame-parameter nil 'fullscreen 'fullboth)))

;; Carbon Emacsの設定で入れられた. メニューを隠したり．
(custom-set-variables
 '(display-time-mode t)
 '(tool-bar-mode nil)
 '(transient-mark-mode t))
(custom-set-faces
 )


;;Color
(if window-system (progn
   (set-background-color "Black")
   (set-foreground-color "LightGray")
   (set-cursor-color "Gray")
   (set-frame-parameter nil 'alpha 80)
   ))

;;Font
(if (eq window-system 'mac) (require 'carbon-font))
(fixed-width-set-fontset "hirakaku_w3" 10)

;;Twitter
(require 'twittering-mode)
(setq twittering-username "yoheia")
(twittering-icon-mode t)

