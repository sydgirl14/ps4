(*
			 CS 51 Problem Set 4
                 A Language for Symbolic Mathematics
 *)

(*======================================================================
Before reading this code (or in tandem), read the problem set 4
writeup. It provides context and crucial information for completing
the problems.

We provide a type definition for arithmetic expressions over floating
point numbers with a single variable. The type definition can be found
at the top of expressionLibrary.ml, along with enumerated type
definitions for the unary and binary operators, and other useful
functions. You will be using this algebraic data type for this part of
the problem set.

The module ExpressionLibrary is opened here to provide you with access
to the expression data type and helpful functions that you will use
for this part of the problem set.
......................................................................*)

open ExpressionLibrary ;;

(*......................................................................
Tips:

1. READ THE WRITEUP, particularly for the definition of the derivative
   function.

2. Use the type definitions provided at the top of
   expressionLibrary.ml as a reference, and don't change any of the
   code in that file. It provides functions such as "parse" and
   "to_string_smart" that will be helpful in this problem set.
......................................................................*)

  (*......................................................................
Problem 1: The function `contains_var` tests whether an expression
contains a variable `x`. For example:

# contains_var (parse "x^4") ;;
- : bool = true
# contains_var (parse "4+3") ;;
- : bool = false
......................................................................*)

let rec contains_var (e : expression) : bool =
  match e with
  | Num _ -> false
  | Var -> true
  | Binop (_, exp1, exp2) -> contains_var exp1 || contains_var exp2
  | Unop (_, exp) -> contains_var exp  ;;

(*......................................................................
Problem 2: The function `evaluate` evaluates an expression for a
particular value of `x`. Don't worry about specially handling the
"divide by zero" case. For example:

# evaluate (parse "x^4 + 3") 2.0
- : float = 19.0
......................................................................*)
let convert (b: binop) =
  match b with
  | Add -> ( +. )
  | Sub -> ( -. )
  | Mul -> ( *. )
  | Div -> ( /. )
  | Pow -> ( ** ) ;;
let convertu (u: unop) =
  match u with
  | Sin -> ( sin )
  | Cos -> ( cos )
  | Ln  -> ( log )
  | Neg -> ( ~-. )

let rec evaluate (e : expression) (x : float) : float =
match e with
| Num v -> v
| Var -> x
| Binop (b, exp1, exp2) -> convert b (evaluate exp1 x) (evaluate exp2 x)
| Unop (u, exp) -> convertu u (evaluate exp x) ;;

(*......................................................................
Problem 3: The `derivative` function returns the expression that
represents the derivative of the argument expression. We provide the
skeleton of the implementation here along with a few of the cases;
you're responsible for filling in the remaining parts that implement
the derivative transformation provided in the figure in the
writeup. See the writeup for instructions.
......................................................................*)

let rec derivative (e : expression) : expression =
  match e with
  | Num _ -> Num 0.
  | Var -> Num 1.
  | Unop (u, e1) ->
     (match u with
      | Sin -> Binop (Mul, Unop (Cos, e1), derivative e1)
      | Cos -> Binop (Mul, Unop (Neg, Unop (Sin, e1)), derivative e1)
      | Ln -> Binop (Div, e1, derivative e1)
      | Neg -> Unop(Neg,derivative e1))
  | Binop (b, e1, e2) ->
     match b with
     | Add -> Binop (Add, derivative e1, derivative e2)
     | Sub -> Binop (Sub, derivative e1, derivative e2)
     | Mul -> Binop (Add, Binop (Mul, e1, derivative e2),
                     Binop (Mul, derivative e1, e2))
     | Div -> Binop (Div, Binop(Sub, Binop(Mul, e2, derivative e1),
                                Binop(Mul, e1, derivative e2)),Binop (Mul, e2 ,e2))
     | Pow ->
        (* split based on whether the exponent has any variables *)
       if contains_var e2
       then Binop (Mul, Binop(Mul, derivative e1, derivative e2),
                   Binop(Add, Unop(Ln, e1), Binop(Div, Binop(Mul, e1, Binop(Mul, derivative e1, e2)), e1)))
       else Binop (Mul, e2, Binop (Mul, derivative e1,
                                   Binop (Pow, e1, Binop (Sub, e2, Binop (Div, e2, e2))))) ;;

(* A helpful function for testing. See the writeup. *)
let checkexp strs xval =
  print_string ("Checking expression: " ^ strs ^ "\n");
  let parsed = parse strs in
  (print_string "contains variable : ";
   print_string (string_of_bool (contains_var parsed));
   print_endline " ";
   print_string "Result of evaluation: ";
   print_float (evaluate parsed xval);
   print_endline " ";
   print_string "Result of derivative: ";
   print_endline " ";
   print_string (to_string (derivative parsed));
   print_endline " ") ;;

(*......................................................................
Problem 4: Zero-finding. See writeup for instructions.
......................................................................*)

let rec find_zero (expr : expression)
              (guess : float)
              (epsilon : float)
              (limit : int)
  : float option =
  let value = evaluate (Binop(Sub,Num guess,Binop(Div,expr,derivative expr))) guess in
    match limit with
    | 0 -> if (evaluate expr value) < epsilon then Some value else None
    | _ -> find_zero expr value epsilon (limit - 1) ;;
(*......................................................................
Problem 5: Challenge problem -- exact zero-finding. This problem is
not counted for credit and is not required. Just leave it
unimplemented if you do not want to do it. See writeup for
instructions.
......................................................................*)

let find_zero_exact (e : expression) : expression option =
  failwith "find_zero_exact not implemented" ;;

(*======================================================================
Reflection on the problem set

After each problem set, we'll ask you to reflect on your experience.
We care about your responses and will use them to help guide us in
creating and improving future assignments.

........................................................................
Please give us an honest (if approximate) estimate of how long (in
minutes) this problem set took you to complete.
......................................................................*)

let minutes_spent_on_pset () : int =
  200;;

(*......................................................................
It's worth reflecting on the work you did on this problem set, where
you ran into problems and how you ended up resolving them. What might
you have done in retrospect that would have allowed you to generate as
good a submission in less time? Please provide us your thoughts in the
string below.
......................................................................*)

let reflection () : string =
  "I'm actually pretty confident about this pset. I went to office hours and worked out a solution with a TF and learned a lot especially about recursive functions" ;;
