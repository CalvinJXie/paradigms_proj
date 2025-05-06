% find_exit(Maze, Actions)
% Succeeds if following the list of Actions from the start space in Maze
% leads to an exit space.
% If Actions is unbound, it finds a list of actions that solves the maze.
% Fails if the maze is invalid, the path is invalid, or the path doesn't end in an exit.
find_exit(Maze, Actions) :-
    % Validate the maze: must have exactly one start ('s').
    count_starts(Maze, Count),
    Count = 1,

    % Get maze dimensions
    maze_dims(Maze, Rows, Cols),

    % Find the start position
    find_start(Maze, StartRow, StartCol),
    StartPos = pos(StartRow, StartCol),

    % Check if Actions is ground (provided path) or unbound (needs finding)
    (   ground(Actions) ->
        % Actions are provided, follow the path
        follow_path(Maze, Rows, Cols, StartPos, Actions)
    ;   % Actions are unbound, find a path
        % Use solve_maze to find a path (Actions) from StartPos to an exit
        % Keep track of visited positions to avoid infinite loops
        solve_maze(Maze, Rows, Cols, StartPos, [StartPos], Actions)
    ).

% maze_dims(Maze, Rows, Cols)
% Determines the number of Rows and Columns in the Maze.
maze_dims(Maze, Rows, Cols) :-
    length(Maze, Rows),
    Maze = [Row|_],
    length(Row, Cols).

% find_start(Maze, StartRow, StartCol)
% Finds the row and column of the start position 's'.
find_start(Maze, StartRow, StartCol) :-
    nth0(StartRow, Maze, Row),
    nth0(StartCol, Row, s).

% find_exit_pos(Maze, ExitRow, ExitCol)
% Finds the row and column of an exit position 'e'.
% Can backtrack to find all exits if needed.
find_exit_pos(Maze, ExitRow, ExitCol) :-
    nth0(ExitRow, Maze, Row),
    nth0(ExitCol, Row, e).

% get_cell(Maze, Pos, CellType)
% Gets the type of the cell at a given Pos (pos(Row, Col)).
get_cell(Maze, pos(Row, Col), CellType) :-
    nth0(Row, Maze, MazeRow),
    nth0(Col, MazeRow, CellType).

% is_valid_pos(Rows, Cols, Pos)
% Checks if a position Pos (pos(Row, Col)) is within the maze boundaries.
is_valid_pos(Rows, Cols, pos(Row, Col)) :-
    Row >= 0, Row < Rows,
    Col >= 0, Col < Cols.

% is_valid_move(Maze, Rows, Cols, CurrentPos, Action, NewPos)
% Checks if performing Action from CurrentPos results in a valid NewPos
% (within bounds and not a wall). Unifies NewPos if valid.
is_valid_move(Maze, Rows, Cols, pos(R, C), up, pos(NR, C)) :-
    NR is R - 1,
    is_valid_pos(Rows, Cols, pos(NR, C)),
    get_cell(Maze, pos(NR, C), Cell),
    Cell \= w.
is_valid_move(Maze, Rows, Cols, pos(R, C), down, pos(NR, C)) :-
    NR is R + 1,
    is_valid_pos(Rows, Cols, pos(NR, C)),
    get_cell(Maze, pos(NR, C), Cell),
    Cell \= w.
is_valid_move(Maze, Rows, Cols, pos(R, C), left, pos(R, NC)) :-
    NC is C - 1,
    is_valid_pos(Rows, Cols, pos(R, NC)),
    get_cell(Maze, pos(R, NC), Cell),
    Cell \= w.
is_valid_move(Maze, Rows, Cols, pos(R, C), right, pos(R, NC)) :-
    NC is C + 1,
    is_valid_pos(Rows, Cols, pos(R, NC)),
    get_cell(Maze, pos(R, NC), Cell),
    Cell \= w.

% follow_path(Maze, Rows, Cols, CurrentPos, Actions)
% Helper predicate to follow a given list of Actions from CurrentPos.
% Succeeds if the final position is an exit.
follow_path(Maze, _, _, CurrentPos, []) :-
    % Base case: No more actions, check if the current position is an exit
    get_cell(Maze, CurrentPos, e).
follow_path(Maze, Rows, Cols, CurrentPos, [Action|RestActions]) :-
    % Recursive step: Perform the current Action
    is_valid_move(Maze, Rows, Cols, CurrentPos, Action, NewPos),
    % Continue following the rest of the actions from the NewPos
    follow_path(Maze, Rows, Cols, NewPos, RestActions).

% solve_maze(Maze, Rows, Cols, CurrentPos, Visited, Actions)
% Finds a list of Actions to get from CurrentPos to an exit.
% Visited is a list of positions already visited in this path to prevent cycles.
solve_maze(Maze, Rows, Cols, CurrentPos, Visited, [Action|RestActions]) :-
    % Try each possible action
    (   Action = up
    ;   Action = down
    ;   Action = left
    ;   Action = right
    ),
    % Calculate the new position
    is_valid_move(Maze, Rows, Cols, CurrentPos, Action, NewPos),
    % Check if the new position has not been visited in this path
    \+ member(NewPos, Visited),
    % Recursively call solve_maze from the NewPos, adding it to Visited
    solve_maze(Maze, Rows, Cols, NewPos, [NewPos|Visited], RestActions).

% Base case for solve_maze: reached an exit
solve_maze(Maze, _, _, CurrentPos, _, []) :-
    get_cell(Maze, CurrentPos, e).

% count_starts(Maze, Count)
% Counts the number of 's' cells in the maze.
count_starts(Maze, Count) :-
    flatten(Maze, Cells), % Flatten the list of lists into a single list
    include(=(s), Cells, Starts), % Filter for 's' cells
    length(Starts, Count). % Count the number of 's' cells

% print_actions(Actions)
% Prints each action in the list on a new line.
print_actions([]).
print_actions([Action|Rest]) :-
    writeln(Action),
    print_actions(Rest).

