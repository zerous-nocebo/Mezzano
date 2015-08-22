;;;; Copyright (c) 2011-2015 Henry Harrington <henry.harrington@gmail.com>
;;;; This code is licensed under the MIT license.

(in-package :sys.int)

(define-compiler-macro mapcar (function list &rest more-lists)
  (let* ((fn-sym (gensym "FN"))
         (result-sym (gensym "RESULT"))
         (tail-sym (gensym "TAIL"))
         (tmp-sym (gensym "TMP"))
         (all-lists (list* list more-lists))
         (iterators (mapcar (lambda (x) (declare (ignore x)) (gensym))
                            all-lists)))
    `(do* ((,fn-sym ,function)
           (,result-sym (cons nil nil))
           (,tail-sym ,result-sym)
           ,@(mapcar (lambda (name form)
                       (list name form `(cdr ,name)))
                     iterators all-lists))
          ((or ,@(mapcar (lambda (name) `(null ,name))
                         iterators))
           (cdr ,result-sym))
       (let ((,tmp-sym (cons (funcall ,fn-sym ,@(mapcar (lambda (name) `(car ,name))
                                                        iterators))
                             nil)))
         (setf (cdr ,tail-sym) ,tmp-sym
               ,tail-sym ,tmp-sym)))))

(define-compiler-macro mapc (function list &rest more-lists)
  (let* ((fn-sym (gensym "FN"))
         (result-sym (gensym "RESULT"))
         (all-lists (list* list more-lists))
         (iterators (mapcar (lambda (x) (declare (ignore x)) (gensym))
                            all-lists)))
    `(do* ((,fn-sym ,function)
           ,@(mapcar (lambda (name form)
                       (list name form `(cdr ,name)))
                     iterators all-lists)
           (,result-sym ,(first iterators)))
          ((or ,@(mapcar (lambda (name) `(null ,name))
                         iterators))
           ,result-sym)
       (funcall ,fn-sym ,@(mapcar (lambda (name) `(car ,name))
                                  iterators)))))

(define-compiler-macro maplist (function list &rest more-lists)
  (let* ((fn-sym (gensym "FN"))
         (result-sym (gensym "RESULT"))
         (tail-sym (gensym "TAIL"))
         (tmp-sym (gensym "TMP"))
         (all-lists (list* list more-lists))
         (iterators (mapcar (lambda (x) (declare (ignore x)) (gensym))
                            all-lists)))
    `(do* ((,fn-sym ,function)
           (,result-sym (cons nil nil))
           (,tail-sym ,result-sym)
           ,@(mapcar (lambda (name form)
                       (list name form `(cdr ,name)))
                     iterators all-lists))
          ((or ,@(mapcar (lambda (name) `(null ,name))
                         iterators))
           (cdr ,result-sym))
       (let ((,tmp-sym (cons (funcall ,fn-sym ,@iterators) nil)))
       (setf (cdr ,tail-sym) ,tmp-sym
             ,tail-sym ,tmp-sym)))))
