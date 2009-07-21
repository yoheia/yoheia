(if (boundp 'window-system)
    (setq initial-frame-alist
          (append (list
                   '(foreground-color . "azure3") ;; 文字が白
                   '(background-color . "black") ;; 背景は黒
                   '(border-color     . "black")
                   '(mouse-color      . "white")
                   '(cursor-color     . "white")
                   '(cursor-type      . box)
                   '(menu-bar-lines . 1)
                   ;;15.2 フォントの設定 (2008/04/16) で設定したフォントを使用
                   ;'(font . "my-fontset")
                   ;; 東雲なら shinonome16-fontset などを指定
                   '(vertical-scroll-bars . nil) ;;スクロールバーはいらない
                   '(width . 100) ;; ウィンドウ幅
                   '(height . 35) ;; ウィンドウの高さ
                   '(top . 60) ;;表示位置
                   '(left . 140) ;;表示位置
                   )
                  initial-frame-alist)))
(setq default-frame-alist initial-frame-alist)

(modify-all-frames-parameters (list (cons 'alpha '(80 70 50 30))))

(put 'downcase-region 'disabled nil)

(put 'upcase-region 'disabled nil)

;; ロードパス
(setq load-path (cons "~/emacs/site-lisp" load-path))

;; Twitter
(require 'twittering-mode)
(setq twittering-username "yoheia")

;; Telnet
(setq telnet-program "c:/meadow3/bin/telnet.exe")
(add-hook 'telnet-mode-hook '_telnet-mode)
(defun _telnet-mode ()
  (set-buffer-process-coding-system 'euc-japan 'sjis-unix))

;; 全角スペースを「□」として表示する。
(require 'jaspace)

;;Cygwin
(setq explicit-shell-file-name "bash.exe")
(setq shell-file-name "sh.exe")
(setq shell-command-switch "-c")
(modify-coding-system-alist 'process ".*sh\\.exe" '(undecided-dos . euc-japan))
;; argument-editing の設定
(require 'mw32script)
(mw32script-init)
(setq exec-suffix-list '(".exe" ".sh" ".pl"))
(setq shell-file-name-chars "~/A-Za-z0-9_^$!#%&{}@`'.:()-")

