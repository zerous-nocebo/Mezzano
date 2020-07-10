;;;; Copyright (c) 2011-2017 Henry Harrington <henry.harrington@gmail.com>
;;;; This code is licensed under the MIT license.

(in-package :mezzano.runtime)

(declaim (inline consp))
(defun consp (object)
  (sys.int::%value-has-tag-p object sys.int::+tag-cons+))

(declaim (inline car cdr))
(defun car (list)
  (declare (optimize (debug 0)))
  (cond ((null list)
         nil)
        ((consp list)
         (%car list))
        (t
         (sys.int::raise-type-error list 'list)
         (sys.int::%%unreachable))))

(defun cdr (list)
  (declare (optimize (debug 0)))
  (cond ((null list)
         nil)
        ((consp list)
         (%cdr list))
        (t
         (sys.int::raise-type-error list 'list)
         (sys.int::%%unreachable))))

(declaim (inline (setf car) (setf cdr)))
(defun (setf car) (value cons)
  (declare (optimize (debug 0)))
  (cond ((consp cons)
         (setf (%car cons) value))
        (t
         (sys.int::raise-type-error cons 'cons)
         (sys.int::%%unreachable))))

(defun (setf cdr) (value cons)
  (declare (optimize (debug 0)))
  (cond ((consp cons)
         (setf (%cdr cons) value))
        (t
         (sys.int::raise-type-error cons 'cons)
         (sys.int::%%unreachable))))

(declaim (inline (mezzano.extensions:cas car) (mezzano.extensions:cas cdr)))
(defun (mezzano.extensions:cas car) (old new cons)
  (declare (optimize (debug 0)))
  (cond ((consp cons)
         (nth-value 1 (sys.int::%cas-cons-car cons old new)))
        (t
         (sys.int::raise-type-error cons 'cons)
         (sys.int::%%unreachable))))

(defun (mezzano.extensions:cas cdr) (old new cons)
  (declare (optimize (debug 0)))
  (cond ((consp cons)
         (nth-value 1 (sys.int::%cas-cons-cdr cons old new)))
        (t
         (sys.int::raise-type-error cons 'cons)
         (sys.int::%%unreachable))))
