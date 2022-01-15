;;; mac-command.el --- add mac command key as a control key, and add some useful command  -*- lexical-binding: t; -*-

;; Copyright (C) 2022  ingtshan

;; Author: ingtshan <rongcanyo@gmail.com>
;; Keywords: lisp, convenience

(require 'undo-fu)

(defun mac-command-do-kill-9 (&optional pfx)
  "quit emacs with confirm"
  ;; (when (or pfx (y-or-n-p "Quit emacs now?"))
  (save-buffers-kill-terminal))

(defun mac-command-quit-emacs (&optional pfx)
  "quit emacs with need-test check"
  (interactive "P")
  (save-some-buffers)
  (cond
   ;; ((or nil
   ;; 	(and *need-test*
   ;;                (y-or-n-p "Seems Your init configs need test, do it?")))
   ;;  (wf/int-test-gui))
   (t (mac-command-do-kill-9))))

(defun mac-command-close-frame (&optional pfx)
  "close emacs frame"
  (interactive "P")
  (let ((q nil))
    (condition-case ex
	(delete-window) ('error (setq q t)))
    (if q (progn (setq q nil)
		 (condition-case ex
		     (delete-frame) ('error (setq q t)))
		 (if q (mac-command-quit-emacs pfx))))))

(when IS-MAC
  ;; os hot key
  ;; set right command key of macOS
  (setq mac-command-modifier 'hyper mac-option-modifier 'meta)
  ;; what different between (kbd "H-v") and [(hyper v)] ?
  ;; os shortcut
  (global-set-key (kbd "H-a") #'mark-page)         ; 全选
  (global-set-key (kbd "H-v") #'yank)              ; 粘贴
  (global-set-key (kbd "H-x") #'kill-region)       ; 剪切
  (global-set-key (kbd "H-c") #'kill-ring-save)    ; 复制
  (global-set-key (kbd "H-s") #'save-buffer)       ; 保存
  (global-set-key (kbd "H-z") #'undo-fu-only-undo) ; 撤销编辑修改
  (global-set-key (kbd "H-Z") #'undo-fu-only-redo) ; 撤销编辑修改
  (global-set-key [(hyper n)] #'make-frame-command); 新建窗口
  (global-set-key [(hyper q)] #'mac-command-quit-emacs)   ; 退出
  (global-set-key [(hyper w)] #'mac-command-close-frame)  ; 退出frame
  ;; make select more like other editro
  (delete-selection-mode 1)
  ;; use shift to extend select
  (global-set-key (kbd "<S-down-mouse-1>") #'mouse-save-then-kill))

(provide 'mac-command)
