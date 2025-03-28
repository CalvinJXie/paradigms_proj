; Calvin Xie
; cjx210000
; Programming Language Paradigms


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
  (real->double-flonum n));converts input n to double precision




; stack operations
(define (stack_push stackList value)
  (cons value stackList)) ; append value ot stackList- list implementation of a stack

(define (stack_pop stackList)
  (if (null? stackList) ; check if empty list/stack
    (list #f '()) ; if true return empty list/stack, #f indicates error/false
    (list (car stackList) (cdr stackList)))); else return a list with top/first element and remaining stack



; function to evaluate prefix expression
(define (apply_operation operation n1 n2)
  (case operation
    [("+") (values (+ n1 n2) #t)]
    [("-") (if (not n2) (values (- n1) #t) (values (- n1 n2) #t))] ; Unary if n2 is #f
    [("*") (values (* n1 n2) #t)]
    [("/") (if (zero? n2)
               (values #f "Error: Dividing by zero") ;if zero return error msg
               (values (quotient n1 n2) #t))] ;else do divide
    [else (values #f (format "Error: Unknown Operator: ~a" operation))])) ;for anything else, return error msg


; Tokenize Function. Gets out each character
(define (tokenize str)
  (let loop ([chars (string->list str)]
             [current ""]
             [tokens '()]
             [prev-char #f]) ; Track previous character to detect unary -
    (cond
      [(null? chars) ; End of string
       (if (equal? current "")
           (reverse tokens)
           (reverse (cons current tokens)))]
      [(char-whitespace? (car chars)) ; Whitespace
       (if (equal? current "")
           (loop (cdr chars) "" tokens (car chars))
           (loop (cdr chars) "" (cons current tokens) (car chars)))]
      [(member (car chars) '(#\+ #\- #\* #\/)) ; Operator
       (if (equal? current "")
           (loop (cdr chars) "" (cons (string (car chars)) tokens) (car chars))
           (loop (cdr chars) (string (car chars)) (cons current tokens) (car chars)))]
      [(char=? (car chars) #\$) ; Start of $n reference
       (if (equal? current "")
           (loop (cdr chars) "$" tokens (car chars))
           (loop (cdr chars) (string (car chars)) (cons current tokens) (car chars)))]
      [else ; Number or part of $n
       (let ([new-current (string-append current (string (car chars)))])
         (if (and (> (string-length new-current) 1) ; Check if multi-character
                  (not (string=? (substring new-current 0 1) "$"))) ; Not a $n
             (let ([last-char (string-ref new-current (- (string-length new-current) 1))])
               (if (and (member last-char '(#\+ #\- #\* #\/)) ; Last char is operator
                        (not (and (char=? last-char #\-) ; Allow - as unary if prev is operator or start
                                  (or (not prev-char) (member prev-char '(#\+ #\- #\* #\/ #\space))))))
                   (loop (cdr chars) ; Move past current char
                         (substring new-current (- (string-length new-current) 1)) ; Operator
                         (cons (substring new-current 0 (- (string-length new-current) 1)) tokens)
                         (car chars))
                   (loop (cdr chars) new-current tokens (car chars))))
             (loop (cdr chars) new-current tokens (car chars))))])))






;function to process single character
(define (process_char character history)
  (cond
    [(and (> (string-length character) 0)  ; check if multiple characters ($1)
          (string=? (substring character 0 1) "$")) ; check if $ is first char
     (let* ([index_num (substring character 1)] ; extract substring after $ to get digit
            [index (string->number index_num)]) ; convert to num
       (if (and index (< index (length history))) ; check valid index in history list size
           (list (list-ref (reverse history) index) #t) ; return value at index
           (list #f (format "Error: invalid index: ~a" index))))] ; else return error message
    [(string->number character) ;convert to num to check if it is a number
     (list (string->number character) #t)] ; if successfully converts number returns number with true
    [else (list character #f)])); else return character with false




; function to evaluate prefix expression from string
(define (compute_prefix str history stack)
  (let ([char_list (reverse (tokenize str))]) ; split string into separate characters and reverses it for prefix order
    (let loop ([char_list char_list] ;start looping with char_list as token list
               [current_stack '()]); start with empty stack each time
      (if (null? char_list) ; check if char_list is empty
          (if (null? current_stack) ; check if current_stack is empty
              (values #f #f "Error: Empty expression" history stack) ; return error if empty
              (let ([result (car current_stack)]) ; get potential result from stack top
                (if (null? (cdr current_stack)) ; check if exactly one item in stack
                    (values result #t #f (if (number? result) (cons result history) history) stack)
                    (values #f #f "Error: Invalid expression" history stack))))
          (let* ([char (car char_list)] ; get first character from char_list
                 [processed (process_char char history)] ; process the character
                 [value (car processed)] ; extract values from processed result
                 [is-number? (cadr processed)]) ; get boolean to see if it is number
            (if is-number? ; check if is number from prev boolean
                (loop (cdr char_list) (stack_push current_stack value)) ; if it is a number, loop through remaining characters and push values onto stack
                ; else pop 2 numbers and run the operation
                (let* ([pop1 (stack_pop current_stack)] ; pop first number from current stack
                       [n1 (car pop1)] ; gets first num value
                       [rest1 (cadr pop1)]) ; get remaining stack
                  (if (not n1)
                      (values #f #f "Error: Not enough operands" history stack)
                      (if (and (member char '("-")) (not (null? (cdr char_list)))) ; Unary check with lookahead
                          (let-values ([(result success?) (apply_operation char n1 #f)])
                            (if success?
                                (loop (cdr char_list) (stack_push rest1 result))
                                (values #f #f result history stack)))
                          (let* ([pop2 (stack_pop rest1)]
                                 [n2 (car pop2)]
                                 [rest2 (cadr pop2)])
                            (if (not n2)
                                (values #f #f "Error: Not enough operands" history stack)
                                (let-values ([(result success?) (apply_operation char n1 n2)])
                                  (if success?
                                      (loop (cdr char_list) (stack_push rest2 result))
                                      (values #f #f result history stack))))))))))))))




; Interactive Function
(define (interactive_mode history stack)
  (displayln "Prefix Calculator: Enter a prefix expression (e.g., +*2$1+$2 1) or 'quit' to stop")
  (let loop ([h history]
             [s stack])
    (display "> ")
    (let ([input (read-line)])
      (if (string=? input "quit")
          (displayln "Fin.")
          (let-values ([(result success? err-msg new-history new-stack) (compute_prefix input h s)])
            (if success?
                (begin
                  (printf "~a: " (length new-history)) ; print id
                  (if (number? result)
                      (display (toFloat result))
                      (display "Error: Result is not a number or division by zero"))
                  (displayln "")
                  (printf "History: ~a\n" (reverse new-history))
                  (loop new-history s))
                (begin
                  (printf "~a\n" err-msg)
                  (loop h s))))))))




; Batch function
(define (batch_mode history stack)
  (let loop ([h history]
             [s stack])
    (let ([input (read-line)])
      (cond
        [(eof-object? input)
         (void)] ; exit loop when end of input is reached
        [(string=? input "quit")
         (void)] ; exit loop when input is "quit"
        [else
         (let-values ([(result success? err-msg new-history new-stack) (compute_prefix input h s)])
           (if success?
               (begin
                 (if (number? result)
                     (displayln (toFloat result))
                     (displayln "Error: Result is not a number or division by zero")))
               (displayln err-msg))
           (loop (if success? new-history h) s))]))))




; modify this, switch batch_mode and interactive, top one applies to executable. You can also change the name, interactive->batch

; Runs in interactive.
;(if prompt?
;    (interactive_mode '() '())
;    (batch_mode '() '())
;  )

; Runs in Batch.
;(if prompt?
;    (batch_mode '() '())
;    (interactive_mode '() '())
;    
;  )
(if prompt?
    (batch_mode '() '())
    (interactive_mode '() '())
    
  )