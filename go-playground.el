;;; go-playground.el  --- Go Playground client tool  -*- lexical-binding: t -*-

;; Copyright (C) 2015 KOBAYASHI Shigeru

;; Author: KOBAYASHI Shigeru (kosh) <shigeru.kb@gmail.com>
;; Version: 1.0
;; Package-Requires: ((emacs "24") (request "0.2.0") (deferred "0.3.2") (s "1.10.0") (f "0.17.2") (let-alist "1.0.4") (cl-lib "1.0"))
;; Keyword: extensions, tools
;; Created: 2015-10-19
;; License: MIT
;; URL: https://github.com/kosh04/emacs-go-playground

;; This file is NOT part of GNU Emacs.

;;; Commentary:

;; `go-playground.el' provide interface to Go Playground (https://play.golang.org).
;; You can compile and run a Go program like `go run prog.go`.

;;; Change Log:

;; 2015-10-19  v1.0  initial release

;;; Code:

;; basic
(require 'json)
(require 'url-util)
;; elpa
(require 'request)
(require 'deferred)
(require 's)
(require 'f)
(require 'let-alist)
(require 'cl-lib)
(require 'go-mode nil t)                ; optional

(defconst go-playground-version "1.0")

(defvar go-playground-compile-url
  "http://play.golang.org/compile"
  "Endpoint URL for Go Playground compile.")

(defun go-playground-request (code)
  "Send request CODE and display output."
  (request
   go-playground-compile-url
   :type "POST"
   :data (url-build-query-string
          `(("version" 2)
            ("body" ,code)))
   :parser (lambda ()
             (decode-coding-region (point-min) (point-max) 'utf-8-unix)
             (json-read))
   :success (cl-function
             (lambda (&key data &allow-other-keys)
               (let-alist data
                 (when (s-present? .Errors)
                   (message "%s" (s-chomp .Errors)) ; `error' cannot handler message
                   (cl-return))
                 (let ((output (get-buffer-create "*Go Playground*")))
                   (go-playground--playback output .Events)))))))

(defun go-playground--playback (output events)
  (cl-labels ((clear (output)
                (with-current-buffer output (erase-buffer))))
    (clear output)
    (display-buffer output)
    (deferred:$
      (deferred:loop events
        (lambda (e)
          (let-alist e
            ;; ^L clears the screen
            (when (s-starts-with? "\x0c" .Message)
              (setf (substring .Message 0 1) "")
              (clear output))
            (princ .Message output)
            (sleep-for 0 (/ .Delay 1000000)))))
      (deferred:nextc it
        (lambda ()
          (with-current-buffer output
            (insert (propertize "Program exited." 'face '(:foreground "red")))))))))

;;;###autoload
(defun go-playground-run-file (path)
  "Compile and run go program from PATH."
  (interactive "fGo run (playground): ")
  (cl-assert (f-ext? path "go"))
  (go-playground-request (f-read path)))

;;;###autoload
(defun go-playground-run-current-file ()
  "Compile and run go program from current file."
  (interactive)
  (go-playground-run-file (buffer-file-name)))

;;;###autoload
(with-eval-after-load "go-mode"
  ;; register menu
  (define-key (lookup-key go-mode-map [menu-bar Go Playground]) [Run]
    '("Run" . go-playground-run-current-file)))

(provide 'go-playground)

;;; go-playground.el ends here
