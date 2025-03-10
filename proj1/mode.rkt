#lang racket

(define prompt?
   (let [(args (current-command-line-arguments))]
     (cond
       [(= (vector-length args) 0) #t]
       [(string=? (vector-ref args 0) "-b") #f]
       [(string=? (vector-ref args 0) "--batch") #f]
       [else #t])))

; toFloat function
(define (toFloat n)
  (real->double-flonum n))

; stack operations
(define (stack_push stackList value)
  (cons value stackList)) ; append value ot stackList- list implementation of a stack

(define (stack_pop)
  (if (null? stack) ; check if empty list/stack
    (list #f '()) ; if true return empty list/stack, #f indicates error/false
    (list (car stack) (cdr stack)))); else return a list with top/first element and remaining stack