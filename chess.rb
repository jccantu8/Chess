require './chessPieces'
require './chessPlayers'

########################
#Confusingly, I have x and y coordinates backwards in the whole program.
#Note to self. Make sure piece cannot move to its same position
########################


class Game
    attr_accessor :board, :player1, :player2, :winner

    def initialize
        #The five spaces, '     ', will represent an empty chessboard square. This was chosen to aid in the printing process
        @board = Array.new(8) { Array.new(8, '     ')}
        @player1 = Player.new('White')
        @player2 = Player.new('Black')
        @winner = false
    end

    ROWS = {'A' => 0, 'B' => 1, 'C' => 2, 'D' => 3, 'E' => 4, 'F' => 5, 'G' => 6, 'H' => 7}
    
    def initialize_board
        @player1.pawn1.location = [6, 0]
        @player1.pawn2.location = [6, 1]
        @player1.pawn3.location = [6, 2]
        @player1.pawn4.location = [6, 3]
        @player1.pawn5.location = [6, 4]
        @player1.pawn6.location = [6, 5]
        @player1.pawn7.location = [6, 6]
        @player1.pawn8.location = [6, 7]

        @player1.rook1.location = [7, 0]
        @player1.knight1.location = [7, 1]
        @player1.bishop1.location = [7, 2]
        @player1.queen.location = [7, 3]
        @player1.king.location = [7, 4]
        @player1.bishop2.location = [7, 5]
        @player1.knight2.location = [7, 6]
        @player1.rook2.location = [7, 7]

        @player2.pawn1.location = [1, 0]
        @player2.pawn2.location = [1, 1]
        @player2.pawn3.location = [1, 2]
        @player2.pawn4.location = [1, 3]
        @player2.pawn5.location = [1, 4]
        @player2.pawn6.location = [1, 5]
        @player2.pawn7.location = [1, 6]
        @player2.pawn8.location = [1, 7]

        @player2.rook1.location = [0, 0]
        @player2.knight1.location = [0, 1]
        @player2.bishop1.location = [0, 2]
        @player2.king.location = [0, 3]
        @player2.queen.location = [0, 4]
        @player2.bishop2.location = [0, 5]
        @player2.knight2.location = [0, 6]
        @player2.rook2.location = [0, 7]

    end

    def update_board
        #Changes the chessboard square from empty to its respective piece
        for i in @player1.availablePieces
            board[i.location[0]][i.location[1]] = i.name
        end

        for j in @player2.availablePieces
            board[j.location[0]][j.location[1]] = j.name
        end
    end

    def display_board
        puts ' _______________________________________________'
        index = 0
        for i in @board
            puts '|     '*8 + '|'
            print '|'
            for j in i
                print "#{j}" + '|'
            end
            print " #{ROWS.key(index)}"
            index += 1
            puts
            puts '|_____'*8 + '|'
        end
        puts
        puts '   1     2     3     4     5     6     7     8'
        puts
    end

    def display_rules
        puts '-------------------------------------------------------'
        puts ' Take turns'
        puts '-------------------------------------------------------'
    end

    def play
        display_rules
        initialize_board
        update_board
        display_board
        currentPlayer = @player1
        otherPlayer = @player2

        while !@winner
            notChecked = false

            #This loop will only exit if the current player is not in check. 
            #It involves two parts: getting a valid move first followed by ensuring the current player is still not in check after the move.
            #To that end, copies of the original state of the board used so that if the player is still in check, everything will be reverted to the original checked state.
            until notChecked
                acceptChoice = false

                if is_checked?(board, currentPlayer, otherPlayer)
                    puts
                    puts '******'
                    puts 'Check!'
                    puts '******'
                end

                #This loop first gets a piece from the user then a destination to move the piece. Finally the piece and destination are checked if valid
                until acceptChoice
                    chosenPiece = choose_piece(currentPlayer)
                    #copy of the original location of the chosen piece
                    originalLocation = chosenPiece.location

                    chosenDestination = choose_Destination(chosenPiece)
                    #copy of the chosen destination's content, which could either be empty or contain a piece
                    chosenDestinationContent = board[chosenDestination[0]][chosenDestination[1]]

                    #Flag variable used to revert changes if a piece was eaten
                    pieceWasEaten = false

                    #If the chosen destination was not empty, Store a copy of the piece on the board
                    #It should be noted that if this piece is a piece on the same team, check move will handle that. So, the piece that this loop gets is effectively a piece that was on the other team.
                    if is_otherTeam?(chosenPiece, chosenDestination[0], chosenDestination[1])
                        for k in otherPlayer.availablePieces
                            if k.name == chosenDestinationContent
                                pieceThatWasEaten = k
                            end
                        end

                        pieceWasEaten = true
                    end

                    acceptChoice = check_move(board, chosenPiece, chosenDestination, currentPlayer, otherPlayer)
                end

                #Here it should update the board and checks if this new move ensures if the current player is not in check
                update_board

                if !is_checked?(board, currentPlayer, otherPlayer)
                    notChecked = true
                else
                    if pieceWasEaten
                        #board[chosenPiece.location[0]][chosenPiece.location[1]] = chosenDestinationContent
                        otherPlayer.availablePieces.push(pieceThatWasEaten)

                    else #Chosen destination was originally empty
                        board[chosenPiece.location[0]][chosenPiece.location[1]] = '     '
                    end

                    chosenPiece.location = originalLocation
                    update_board
                end
            end

            #Should the preceeding section work, the board should be updated
            @board = board
            update_board

            display_board

            #Swaps players
            if currentPlayer == @player1
                currentPlayer = @player2
                otherPlayer = @player1
            else
                currentPlayer = @player1
                otherPlayer = @player2
            end

            #@winner = true
        end
    end

    def is_checked?(board, currentPlayer, otherPlayer)

        #Cycles through the other players available pieces and checks if any of them can move to the king's location (i.e. puts (or keeps) the current player in check)
        for i in otherPlayer.availablePieces
            if check_move_for_check(board, i, currentPlayer.king.location)
                return true
            end
        end

        return false
        
    end

    #Straight forward but not very elegant. By getting the first letter of the color of piece currently being moved and comparing this letter with the destination,
    #it checks if the pieces are on different teams or on the same teams/(chessboard square is empty)
    def is_otherTeam?(chosenPiece, chosenDestinationXord, chosenDestinationYord)
        if (chosenPiece.name[0] == 'W') and (@board[chosenDestinationXord][chosenDestinationYord][0] == 'B')
            return true
        elsif (chosenPiece.name[0] == 'B') and (@board[chosenDestinationXord][chosenDestinationYord][0] == 'W')
            return true
        else
            return false
        end

    end

    #Helper function for #is_checked?
    #Checks if a piece can move to the king's location
    def check_move_for_check(board, piece, kingsLocation)

        kingsLocationXord = kingsLocation[0]
        kingsLocationYord = kingsLocation[1]

        if piece.rules(board, piece, kingsLocationXord, kingsLocationYord)
            return true
        else
            return false
        end
    end

    def check_move(board, chosenPiece, chosenDestination, currentPlayer, otherPlayer)

        chosenDestinationXord = chosenDestination[0]
        chosenDestinationYord = chosenDestination[1]

        #Checks if move abides by the rules
        if !chosenPiece.rules(board, chosenPiece, chosenDestinationXord, chosenDestinationYord)
            puts
            puts "This move in invalid. Please try again."
            puts
            return false
        else
            #Sets location where chosen piece was to empty
            board[chosenPiece.location[0]][chosenPiece.location[1]] = '     '

            #Check if chosen destination has a piece from the other team (i.e. eating a piece)
            if is_otherTeam?(chosenPiece, chosenDestinationXord, chosenDestinationYord)
                pieceToBeEaten = board[chosenDestinationXord][chosenDestinationYord]

                #Delete eaten piece from its respective @availablePieces
                for i in otherPlayer.availablePieces
                    if i.name == pieceToBeEaten
                        otherPlayer.availablePieces.delete(i)
                    end
                end
            end

            #Update new location of chosen piece
            chosenPiece.location = [chosenDestinationXord, chosenDestinationYord]
            return true
        end
    end

    def choose_Destination(chosenPiece)
        puts
        puts "Where would you like to Destination #{chosenPiece.name} to? Please pick a letter followed by a number. (e.g. B7)"

        acceptableDestination = false

        until acceptableDestination
            chosenDestination = gets.chomp

            #Ensure destination is valid
            if chosenDestination.match?(/^[A-Ha-h][1-8]$/)
                acceptableDestination = true
            end

            if !acceptableDestination
                puts
                puts "Not an acceptable choice, please try again."
                puts "Type B7 or a1, for example."
            end
        end

        #Converts destination to board indices
        chosenDestination = [ROWS[chosenDestination[0].upcase], chosenDestination[1].to_i - 1]

        return chosenDestination
    end

    def choose_piece(player)
        puts "*************************************************"
        puts "#{player.playerColor}'s turn.".capitalize
        puts
        puts "Available pieces:"
        puts
        for i in player.availablePieces
            print i.name + '  '
        end
        puts
        puts "*************************************************"
        puts
        puts "Type Pa#, Ro#, Kn#, Bi#, Ki, or Qu to select that particular piece, if available."

        acceptablePiece = false

        #Ensures user input is a valid piece on the board and returns said piece
        until acceptablePiece
            choice = gets.chomp

            if (choice).match?(/^[QqKk][IiUu]$/)
                choice += ' '
            end
            
            for i in player.availablePieces
                if i.name == player.playerColor[0] + '-' + choice.capitalize
                    chosenPiece = i
                    acceptablePiece = true
                end
            end
            
            if !acceptablePiece
                puts
                puts "Not an available choice, please try again."
                puts "Type Pa#, Ro#, Kn#, Bi#, Ki, or Qu to select that particular piece, if available."
            end
        end

        return chosenPiece
    end

end

test = Game.new
test.play