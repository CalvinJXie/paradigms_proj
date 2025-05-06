05/01/2025 11:43 AM: Added sample files to understand what is required by the project.

05/01/2025 12:17 PM: Initial thoughts. Need to find a path using directions left, right, up, down from a starting point s, to an exit point e. Can not move if there is a w infront of it, can move if it says f. I think for the main predicate, it will have to define a list of actions given a maze and find a given path based off of the actions, then verify whether this path works.

05/01/2025 12:37 PM: Some predicates that are needed. 
Maze information like dimensions and start/exit positions
Get the cell information. What type of cell it is (wall/floor/Start/Exit)
Validate the move. Check if it is possible to move in a direction. Ex: cant move into a wall
Find a path, and follow a path.

05/01/2025 2:03 PM: Drafted some potential functions to use/call:
find_start() - it will loop through each the array that the maze is in and find "s" the starting point.
get_cell() - will get the current cell to determine if it is a valid cell to move or not
is_valid() - will be used after get cell to validate the cell or validate a move
solve_maze() - will solve the maze. Thinking of a dfs method

05/06/2025 12:52 PM: I did not log what I did over the weekend, but some stuff I encountered while writing the project:
Installing swi-prolog took a bit of time for mac, so in the end I just brew installed and everything worked.
Besides installing, and the usual syntax errors, writing my functions took a bit of time as I was learning a new language. I added some new functions
find_exit()
separated is_valid function into 2 different validation checks
added a checking function follow_path to make sure that the path is correct
I also had issues when running my program, knowing which syntax to use to call my predicate function, and ensuring that my arguments were the right size.
I also had some issues when implementing recursion into the logic. I had many errors there and it took a significant amount of time to fix it.

When testing the final version part 1, the solution to the mazes were wrong. So I had to debug and fix those errors as well.

Debugging was not too bad since there was a trace. command I could run and run through every step in the logic. And when I debugged, I realized that the reason I was getting the wrong solution, was because the display from generated graphs was messed up and did not display the correct data. 

The predicate functions were actually receiving the right data, but when visually displayed the start and end were not correctly placed, which lead to me bugging out and trying to solve the issue in the code, when it was just a visual bug.

Then I realized I was wrong, and my logic actually had issues, so I had to debug it.

Then I tried debuging, and everything seemed fine with my logic. And I realized that it was because prolog truncated my solution so it was taking out some parts of the answer in the list for example:
A = [down, left, left, up, up, left, down, left, down|...] 
where |...] truncated my answer response.

I fixed this after a long time of debugging and project was finished.
