/* Robot
 * Author: Ravidu
 * Creation date: 12/12/2020
 */
MACHINE
    //Initialize the machine for Robot
    Robot

SEES Maze

VARIABLES
    //Declare the variables for robot
    
    robot_X_position, robot_Y_position,
    robot_visited_path
    
INVARIANT
    robot_X_position : NATURAL1 & robot_Y_position : NATURAL1 &
    robot_visited_path : seq (maze_x_pos * maze_y_pos)

INITIALISATION
    robot_X_position, robot_Y_position, robot_visited_path := 1, 1, []
    
DEFINITIONS 
    //Functions used to create the animation
    
    ANIMATION_FUNCTION == ({ row, col, img | col:1..7 & row:1..5 & img=0 });
    ANIMATION_FUNCTION1 == ({ row, col, img | col:1..7 & row:1..5  & img=1 & (col, 6-row) : wall });
    ANIMATION_FUNCTION2 == ({ row, col, img | col:1..7 & row:1..5 & img=2 & col=robot_X_position & row=(6-robot_Y_position) });
    
    // Images for animations
    ANIMATION_IMG0 == "images/cell.gif";
    ANIMATION_IMG1 == "images/wall.gif";
    ANIMATION_IMG2 == "images/robot.gif";
    
OPERATIONS
    
    //Move to North
    //validate and assign the results to result
    
    message <-- move_north = 
        BEGIN
            IF
                (robot_Y_position + 1 :maze_y_pos)
            THEN
                IF
                  (robot_X_position |-> (robot_Y_position + 1 ) /: wall)
                THEN
                    
                  robot_visited_path, robot_Y_position := robot_visited_path <- (robot_X_position, robot_Y_position), robot_Y_position + 1 ||
                  message := MovedNorth
                  
                ELSE
                 message := CannotMove_Wall_Detected
                END
           ELSE
               message := CannotMove_Out_of_Maze
           END
       END;
         
      //Move to Robot to South 
    //validate and assign the results to result
    message <-- move_south =
        BEGIN
            IF
                (robot_Y_position - 1 : maze_y_pos)
            THEN
                IF
                    (robot_X_position |-> (robot_Y_position - 1) /: wall)
                THEN
                    robot_visited_path, robot_Y_position := robot_visited_path <- (robot_X_position, robot_Y_position), robot_Y_position - 1 ||
                    message := MovedSouth
                ELSE
                    message := CannotMove_Wall_Detected
                END
            ELSE
                message := CannotMove_Out_of_Maze
            END
        END; 
        
         //Move to Robot to East 
        //validate and assign the results to result
    message <-- move_east =
        BEGIN
            IF
                (robot_X_position + 1 : maze_x_pos)
            THEN
                IF
                    ((robot_X_position + 1) |-> robot_Y_position /: wall)
                THEN
                    robot_visited_path, robot_X_position := robot_visited_path <- (robot_X_position, robot_Y_position), robot_X_position + 1 ||
                    message := MovedEast
                ELSE
                    message := CannotMove_Wall_Detected
                END
            ELSE
                message := CannotMove_Out_of_Maze
            END
        END;
        
        //Move to Robot to West 
        // validate and assign the results to result
    message <-- move_west =
        BEGIN
            IF
                (robot_X_position - 1 : maze_x_pos)
            THEN
                IF
                    ((robot_X_position - 1) |-> robot_Y_position /: wall)
                THEN
                    robot_visited_path, robot_X_position := robot_visited_path <- (robot_X_position, robot_Y_position), robot_X_position - 1 ||
                    message := MovedWest
                ELSE
                    message := CannotMove_Wall_Detected
                END
            ELSE
                message := CannotMove_Out_of_Maze
            END
        END ;
        
      //Teleport Operations
      
      message <-- teleport (x_position, y_position) = 
      
      PRE
          x_position : NATURAL1 &
          y_position : NATURAL1 &
          
          (x_position |-> y_position) /= (robot_X_position |-> robot_Y_position)
      THEN
          
          //Prevent the immediate teleport to exit position
          
          IF
              ( (x_position |-> y_position ) = exit_pos &
                  size(robot_visited_path) = 0)
          THEN
              message := Cannot_Immediate_Teleport_to_Exit
          ELSE
              IF
                  (x_position |-> y_position /: wall)
              THEN
                  IF
                      (x_position : maze_x_pos & y_position : maze_y_pos)
                  THEN
                      robot_X_position, robot_Y_position, robot_visited_path := x_position, y_position, robot_visited_path <- (robot_X_position, robot_Y_position) ||
                        message := Teleported
                  ELSE
                      message := CannotMove_Out_of_Maze
                  END
              ELSE
                  message := CannotMove_Wall_Detected
              END
           END
       END;
     
     
     //Operation to Get the robot's current position
     
      answer <-- get_position =
     
      BEGIN
          answer := robot_X_position |-> robot_Y_position
      END;
      
     //Operation to check whether Robot has met with exit point or not
     
     answer <-- found_exit =
     BEGIN
         
         //check the current position equals to (1,5) 
         
         IF
             ((robot_X_position |-> robot_Y_position) = exit_pos)
         THEN
             
             answer := Yes
         ELSE
             answer := No
         END
      END;
          
         
    //Track the visited Squares in the maze
    answer <-- hasVisitedSquare(x_position, y_position) =
     PRE
         x_position : maze_x_pos &
         y_position : maze_y_pos
     THEN
        IF
            ((x_position |-> y_position) : ran(robot_visited_path))
         THEN
         
             answer := Yes
         ELSE
             answer := No
         END
     END;
     
    //Operation to check robots visited paths
    answer <-- robots_route =
        BEGIN
            answer := robot_visited_path 
        END    
         
     
      
      
END
