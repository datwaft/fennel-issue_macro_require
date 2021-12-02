(fn fn? [x]
  "Returns whether `x` is a function.
  This is done by detecting if x is a list and its first element is a function
  declaration.
  Cannot detect if `x` is a function if in compilation time it's a symbol."
  (and
    (list? x)
    (or
      (= `fn (. x 1))
      (= `hashfn (. x 1)))))

{: fn?}
