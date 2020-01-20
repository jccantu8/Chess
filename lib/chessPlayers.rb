class Player
    attr_accessor :color, :pawn1, :pawn2, :pawn3, :pawn4, :pawn5, :pawn6, :pawn7, :pawn8,
                    :rook1, :rook2, :bishop1, :bishop2, :knight1, :knight2, :king, :queen,
                    :availablePieces, :playerColor

    def initialize(color)
        @playerColor = color
        @pawn1 = Pawn.new(@playerColor, 1)
        @pawn2 = Pawn.new(@playerColor, 2)
        @pawn3 = Pawn.new(@playerColor, 3)
        @pawn4 = Pawn.new(@playerColor, 4)
        @pawn5 = Pawn.new(@playerColor, 5)
        @pawn6 = Pawn.new(@playerColor, 6)
        @pawn7 = Pawn.new(@playerColor, 7)
        @pawn8 = Pawn.new(@playerColor, 8)
        @rook1 = Rook.new(@playerColor, 1)
        @rook2 = Rook.new(@playerColor, 2)
        @knight1 = Knight.new(@playerColor, 1)
        @knight2 = Knight.new(@playerColor, 2)
        @bishop1 = Bishop.new(@playerColor, 1)
        @bishop2 = Bishop.new(@playerColor, 2)
        @king = King.new(@playerColor)
        @queen = Queen.new(@playerColor)

        @availablePieces = [@pawn1, @pawn2, @pawn3, @pawn4, @pawn5, @pawn6, @pawn7, @pawn8,
                            @knight1, @knight2, @rook1, @rook2, @bishop1, @bishop2, @queen,
                            @king]
    end

end