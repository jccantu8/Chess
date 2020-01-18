require './chessPieces'

describe '#assign_name' do
    it 'returns W-Pa1' do
        name = assign_name('White', 'Pa', 1)
        expect(name).to eq('W-Pa1')
    end

    it 'returns B-Ki' do
        name = assign_name('Black', 'Ki')
        expect(name).to eq('B-Ki ')
    end
end

#Using a 1x1 array of array for the board here
describe '#is_empty?' do
    it 'returns true if space on board is empty' do
        board = [['     ']]
        expect(is_empty?(board, 0, 0)).to be_truthy
    end

    it 'returns false if space on board is NOT empty' do
        board = [['W-Pa1']]
        expect(is_empty?(board, 0, 0)).to be_falsey
    end
end

describe '#is_sameTeam?' do
    it 'returns true if space on board has a piece on the same team' do
        board = [['W-Pa1']]
        expect(is_sameTeam?(board, Pawn.new('White', 1), 0, 0)).to be_truthy
    end

    it 'returns false if space on board has a piece on the other team' do
        board = [['B-Kn2']]
        expect(is_sameTeam?(board, Pawn.new('White', 1), 0, 0)).to be_falsey
    end

    it 'returns false if space on board is empty' do
        board = [['     ']]
        expect(is_sameTeam?(board, Pawn.new('White', 1), 0, 0)).to be_falsey
    end
end

describe Knight do
    before(:each) {@board = Array.new(8) { Array.new(8, '     ')}
                    @testKnight = Knight.new('White', 1)
                    @testKnight.location = [5, 5]
                    @board[@testKnight.location[0]][@testKnight.location[1]] = @testKnight.name}

    describe '#rules' do
        it 'returns true if knight moves up two spaces and one to the right, but only if space does not contain another piece of the same team' do
            expect(@testKnight.rules(@board, @testKnight, 7, 6)).to be_truthy
        end

        it 'returns true if knight moves down one space and two to the left, but only if space does not contain another piece of the same team' do
            expect(@testKnight.rules(@board, @testKnight, 3, 4)).to be_truthy
        end

        it 'returns false if knight tries to move to a space not on the board' do
            expect(@testKnight.rules(@board, @testKnight, 10, 10)).to be_falsey
        end

        it 'returns false if knight moves to a valid space, but the space has a piece on its own team' do
            otherteamTestPiece = Pawn.new('White', 1)
            otherteamTestPiece.location = [7, 6]
            @board[otherteamTestPiece.location[0]][ otherteamTestPiece.location[1]] = otherteamTestPiece.name
            expect(@testKnight.rules(@board, @testKnight, 7, 6)).to be_falsey
        end

        it 'returns true if knight moves to a valid space and eats a piece' do
            otherteamTestPiece = Pawn.new('Black', 1)
            otherteamTestPiece.location = [7, 6]
            @board[otherteamTestPiece.location[0]][ otherteamTestPiece.location[1]] = otherteamTestPiece.name
            expect(@testKnight.rules(@board, @testKnight, 7, 6)).to be_truthy
        end

        it 'returns false if knight tries to move to its current location' do
            expect(@testKnight.rules(@board, @testKnight, 5, 5)).to be_falsey
        end
    end
end

#Pawns are unique in that, in regards to the board, white moves up and black moves down. These tests use white pieces, so moving up is considered.
describe Pawn do
    before(:each) {@board = Array.new(8) { Array.new(8, '     ')}
                    @testPawn = Pawn.new('White', 1)
                    @testPawn.location = [5, 5]
                    @board[@testPawn.location[0]][@testPawn.location[1]] = @testPawn.name}

    describe '#rules' do
        it 'returns true if pawn moves up one space to an empty space' do
            expect(@testPawn.rules(@board, @testPawn, 4, 5)).to be_truthy
        end

        it 'returns true if pawn moves up two spaces to an empty space, given that it has NOT moved yet' do
            expect(@testPawn.rules(@board, @testPawn, 3, 5)).to be_truthy
        end

        it 'returns false if pawn moves up two spaces to an empty space, given that it has moved already' do
            @testPawn.hasNotMovedYet = false
            expect(@testPawn.rules(@board, @testPawn, 3, 5)).to be_falsey
        end

        it 'returns false if pawn moves up one space to a space with a piece from the same team' do
            otherteamTestPiece = Pawn.new('Black', 1)
            otherteamTestPiece.location = [4, 5]
            @board[otherteamTestPiece.location[0]][ otherteamTestPiece.location[1]] = otherteamTestPiece.name
            expect(@testPawn.rules(@board, @testPawn, 4, 5)).to be_falsey
        end

        it 'returns false if pawn moves up once diagonally to the right to a space with a piece from the same team' do
            otherteamTestPiece = Pawn.new('White', 2)
            otherteamTestPiece.location = [4, 6]
            @board[otherteamTestPiece.location[0]][ otherteamTestPiece.location[1]] = otherteamTestPiece.name
            expect(@testPawn.rules(@board, @testPawn, 4, 6)).to be_falsey
        end

        it 'returns true if pawn moves up once diagonally to the right to a space with a piece from the other team' do
            otherteamTestPiece = Pawn.new('Black', 1)
            otherteamTestPiece.location = [4, 6]
            @board[otherteamTestPiece.location[0]][ otherteamTestPiece.location[1]] = otherteamTestPiece.name
            expect(@testPawn.rules(@board, @testPawn, 4, 6)).to be_truthy
        end

        it 'returns false if pawn moves once horizontally' do
            expect(@testPawn.rules(@board, @testPawn, 5, 6)).to be_falsey
        end

        it 'returns false if pawn moves once down' do
            expect(@testPawn.rules(@board, @testPawn, 6, 5)).to be_falsey
        end

        it 'returns false if pawn moves to a space not on the board' do
            expect(@testPawn.rules(@board, @testPawn, 10, 10)).to be_falsey
        end

        it 'returns false if pawn tries to move to its current location' do
            expect(@testPawn.rules(@board, @testPawn, 5, 5)).to be_falsey
        end
    end

end

describe Rook do
    before(:each) {@board = Array.new(8) { Array.new(8, '     ')}
                    @testRook = Rook.new('White', 1)
                    @testRook.location = [5, 5]
                    @board[@testRook.location[0]][@testRook.location[1]] = @testRook.name}
    
    describe '#rules' do
        it 'returns true if rook moves up one space' do
            expect(@testRook.rules(@board, @testRook, 4, 5)).to be_truthy
        end

        it 'returns true if rook moves down two spaces with no piece in the way' do
            expect(@testRook.rules(@board, @testRook, 7, 5)).to be_truthy
        end

        it 'returns true if rook moves right two spaces with no piece in the way' do
            expect(@testRook.rules(@board, @testRook, 5, 7)).to be_truthy
        end

        it 'returns true if rook moves left three spaces with no piece in the way' do
            expect(@testRook.rules(@board, @testRook, 5, 2)).to be_truthy
        end

        it 'returns false if rook moves up two spaces with a piece in the way' do
            otherteamTestPiece = Pawn.new('Black', 1)
            otherteamTestPiece.location = [4, 5]
            @board[otherteamTestPiece.location[0]][ otherteamTestPiece.location[1]] = otherteamTestPiece.name
            expect(@testRook.rules(@board, @testRook, 3, 5)).to be_falsey
        end

        it 'returns false if rook tries to move diagonally up and to the right one space' do
            expect(@testRook.rules(@board, @testRook, 4, 6)).to be_falsey
        end

        it 'returns true if rook moves up two spaces to eat a piece with no piece in the way' do
            otherteamTestPiece = Pawn.new('Black', 1)
            otherteamTestPiece.location = [3, 5]
            @board[otherteamTestPiece.location[0]][ otherteamTestPiece.location[1]] = otherteamTestPiece.name
            expect(@testRook.rules(@board, @testRook, 3, 5)).to be_truthy
        end

        it 'returns false if rook moves up two spaces to a space with a piece from the same team on it and with no piece in the way' do
            otherteamTestPiece = Pawn.new('White', 1)
            otherteamTestPiece.location = [3, 5]
            @board[otherteamTestPiece.location[0]][ otherteamTestPiece.location[1]] = otherteamTestPiece.name
            expect(@testRook.rules(@board, @testRook, 3, 5)).to be_falsey
        end

        it 'returns false if rook tries to move to its current location' do
            expect(@testRook.rules(@board, @testRook, 5, 5)).to be_falsey
        end
    end
end

describe Bishop do
    before(:each) {@board = Array.new(8) { Array.new(8, '     ')}
                    @testBishop = Bishop.new('White', 1)
                    @testBishop.location = [5, 5]
                    @board[@testBishop.location[0]][@testBishop.location[1]] = @testBishop.name}

    describe '#rules' do
        it 'returns true if bishop moves up and to the right one space with no piece in the way' do
            expect(@testBishop.rules(@board, @testBishop, 4, 6)).to be_truthy
        end

        it 'returns true if bishop moves up and to the left two spaces with no piece in the way' do
            expect(@testBishop.rules(@board, @testBishop, 3, 3)).to be_truthy
        end

        it 'returns true if bishop moves down and to the right two spaces with no piece in the way' do
            expect(@testBishop.rules(@board, @testBishop, 7, 7)).to be_truthy
        end

        it 'returns true if bishop moves down and to the left two spaces with no piece in the way' do
            expect(@testBishop.rules(@board, @testBishop, 7, 3)).to be_truthy
        end

        it 'returns false if bishop moves up and to the left two spaces with a piece in the way' do
            otherteamTestPiece = Pawn.new('Black', 1)
            otherteamTestPiece.location = [4, 4]
            @board[otherteamTestPiece.location[0]][ otherteamTestPiece.location[1]] = otherteamTestPiece.name
            expect(@testBishop.rules(@board, @testBishop, 3, 3)).to be_falsey
        end

        it 'returns false if bishop tries to move down one space' do
            expect(@testBishop.rules(@board, @testBishop, 6, 5)).to be_falsey
        end

        it 'returns true if bishop moves up and to the right two spaces to eat a piece with no piece in the way' do
            otherteamTestPiece = Pawn.new('Black', 1)
            otherteamTestPiece.location = [3, 7]
            @board[otherteamTestPiece.location[0]][ otherteamTestPiece.location[1]] = otherteamTestPiece.name
            expect(@testBishop.rules(@board, @testBishop, 3, 7)).to be_truthy
        end

        it 'returns false if bishop moves up and to the right two spaces to a space with a piece from the same team on it and with no piece in the way' do
            otherteamTestPiece = Pawn.new('White', 1)
            otherteamTestPiece.location = [3, 7]
            @board[otherteamTestPiece.location[0]][ otherteamTestPiece.location[1]] = otherteamTestPiece.name
            expect(@testBishop.rules(@board, @testBishop, 3, 7)).to be_falsey
        end

        it 'returns false if bishop tries to move to its current location' do
            expect(@testBishop.rules(@board, @testBishop, 5, 5)).to be_falsey
        end
    end
end

describe Queen do
    describe '#rules' do
        before(:each) {@board = Array.new(8) { Array.new(8, '     ')}
                        @testQueen = Queen.new('White')
                        @testQueen.location = [5, 5]
                        @board[@testQueen.location[0]][@testQueen.location[1]] = @testQueen.name}

        it 'returns true if Queen moves up one space' do
            expect(@testQueen.rules(@board, @testQueen, 4, 5)).to be_truthy
        end

        it 'returns true if Queen moves down two spaces with no piece in the way' do
            expect(@testQueen.rules(@board, @testQueen, 7, 5)).to be_truthy
        end

        it 'returns true if Queen moves right two spaces with no piece in the way' do
            expect(@testQueen.rules(@board, @testQueen, 5, 7)).to be_truthy
        end

        it 'returns true if Queen moves left three spaces with no piece in the way' do
            expect(@testQueen.rules(@board, @testQueen, 5, 2)).to be_truthy
        end

        it 'returns false if Queen moves up two spaces with a piece in the way' do
            otherteamTestPiece = Pawn.new('Black', 1)
            otherteamTestPiece.location = [4, 5]
            @board[otherteamTestPiece.location[0]][ otherteamTestPiece.location[1]] = otherteamTestPiece.name
            expect(@testQueen.rules(@board, @testQueen, 3, 5)).to be_falsey
        end

        it 'returns true if Queen moves up two spaces to eat a piece with no piece in the way' do
            otherteamTestPiece = Pawn.new('Black', 1)
            otherteamTestPiece.location = [3, 5]
            @board[otherteamTestPiece.location[0]][ otherteamTestPiece.location[1]] = otherteamTestPiece.name
            expect(@testQueen.rules(@board, @testQueen, 3, 5)).to be_truthy
        end

        it 'returns false if Queen moves up two spaces to a space with a piece from the same team on it and with no piece in the way' do
            otherteamTestPiece = Pawn.new('White', 1)
            otherteamTestPiece.location = [3, 5]
            @board[otherteamTestPiece.location[0]][ otherteamTestPiece.location[1]] = otherteamTestPiece.name
            expect(@testQueen.rules(@board, @testQueen, 3, 5)).to be_falsey
        end

        it 'returns true if Queen moves up and to the right one space with no piece in the way' do
            expect(@testQueen.rules(@board, @testQueen, 4, 6)).to be_truthy
        end
        
        it 'returns true if Queen moves up and to the left two spaces with no piece in the way' do
            expect(@testQueen.rules(@board, @testQueen, 3, 3)).to be_truthy
        end
        
        it 'returns true if Queen moves down and to the right two spaces with no piece in the way' do
            expect(@testQueen.rules(@board, @testQueen, 7, 7)).to be_truthy
        end
        
        it 'returns true if Queen moves down and to the left two spaces with no piece in the way' do
            expect(@testQueen.rules(@board, @testQueen, 7, 3)).to be_truthy
        end
        
        it 'returns false if Queen moves up and to the left two spaces with a piece in the way' do
            otherteamTestPiece = Pawn.new('Black', 1)
            otherteamTestPiece.location = [4, 4]
            @board[otherteamTestPiece.location[0]][ otherteamTestPiece.location[1]] = otherteamTestPiece.name
            expect(@testQueen.rules(@board, @testQueen, 3, 3)).to be_falsey
        end
        
        it 'returns true if Queen moves up and to the right two spaces to eat a piece with no piece in the way' do
            otherteamTestPiece = Pawn.new('Black', 1)
            otherteamTestPiece.location = [3, 7]
            @board[otherteamTestPiece.location[0]][ otherteamTestPiece.location[1]] = otherteamTestPiece.name
            expect(@testQueen.rules(@board, @testQueen, 3, 7)).to be_truthy
        end
        
        it 'returns false if Queen moves up and to the right two spaces to a space with a piece from the same team on it and with no piece in the way' do
            otherteamTestPiece = Pawn.new('White', 1)
            otherteamTestPiece.location = [3, 7]
            @board[otherteamTestPiece.location[0]][ otherteamTestPiece.location[1]] = otherteamTestPiece.name
            expect(@testQueen.rules(@board, @testQueen, 3, 7)).to be_falsey
        end

        it 'returns false if queen tries to move to its current location' do
            expect(@testQueen.rules(@board, @testQueen, 5, 5)).to be_falsey
        end
    end
end

describe King do
    describe '#rules' do
        before(:each) {@board = Array.new(8) { Array.new(8, '     ')}
                        @testKing = King.new('White')
                        @testKing.location = [5, 5]
                        @board[@testKing.location[0]][@testKing.location[1]] = @testKing.name}

        it 'returns true if King moves up one space with the space being empty' do
            expect(@testKing.rules(@board, @testKing, 4, 5)).to be_truthy
        end

        it 'returns true if King moves right one space with the space being empty' do
            expect(@testKing.rules(@board, @testKing, 5, 6)).to be_truthy
        end
        
        it 'returns true if King moves down one space with the space being empty' do
            expect(@testKing.rules(@board, @testKing, 6, 5)).to be_truthy
        end

        it 'returns true if King moves left one space with the space being empty' do
            expect(@testKing.rules(@board, @testKing, 5, 4)).to be_truthy
        end

        it 'returns true if King moves up and to the right one space with the space being empty' do
            expect(@testKing.rules(@board, @testKing, 4, 6)).to be_truthy
        end

        it 'returns true if King moves up and to the left one space with the space being empty' do
            expect(@testKing.rules(@board, @testKing, 4, 4)).to be_truthy
        end

        it 'returns true if King moves down and to the right one space with the space being empty' do
            expect(@testKing.rules(@board, @testKing, 6, 6)).to be_truthy
        end

        it 'returns true if King moves down and to the left one space with the space being empty' do
            expect(@testKing.rules(@board, @testKing, 6, 4)).to be_truthy
        end

        it 'returns true if King moves up one space and eats a piece' do
            otherteamTestPiece = Pawn.new('Black', 1)
            otherteamTestPiece.location = [4, 5]
            @board[otherteamTestPiece.location[0]][ otherteamTestPiece.location[1]] = otherteamTestPiece.name
            expect(@testKing.rules(@board, @testKing, 4, 5)).to be_truthy
        end

        it 'returns false if King moves up one space to a space with a piece from its own team on it' do
            otherteamTestPiece = Pawn.new('White', 1)
            otherteamTestPiece.location = [4, 5]
            @board[otherteamTestPiece.location[0]][ otherteamTestPiece.location[1]] = otherteamTestPiece.name
            expect(@testKing.rules(@board, @testKing, 4, 5)).to be_falsey
        end

        it 'returns false if king tries to move to its current location' do
            expect(@testKing.rules(@board, @testKing, 5, 5)).to be_falsey
        end
    end
end