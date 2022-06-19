#lang racket
(define (co sym number)
  (cons sym number))
(define (get_sym s)
  (if (number? s)
    s
    (car s)))
(define (get_number s)
  (if (number? s)
    s
    (cdr s)))

(define (gen f a b)
  (co (list 
      (cond ((eq? f +) '+)
        ((eq? f -) '-)
        ((eq? f *) '*)
        ((eq? f /) '/))
      (get_sym a) (get_sym b))
    (f (get_number a) (get_number b))))
(define (f0 a b)
  (if (or (eq? a 'err) (eq? b 'err))
    (list 'err)
  (list 
      (gen + a b)
      (gen - a b)
      (gen - b a)
      (gen * a b)
    (if (= (get_number b) 0)
        'err
        (gen / a b))
    (if (= (get_number a) 0)
        'err
        (gen / b a)))))
(define (f1 a l)
  (if (null? l)
    '()
    (append (f0 a (car l))
      (f1 a (cdr l)))))
(define (f2 l1 l2)
  (if (null? l1)
    '()
    (append (f1 (car l1) l2)
      (f2 (cdr l1) l2))))
(define (c n)
  (cond 
    ((= n 1) '(1 2 3 4))
    ((= n 2) (f2 (c 1) (c 1)))
    ((= n 3) (f2 (c 1) (c 2)))
    ((= n 4) 
      (append (f2 (c 1) (c 3))
        (f2 (c 2) (c 2))))))

(filter (lambda (x) (= (get_number x) 24))
        (filter (lambda (x) (not (eq? x 'err)))
                (c 4)))

