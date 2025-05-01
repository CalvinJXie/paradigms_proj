05/01/2025 11:43 AM: Added sample files to understand what is required by the project.

05/01/2025 12:17 PM: Initial thoughts. Need to find a path using directions left, right, up, down from a starting point s, to an exit point e. Can not move if there is a w infront of it, can move if it says f. I think for the main predicate, it will have to define a list of actions given a maze and find a given path based off of the actions, then verify whether this path works.

05/01/2025 12:37 PM: Some predicates that are needed. 
Maze information like dimensions and start/exit positions
Get the cell information. What type of cell it is (wall/floor/Start/Exit)
Validate the move. Check if it is possible to move in a direction. Ex: cant move into a wall
Find a path, and follow a path.
