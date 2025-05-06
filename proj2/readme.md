project repository for paradigms. 

devlog.md is my devlog.
maze_solver.pl is the project, it will find a path that will solve a randomly generated maze.
description.txt is the project description so that I do not need to keep opening elearning.

Steps to compile:
install prolog, I used homebrew's, brew install prolog
open terminal or whatever used to compile arguments
in terminal:
type swipl if you have prolog installed in terminal
Type "consult(['maze_solver.pl', 'example.pl', 'test.pl'])." to load the program maze_solver, example and test
Now you can run test cases such as:
"basic_map(M), display_map(M), find_exit(M, A)." -> find a path using example's map predicates


For gen map:
set_prolog_flag(toplevel_print_options, [quoted(true), portray(true), max_depth(0), max_length(0)]).

Use set prolog flag first so that it displays entire solution list instead of truncating

gen_map(2, 5, 5, M), test:display_map(M), find_exit(M, A).