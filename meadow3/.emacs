(modify-coding-system-alist 'file "\\.pl$" 'euc-jp-unix)
(modify-coding-system-alist 'file "\\.sql$" 'euc-jp-unix)
(modify-coding-system-alist 'file "\\.sh$" 'euc-jp-unix)

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
                   '(vertical-scroll-bars . nil) ;;スクロールバーはいらない
                   '(width . 100) ;; ウィンドウ幅
                   '(height . 35) ;; ウィンドウの高さ
                   '(top . 60) ;;表示位置
                   '(left . 140) ;;表示位置
                   '(font . "MS Gothic 12") ;;フォント
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
;;(setq telnet-program "c:/meadow3/bin/telnet.exe")
;;(add-hook 'telnet-mode-hook '_telnet-mode)
;;(defun _telnet-mode ()
;;(set-buffer-process-coding-system 'euc-japan 'sjis-unix))
;;  (set-buffer-process-coding-system 'undecided-dos 'euc-japan))


;; 全角スペースを「□」として表示する。
(require 'jaspace)


;;Cygwin
(setq explicit-shell-file-name "bash.exe")
(setq shell-file-name "sh.exe")
(setq shell-command-switch "-c")
(modify-coding-system-alist 'process ".*sh\\.exe" '(undecided-dos . euc-jp-unix))
;; argument-editing の設定
(require 'mw32script)
(mw32script-init)
(setq exec-suffix-list '(".exe" ".sh" ".pl"))
(setq shell-file-name-chars "~/A-Za-z0-9_^$!#%&{}@`'.:()-")

;;;
;;; sql-mode
;;; http://www.emacswiki.org/cgi-bin/wiki.pl?SqlMode
;;;

(autoload 'sql-mode "sql" "SQL Edit mode" t)
(autoload 'sql-oracle "sql" "SQL Edit mode" t)
(autoload 'sql-ms "sql" "SQL Edit mode" t)
(autoload 'master-mode "master" "Master mode minor mode." t)

;; SQL mode に入った時点で sql-indent / sql-complete を読み込む
(eval-after-load "sql"
  '(progn
     (load-library "sql-indent")
     (load-library "sql-complete")
     (load-library "sql-transform")
     ))

;; デフォルトのデータベースの設定
(setq sql-user "scott")
(setq sql-database "orcl")

;; SQL モードの雑多な設定
(add-hook 'sql-mode-hook
    (function (lambda ()
                (setq sql-indent-offset 4)
                (setq sql-indent-maybe-tab t)
                (local-set-key "\C-cu" 'sql-to-update) ; sql-transform 
                 ;; SQLi の自動ポップアップ
                   (setq sql-pop-to-buffer-after-send-region t)
                ;; master モードを有効にし、SQLi をスレーブバッファにする
                   (master-mode t)
                (master-set-slave sql-buffer)
                ))
    )
(add-hook 'sql-set-sqli-hook
          (function (lambda ()
                      (master-set-slave sql-buffer))))       
(add-hook 'sql-interactive-mode-hook
          (function (lambda ()
                      ;; 「;」をタイプしたら SQL 文を実行
                         (setq sql-electric-stuff 'semicolon) 
                      ;; comint 関係の設定
                         (setq comint-buffer-maximum-size 500)
                      (setq comint-input-autoexpand t)
                      (setq comint-output-filter-functions 
                            'comint-truncate-buffer)))
          )

;; SQL モードから SQLi へ送った SQL 文も SQLi ヒストリの対象とする
(defadvice sql-send-region (after sql-store-in-history)
  "The region sent to the SQLi process is also stored in the history."
  (let ((history (buffer-substring-no-properties start end)))
    (save-excursion
      (set-buffer sql-buffer)
      (message history)
      (if (and (funcall comint-input-filter history)
               (or (null comint-input-ignoredups)
                   (not (ring-p comint-input-ring))
                   (ring-empty-p comint-input-ring)
                   (not (string-equal (ring-ref comint-input-ring 0)
                                      history))))
          (ring-insert comint-input-ring history))
      (setq comint-save-input-ring-index comint-input-ring-index)
      (setq comint-input-ring-index nil))))
(ad-activate 'sql-send-region)
