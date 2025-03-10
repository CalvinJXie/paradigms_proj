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

; global def of stack
(define stack '())

; stack operations
(define (stack_push stackList value)
  (cons value stackList)) ; append value ot stackList- list implementation of a stack

(define (stack_pop)
  (if (null? stack) ; check if empty list/stack
    (list #f '()) ; if true return empty list/stack, #f indicates error/false
    (list (car stack) (cdr stack)))); else return a list with top/first element and remaining stack

; function to evaluate prefix expression
(define (apply_operation operation n1 n2)
  (case operation
    [("+") (values (+ n1 n2) #t)]
    [("-") (values (- n1 n2) #t)]
    [("*") (values (* n1 n2) #t)]
    [("/") (if (zero? n2)
               (values #f "Dividing by zero")
               (values (quotient n1 n2) #t))]
    [else (values #f (format "Unknown Operator: ~a" operation))]))
