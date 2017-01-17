
(mapcar #'ql:quickload '(alexandria checkl fiveam))

(defpackage hotkey
  (:use :alexandria :cl :fiveam)
  (:import-from :checkl
                #:check
                #:results))

(in-package hotkey)

;; My two best friends in repl land.
(defun cat (&rest rest)
  (format nil "~{~A~}" rest))

(defun keycat (&rest rest)
  (make-keyword (apply #'cat rest)))

(defun ensure-keyword ())

;; (alias "Windows" '(or "Super_L" "Super_R"))

;; First catch with AHK: AltGr
;; If used as a modifier:  "<^>!"
;; If used as a hotkey:    LControl & RAlt

;; Also in AHK:
;; * means "Fire the hotkey even if extra modifiers are being held down"
;; ~ means the event will be propagated
;; $ is used to prevent self-triggering
;; UP is used to trigger the hotkey on key release

;; note: the sort help debug in repl (faster "manual lookup")
(defparameter *key-modifiers*
  '((:alt "!")
    (:alt-left "<!")
    (:alt-right ">!")
    (:control "^")
    (:control-left "<^")
    (:control-right ">^")
    (:shift "+")
    (:shift-left "<+")
    (:shift-right ">+")
    (:super "#")
    (:super-left "<#")
    (:super-right ">#"))
  "Associating 'modifier keyword' to 'AHK symbol'.")

#+nil (sort
       (loop :for (key ahk-symbol)
               :on '(:control "^"
                     :super "#"
                     :alt "!"
                     :shift "+")
             :by #'cddr
             :append `((,key ,ahk-symbol)
                       (,(keycat key '-left) ,(cat "<" ahk-symbol))
                       (,(keycat key '-right) ,(cat ">" ahk-symbol))))
       #'(lambda (x1 x2)
           (string< (symbol-name (first x1))
                    (symbol-name (first x2)))))


(defparameter *keys*
  '((:alt "Alt")
    (:alt-left "LAlt")
    (:alt-right "RAlt")
    (:control "Control")
    (:control-left "LControl")
    (:control-right "RControl")
    (:shift "Shift")
    (:shift-left "LShift")
    (:shift-right "RShift")
    (:super "Win")
    (:super-left "LWin")
    (:super-right "RWin")))

(second (assoc :alt *keys*))

;; FIXME Assumes the modifiers are in the right order
(defun hotkey-to-ahk (hotkey)
  "Take a hotkey specification and return an AHK hotkey as a string. See Tests for the specification."
  (with-output-to-string (*standard-output*)
    (let ((capitalize-next-p))
      (labels ((capitalize-next () (setf capitalize-next-p t))
               (maybe-keyword (x) (if (symbolp x) (make-keyword x) x)))
        (if (length= 1 hotkey)
            (let ((spec (maybe-keyword (first hotkey))))
              (princ
               (if (keywordp spec)
                   (second (assoc spec *keys*))
                   spec)))
            (loop :for spec :in hotkey
                  :do
                     (let ((spec (maybe-keyword spec)))
                       (if (keywordp spec)
                           (cond
                             ((eq :shift spec) (capitalize-next))
                             (t (princ #. `(ecase spec ,@*key-modifiers*))))
                           (if capitalize-next-p
                               (princ (string-capitalize spec)) ;; FIXME string-capitalize will only get us so far...
                               (princ spec))))))))))

(test ahk/modifiers-by-themselves
      (is (string= "Alt" (hotkey-to-ahk '(alt))))
      (is (string= "LAlt" (hotkey-to-ahk '(alt-left))))
      (is (string= "RAlt" (hotkey-to-ahk '(alt-right))))
      (is (string= "Control" (hotkey-to-ahk '(control))))
      (is (string= "LControl" (hotkey-to-ahk '(control-left))))
      (is (string= "RControl" (hotkey-to-ahk '(control-right))))
      (is (string= "Shift" (hotkey-to-ahk '(shift))))
      (is (string= "LShift" (hotkey-to-ahk '(shift-left))))
      (is (string= "RShift" (hotkey-to-ahk '(shift-right))))
      (is (string= "Win" (hotkey-to-ahk '(super))))
      (is (string= "LWin" (hotkey-to-ahk '(super-left))))
      (is (string= "RWin" (hotkey-to-ahk '(super-right)))))

;; (run! 'ahk/modifiers-by-themselves)

(test ahk/simple-modifiers
      (is (string= "!x" (hotkey-to-ahk '(alt "x"))))
      (is (string= "<!x" (hotkey-to-ahk '(alt-left "x"))))
      (is (string= ">!x" (hotkey-to-ahk '(alt-right "x"))))
      (is (string= "^x" (hotkey-to-ahk '(control "x"))))
      (is (string= "<^x" (hotkey-to-ahk '(control-left "x"))))
      (is (string= ">^x" (hotkey-to-ahk '(control-right "x"))))
      (is (string= "X" (hotkey-to-ahk '(shift "x"))))
      ;; (is (string= "<+x" (hotkey-to-ahk '(shift-left "x"))))
      ;; (is (string= ">+x" (hotkey-to-ahk '(shift-right "x"))))
      (is (string= "#x" (hotkey-to-ahk '(super "x"))))
      (is (string= "<#x" (hotkey-to-ahk '(super-left "x"))))
      (is (string= ">#x" (hotkey-to-ahk '(super-right "x")))))

;; (run! 'ahk/simple-modifiers)

;; (test and
;;      (is (= "a & b") ...))

