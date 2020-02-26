(*
                         CS 51 Problem Set 4
                 A Language for Symbolic Mathematics
                               Testing
 *)

open Expression ;;
open ExpressionLibrary ;;

open Absbook ;;

let test () =
  unit_test (contains_var (parse "x+3") = true)
    "contains_var sum left";
  unit_test (not (contains_var (parse "2")) = true)
    "contains_var number";
    unit_test (contains_var (parse "3") = false)
      "contains_var num";
      unit_test (contains_var (parse "x+4*9" ) = true)
        "contains_var binop";
        unit_test (contains_var (parse "sin15") = false)
          "contains_var unop";

  unit_test (evaluate (parse "x^4 + 3") 2.0 = 19.)
    "evaluate pow and add";
    unit_test (evaluate (parse "x") 14.0 = 14.)
      "evaluate Var";
      unit_test (evaluate (parse "7 + sin x") 0. = 7.)
        "evaluate Binop + Unop";
        unit_test (evaluate (parse "x ^ 3") 2.0 = 8.)
          "evaluate Binop";
          unit_test (evaluate (parse "ln x") 1.0 = 0.)
            "evaluate Unop";
            unit_test (evaluate (parse "~x") 58.0 = -58.)
              "evaluate Unop 2";
              unit_test (evaluate (parse "~x ^ 3") 2.0 = -8.)
                "evaluate Unop3";

                unit_test (evaluate (parse "x^4 + 3") 2.0 = 19.)
                  "evaluate pow and add";

                  unit_test (evaluate(derivative (parse "5")) 2. = 0.)
                    "derivative num";
                    unit_test (evaluate(derivative (parse "x")) 2. = 1.)
                      "derivative Var";
                      unit_test (evaluate(derivative (parse "sin x")) 0. = 1.)
                        "derivative sin";
                        unit_test (evaluate(derivative (parse "cos x")) 1. = -0.841470984807896505)
                          "derivative cos";
  unit_test (evaluate(derivative (parse "ln x")) 1. = 1.)
    "derivative ln";
    unit_test (evaluate(derivative (parse "x^3 +8")) 5. = 75.)
      "derivative pow no val";
  unit_test (evaluate(derivative (parse "x^ (2 * x)")) 1. = 4.)
    "derivative pow no val";
  (* this ain't working *)
  unit_test (evaluate(derivative (parse "4 * x - x ^ 3")) 2. = -8.)
    "derivative sub";
    unit_test (evaluate(derivative (parse "4 * x + x ^ 3")) 2. = 16.)
      "derivative add";
  unit_test (evaluate(derivative (parse "(4 * x) * (x ^ 3)")) 2. = 128.)
    "derivative mul";
    unit_test (evaluate(derivative (parse "(4 * x) / (x ^ 3)")) 2. = -1.)
      "derivative div";
      unit_test (evaluate(derivative (parse "x ^ ~2")) 5. = ~-.0.016)
      "derivative neg exponent";
        unit_test (evaluate(derivative (parse "~5 * x ^2")) 3. = ~-.30.0)
      "derivative neg coefficient";

    unit_test (find_zero (parse "3 * x - 1") 0. 0.00001 100 = Some 0.333333333333333315)
        "find_zero 1/3";
  unit_test (find_zero (parse "x - 4") 0. 0.001 5 = Some 4.)
    "find_zero x-4";
    unit_test (find_zero (parse "x ^ 2 - 6") 0. 0.001 50 = None)
      "find_zero x^2-6";
    



  () ;;

test ();;
