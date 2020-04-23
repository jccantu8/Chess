require './chessPieces'
require './chessPlayers'
require './chessBoardSquare'

class Game
    attr_accessor :board, :player1, :player2, :winner

    def initialize
        @board = Array.new(8) { Array.new(8, BoardSquare.new)}
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

    def update_board(board, firstPlayer, secondPlayer)
        for i in firstPlayer.availablePieces
            board[i.location[0]][i.location[1]].piece = i
            board[i.location[0]][i.location[1]].name = i.name
        end

        for j in secondPlayer.availablePieces
            board[j.location[0]][j.location[1]].piece = j
            board[j.location[0]][j.location[1]].name = j.name
        end
    end

    def display_board
        puts ' _______________________________________________'
        index = 0
        for i in @board
            puts '|     '*8 + '|'
            print '|'
            for j in i
                print "#{j.name}" + '|'
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
        update_board(@board, @player1, @player2)
        display_board

    end

end

test = Game.new
test.play