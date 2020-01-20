#Assigns names to each piece in the form: first letter of the team's color followed by a hypen then the first two letters of the piece
#If the piece is not a king or queen it will then be followed by a number, else a space will be used instead. This helps when printing
def assign_name(team, typeOfPiece, pieceNumber = ' ')
    if team == 'White'
        return "W-" + typeOfPiece + "#{pieceNumber}"
    else
        return "B-" + typeOfPiece + "#{pieceNumber}"
    end
end

def is_empty?(board, chosenDestinationXord, chosenDestinationYord)
    #Empty spaces on the board are represented with 5 spaces
    if board[chosenDestinationXord][chosenDestinationYord] == '     '
        return true
    else 
        return false
    end
end

def is_sameTeam?(board, chosenPiece, chosenDestinationXord, chosenDestinationYord)
    #Checks if first letter of team color is the same. (e.g. 'W' for "White")
    if board[chosenDestinationXord][chosenDestinationYord][0] == chosenPiece.team[0]
        return true
    else 
        return false
    end
end

##################
#In all of these pieces, except the pawn, the chosen destination is only checked if it contains a piece of the same team.
#Otherwise, it either contains nothing (empty) or has a piece from the other team. Regardless, our piece can move there.
#The function #check_move handles eating a piece
#
#Returning false means the move is not valid
##################

class Knight
    attr_accessor :name, :location, :team

    def initialize(team, pieceNumber)
        @team = team
        @pieceNumber = pieceNumber
        @name = assign_name(@team, 'Kn', @pieceNumber)
        @location = nil
    end

    def rules(board, chosenPiece, chosenDestinationXord, chosenDestinationYord)

        #Check if destination is an 'L' shaped one. There are 8 maximum possible moves, which these loops check.
        for n in [-1, 1]
            for m in [-1, 1]
        
                if (chosenDestinationXord == chosenPiece.location[0] - (1 * n) and chosenDestinationYord == chosenPiece.location[1] + (2 * m))
                    #Check if destination contains piece on the same team
                    if is_sameTeam?(board, chosenPiece, chosenDestinationXord, chosenDestinationYord)
                        return false
                    else
                        return true
                    end
                elsif (chosenDestinationXord == chosenPiece.location[0] - (2 * n) and chosenDestinationYord == chosenPiece.location[1] + (1 * m))
                    if is_sameTeam?(board, chosenPiece, chosenDestinationXord, chosenDestinationYord)
                        return false
                    else
                        return true
                    end
                end
            end
        end

        #If destination not was not found above, it can't be valid.
        return false
        
    end
    
end

class Pawn
    attr_accessor :name, :location, :team, :hasNotMovedYet

    def initialize(team, pieceNumber)
        @team = team
        @pieceNumber = pieceNumber
        @name = assign_name(@team, 'Pa', @pieceNumber)
        @location = nil
        
        #Used in determining whether pawn can move two spaces ahead
        @hasNotMovedYet = true
    end

    def rules(board, chosenPiece, chosenDestinationXord, chosenDestinationYord)

        #Since black is at the top of the board and white is on the bottom, check the team and use a variable to change the direction of the move (up or down)
        if chosenPiece.team == 'White'
            k = 1
        else 
            k = -1
        end

        #Checks if pawn is moving once diagonally and if the space is empty or containing a piece of the same team
        if (chosenDestinationXord == chosenPiece.location[0] - (1 * k)) and (chosenDestinationYord == chosenPiece.location[1] + 1 or chosenDestinationYord == chosenPiece.location[1] - 1)
            if is_sameTeam?(board, chosenPiece, chosenDestinationXord, chosenDestinationYord) or is_empty?(board, chosenDestinationXord, chosenDestinationYord)
                return false
            else
                chosenPiece.hasNotMovedYet = false
                return true
            end
        end

        #Checks if pawn is moving one space ahead
        if chosenDestinationXord == chosenPiece.location[0] - (1 * k) and chosenDestinationYord == chosenPiece.location[1]
            #Check if destination is empty
            if is_empty?(board, chosenDestinationXord, chosenDestinationYord)
                chosenPiece.hasNotMovedYet = false
                return true
            else
                return false
            end
        elsif chosenDestinationXord == chosenPiece.location[0] - (2 * k) and chosenPiece.hasNotMovedYet == true and chosenDestinationYord == chosenPiece.location[1]
            #Check if destination and space before is empty
            if is_empty?(board, chosenDestinationXord, chosenDestinationYord) and is_empty?(board, chosenDestinationXord + (1 * k), chosenDestinationYord)
                chosenPiece.hasNotMovedYet = false
                return true
            else
                return false
            end
        else
            return false
        end
    end

end

class Rook
    attr_accessor :name, :location, :team

    def initialize(team, pieceNumber)
        @team = team
        @pieceNumber = pieceNumber
        @name = assign_name(@team, 'Ro', @pieceNumber)
        @location = nil
    end

    def rules(board, chosenPiece, chosenDestinationXord, chosenDestinationYord)

        if is_sameTeam?(board, chosenPiece, chosenDestinationXord, chosenDestinationYord)
            return false
        end

        #Checks if rook is moving horizontally
        if chosenDestinationXord == chosenPiece.location[0]
            #Moving right
            if chosenDestinationYord > chosenPiece.location[1]
                #checks if every space upto (and not including) the chosen destination is empty
                for i in ((chosenPiece.location[1] + 1)..(chosenDestinationYord - 1))
                    if !is_empty?(board, chosenDestinationXord, i)
                        return false
                    end  
                end

                return true
            #Moving left
            elsif chosenDestinationYord < chosenPiece.location[1]
                #checks if every space upto (and not including) the chosen destination is empty
                for i in ((chosenDestinationYord + 1)...chosenPiece.location[1])
                    if !is_empty?(board, chosenDestinationXord, i)
                        return false
                    end
                end

                return true
            else
                return false
            end

        #Checks if rook is moving vertically    
        elsif chosenDestinationYord == chosenPiece.location[1]
            #Moving up
            if chosenDestinationXord > chosenPiece.location[0]
                #checks if every space upto (and not including) the chosen destination is empty
                for i in ((chosenPiece.location[0] + 1)..(chosenDestinationXord - 1))
                    if !is_empty?(board, i, chosenDestinationYord)
                        return false
                    end
                end

                return true
            #Moving down
            elsif chosenDestinationXord < chosenPiece.location[0]
                #checks if every space upto (and not including) the chosen destination is empty
                for i in ((chosenDestinationXord + 1)...chosenPiece.location[0])
                    if !is_empty?(board, i, chosenDestinationYord)
                        return false
                    end
                end

                return true
            else
                return false
            end
        else
            return false
        end
    end

end

class Bishop
    attr_accessor :name, :location, :team

    def initialize(team, pieceNumber)
        @team = team
        @pieceNumber = pieceNumber
        @name = assign_name(@team, 'Bi', @pieceNumber)
        @location = nil
    end

    def rules(board, chosenPiece, chosenDestinationXord, chosenDestinationYord)
        if is_sameTeam?(board, chosenPiece, chosenDestinationXord, chosenDestinationYord)
            return false
        end

        #Calculates the change in y and the change in x coordinates to be used in calculating the slope of a line.
        #This is because a bishop can only move in a line of slope 1 or -1
        deltaY = (chosenDestinationXord - chosenPiece.location[0]).to_f
        deltaX = (chosenDestinationYord - chosenPiece.location[1]).to_f

        #Don't divide by 0 and make sure slope is 1 or -1
        if (deltaX == 0.0) or ((deltaY / deltaX).abs != 1.0)
            return false
        end

        #Bishop is moving up and right
        if (chosenDestinationXord > chosenPiece.location[0]) and (chosenDestinationYord > chosenPiece.location[1])
            xord = chosenPiece.location[0]
            yord = chosenPiece.location[1]

            #checks if every space upto (and not including) the chosen destination is empty
            until (xord == chosenDestinationXord - 1) and (yord == chosenDestinationYord - 1)
                xord += 1
                yord += 1

                if !is_empty?(board, xord, yord)
                    return false
                end
            end

            return true

        #Bishop is moving down and right
        elsif (chosenDestinationXord > chosenPiece.location[0]) and (chosenDestinationYord < chosenPiece.location[1])
            xord = chosenPiece.location[0]
            yord = chosenPiece.location[1]

            #checks if every space upto (and not including) the chosen destination is empty
            until (xord == chosenDestinationXord - 1) and (yord == chosenDestinationYord + 1)
                xord += 1
                yord -= 1

                if !is_empty?(board, xord, yord)
                    return false
                end
            end

            return true

        #Bishop is moving up and left
        elsif (chosenDestinationXord < chosenPiece.location[0]) and (chosenDestinationYord > chosenPiece.location[1])
            xord = chosenPiece.location[0]
            yord = chosenPiece.location[1]


            #checks if every space upto (and not including) the chosen destination is empty
            until (xord == chosenDestinationXord + 1) and (yord == chosenDestinationYord - 1)
                xord -= 1
                yord += 1

                if !is_empty?(board, xord, yord)
                    return false
                end
            end

            return true

        #Bishop is moving down and left
        elsif (chosenDestinationXord < chosenPiece.location[0]) and (chosenDestinationYord < chosenPiece.location[1])
            xord = chosenPiece.location[0]
            yord = chosenPiece.location[1]

            #checks if every space upto (and not including) the chosen destination is empty
            until (xord == chosenDestinationXord + 1) and (yord == chosenDestinationYord + 1)
                xord -= 1
                yord -= 1

                if !is_empty?(board, xord, yord)
                    return false
                end
            end

            return true

        else
            return false
        end
        
    end

end

class Queen
    attr_accessor :name, :location, :team

    def initialize(team)
        @team = team
        @name = assign_name(@team, 'Qu')
        @location = nil
    end

    def rules(board, chosenPiece, chosenDestinationXord, chosenDestinationYord)
        if is_sameTeam?(board, chosenPiece, chosenDestinationXord, chosenDestinationYord)
            return false
        end

        #The queen is really a combination of the rook and bishop, so please refer to those if necessary
        #Checks vertically and horizontally first, then diagonally

        if chosenDestinationXord == chosenPiece.location[0]
            if chosenDestinationYord > chosenPiece.location[1]
                for i in ((chosenPiece.location[1] + 1)..(chosenDestinationYord - 1))
                    if !is_empty?(board, chosenDestinationXord, i)
                        return false
                    end  
                end

                return true
            elsif chosenDestinationYord < chosenPiece.location[1]
                for i in ((chosenDestinationYord + 1)...chosenPiece.location[1])
                    if !is_empty?(board, chosenDestinationXord, i)
                        return false
                    end
                end

                return true
            else
                return false
            end

        elsif chosenDestinationYord == chosenPiece.location[1]
            if chosenDestinationXord > chosenPiece.location[0]
                for i in ((chosenPiece.location[0] + 1)..(chosenDestinationXord - 1))
                    if !is_empty?(board, i, chosenDestinationYord)
                        return false
                    end
                end

                return true
            elsif chosenDestinationXord < chosenPiece.location[0]
                for i in ((chosenDestinationXord + 1)...chosenPiece.location[0])
                    if !is_empty?(board, i, chosenDestinationYord)
                        return false
                    end
                end

                return true
            else
                return false
            end
        else
            
            deltaY = chosenDestinationXord - chosenPiece.location[0]
            deltaX = chosenDestinationYord - chosenPiece.location[1]

            if (deltaX == 0) or ((deltaY / deltaX).abs != 1)
                return false
            end

            if (chosenDestinationXord > chosenPiece.location[0]) and (chosenDestinationYord > chosenPiece.location[1])
                xord = chosenPiece.location[0]
                yord = chosenPiece.location[1]

                until (xord == chosenDestinationXord - 1) and (yord == chosenDestinationYord - 1)
                    xord += 1
                    yord += 1

                    if !is_empty?(board, xord, yord)
                        return false
                    end
                end

                return true

            elsif (chosenDestinationXord > chosenPiece.location[0]) and (chosenDestinationYord < chosenPiece.location[1])
                xord = chosenPiece.location[0]
                yord = chosenPiece.location[1]

                until (xord == chosenDestinationXord - 1) and (yord == chosenDestinationYord + 1)
                    xord += 1
                    yord -= 1

                    if !is_empty?(board, xord, yord)
                        return false
                    end
                end

                return true

            elsif (chosenDestinationXord < chosenPiece.location[0]) and (chosenDestinationYord > chosenPiece.location[1])
                xord = chosenPiece.location[0]
                yord = chosenPiece.location[1]

                until (xord == chosenDestinationXord + 1) and (yord == chosenDestinationYord - 1)
                    xord -= 1
                    yord += 1

                    if !is_empty?(board, xord, yord)
                        return false
                    end
                end

                return true

            elsif (chosenDestinationXord < chosenPiece.location[0]) and (chosenDestinationYord < chosenPiece.location[1])
                xord = chosenPiece.location[0]
                yord = chosenPiece.location[1]

                until (xord == chosenDestinationXord + 1) and (yord == chosenDestinationYord + 1)
                    xord -= 1
                    yord -= 1

                    if !is_empty?(board, xord, yord)
                        return false
                    end
                end

                return true

            else
                return false
            end
        end

    end

end

class King
    attr_accessor :name, :location, :team

    def initialize(team)
        @team = team
        @name = assign_name(@team, 'Ki')
        @location = nil
    end

    def rules(board, chosenPiece, chosenDestinationXord, chosenDestinationYord)
        if is_sameTeam?(board, chosenPiece, chosenDestinationXord, chosenDestinationYord)
            return false
        end

        #Checks if moving once vertically or horizontally
        for k in [-1, 1]
            if (chosenDestinationXord == chosenPiece.location[0] + k) and (chosenDestinationYord == chosenPiece.location[1])
                return true
            elsif (chosenDestinationXord == chosenPiece.location[0]) and (chosenDestinationYord == chosenPiece.location[1] + k)
                return true
            end
        end

        #Checks if moving once diagonally
        for m in [-1, 1]
            for n in [-1, 1]
                if (chosenDestinationXord == chosenPiece.location[0] + m) and (chosenDestinationYord == chosenPiece.location[1] + n)
                    return true
                end
            end
        end

        return false

    end

end