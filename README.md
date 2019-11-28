# Chess

## knightTravails

    This program serves as a bit of a helper for chess in that it involves finding the shortest (or one of the shortest) paths for a knight between a starting position and ending position on a chess board.

    Each position is treated as a node with up to, but not necessarily including, 8 children which represent the available moves the knight may take.

    To find the path, a breadth search is performed by utilizing a queue where after checking each child of a node, if it is not our ending position, then all of its children will be added to the queue.

    The board function(s) are not yet completed, but are not essential to the crux of the problem.