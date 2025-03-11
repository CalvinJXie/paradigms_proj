# paradigms_proj
project repository for paradigms. 

devlog.md is my devlog.
mode.rkt is the project, which will ask for user input of prefix notation expression, evaluate them, and print them to the screen. The prefix notation calculation uses whitespace to differenitate regular numbers or operators/$ to differenitate.
description.txt is the project description so that I do not need to keep opening elearning.

Steps to compile:
Open Dr Racket
Open mode.rkt
click run. This will run the program in interactive mode. To change it to batch mode, temporarily modify the bottom "if statement" to switch to batch_mode. I have commented in the code the area at the bottom 
If you are using cmd line and have racket stuff installed, echo + -3 10 | racket mode.rkt -b or in interactive, racket mode.rkt