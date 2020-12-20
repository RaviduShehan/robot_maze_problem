/* Maze
 * Author: Ravidu
 * Creation date: 12/12/2020
 */
MACHINE
    Maze
    //define the machine for Maze
    
SETS
    MESSAGES = {CannotMove_Wall_Detected, CannotMove_Out_of_Maze,Teleported, Cannot_Immediate_Teleport_to_Exit, MovedNorth, MovedSouth, MovedEast, MovedWest };
    RESPONSES = {Yes, No }
    
CONSTANTS
    height, width, maze_x_pos, maze_y_pos, wall, exit_pos
    
PROPERTIES
    height = 5 & width =7 & maze_x_pos = 1..width & maze_y_pos = 1..height & exit_pos =(1|-> 5) & wall : maze_x_pos <-> maze_y_pos &
    wall = {(1 |-> 3), (2 |-> 1),(2 |-> 3), (2 |-> 5), (3 |-> 3) , (4 |-> 2), (4 |-> 3),(4 |-> 4),(6 |-> 1), (6 |-> 2),(6 |-> 4), (7 |-> 4) }
    
    

END
