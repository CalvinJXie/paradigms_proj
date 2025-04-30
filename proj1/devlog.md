03/09/2025 9:30 PM: Started creating github repo with all the project requirements.

03/09/2025 9:41 PM: Looking at the description, the project seems pretty simple. We have an expression, which will likely be held in a list to simulate a stack, and then if successful, we add the result to another list holding the history. My initial pseudocode that I am thinking is to loop through input and add to the stack, count number of isDigit and operators. If digit and operater are mismatched return an error, else run prefix calc and add value to history. Not sure about batch/interactive mode, will look at that stuff after main function is implemented.

03/09/2025 9:58 PM: I realized that I would have to parse digits out of a string, so I need to do something about that. I think I am able to compare it directly to an ascii, but not entirely sure. There may also be a function already that I can call, so I will need to do research on this. For the stack, I will need to create the pop and push functions, which I am thinking of using car/cdr/cons for.

03/09/2025 10:07 PM: I just read the part in the project that says $n references array[n] value, so I will need to create a function that does this as well when I parse the string. I am thinking of creating an array[n] function that will use a provided index to find the value of that in the history. This project is looking harder and harder...

03/10/2025 4:42 PM: created prefix notation function that calculates based off of operator input + 2 number input. Thinking of using 2 stacks, digit_stack and operator_stack which will pop out the values and evaluate. Found some errors in the function and fixed them, misspelled values and wrote operator instead of operation. Testing the function by writing (apply_operation "+" 3 4) and returned 7, #t. Seems like it works.

03/10/2025 4:53 PM: Thinking of working on the parse string function now. This feels like it will be full of errors and very long......

03/10/2025 4:59 PM: Just looked at some useful functions from the project description and realized I could just do string->list. Will pivot from here.

03/10/2025 6:23 PM: Finished a process_char function that reads an input character and determines if it should convert to an index history value or return true. Tested the function using (process_char "$1") with constants put into history list and outputs are correct. Now need to move onto main function and I think Project should be over. 

03/10/2025 7:21 PM: created compute_prefix function that parses the string and then uses a stack to store digits, when an operator is encountered, it will pop off the last 2 digits inputted and compute the value. This result will then be appended to the history list. I will now go over requirements and make sure everything like edge cases work. 

03/10/2025 7:27 PM: So, I think I need to completely change my code since apparently whitespaces are irrelevant... We can write the expression as +12, and a whitespace is used to determine the number like +1 12.... I think I will have to write my own function to parse strings as I initially thought. This is looking harder and harder....

03/10/2025 7:31 PM: After a very very very quick online search :), it seems like I need to create a function called tokenize that will loop through the string and add the tokens to a token list. Pseudocode:
convert input string to list of characters and hold it in a list
initalize a list to stroke tokens
initialize a variable to store current token
loop through char list while it is not empty
    get first element of char list
    remove first element

    if first element is white space
        if current token is not empty
            add to current token
            reset current token
    else if first element is an operator
        if current is not empty
            append current to tokens list
        append first element to tokens list
        reset current token
    else
        set current to current + first element
I will start to implment this soon.

03/10/2025 8:24 PM: The implementation still requires whitespace, but it seems like everything else is in place. All I need to do is fix this tokenize function to skip whitespace and do the necessary stuff.

03/10/2025 8:34 PM: Ok, it seems like the description and examples are extremely convoluted... Are the inputs whitespaces? the example doesn't have it, but says it can. IDK anymore. There is also an example with backslashes??? This is not making any sense the more I read it. I will have to email professor about this. Also apprently this is in Haskell??? So much confusion.

03/10/2025 9:52 PM: I debugged. Decided that this will be the final iteration. The inputs are a bit convoluted but assuming the \$1 \$2 stuff is irrelevant, every case seems to work. I also decided to not email the prof and just go with what it is. 
Tested test cases:
> -3 10
1: -7.0
History: (-7)

> +$0 2
2: -5.0
History: (-7 -5)

> +$0$1
3: -12.0
History: (-7 -5 -12)

> + -3 10
4: 7.0
History: (-7 -5 -12 7)

These are the test cases that seem to be correct.
Some test cases that I am not too sure about, +12 => returns not enough operands, which makes sense since +12 is missing another number. I was not sure if this should have been evaluated as 1 + 2 based on the description in the proj. +$12 also returns not enough operands, which makes sense as 12 is not an available index.

03/28/2025 2:47 PM: Double checking everything. My batch mode code was not correct, it should have same functions as interactive. Changing code to do that. Tested anothe rtest case, / 1 0. Where division by 0. Encountered an error. Fixing this as well.

03/18/2025 3:06 PM: Submitted, then tested interactive to make sure everything was okay. Then realized that the code started adding #f to the history. Need to fix this now.