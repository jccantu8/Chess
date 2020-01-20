require './lib/chess.rb'


describe Game do
    describe '#check_move_for_check' do
        before(:each) {@testGame = Game.new
                        @testGame.initialize_board}

        it 'returns true if pawn can check other team\'s king if it\'s located one space diagonally' do
            @testGame.player2.availablePieces.delete(@testGame.player2.pawn3)
            @testGame.player1.pawn3.location = [1, 2]
            @testGame.update_board

            expect(@testGame.check_move_for_check(@testGame.board, @testGame.player1.pawn3, @testGame.player2.king.location)).to be_truthy
        end

        it 'returns true if knight can check other team\'s king' do
            @testGame.player1.knight1.location = [2, 2]
            @testGame.update_board

            expect(@testGame.check_move_for_check(@testGame.board, @testGame.player1.knight1, @testGame.player2.king.location)).to be_truthy
        end

        it 'returns true if bishop can check other team\'s king' do
            @testGame.player2.availablePieces.delete(@testGame.player2.pawn3)
            @testGame.player1.bishop1.location = [3, 0]
            @testGame.update_board

            expect(@testGame.check_move_for_check(@testGame.board, @testGame.player1.bishop1, @testGame.player2.king.location)).to be_truthy
        end

        it 'returns true if rook can check other team\'s king' do
            @testGame.player2.availablePieces.delete(@testGame.player2.pawn4)
            @testGame.player1.rook1.location = [3, 3]
            @testGame.update_board

            expect(@testGame.check_move_for_check(@testGame.board, @testGame.player1.rook1, @testGame.player2.king.location)).to be_truthy
        end

        it 'returns true if queen can check other team\'s king' do
            @testGame.player2.availablePieces.delete(@testGame.player2.pawn4)
            @testGame.player1.queen.location = [3, 3]
            @testGame.update_board

            expect(@testGame.check_move_for_check(@testGame.board, @testGame.player1.queen, @testGame.player2.king.location)).to be_truthy
        end

        #Dont want kings to check kings
        it 'returns true if king can check other team\'s king' do
            @testGame.player2.availablePieces.delete(@testGame.player2.pawn3)
            @testGame.player1.king.location = [1, 2]
            @testGame.update_board

            expect(@testGame.check_move_for_check(@testGame.board, @testGame.player1.king, @testGame.player2.king.location)).to be_truthy
        end
    end

    describe '#is_checkmated?' do
        before(:each) {@testGame = Game.new
                        @testGame.initialize_board}

        it 'returns true if checkmate' do
            @testGame.player2.availablePieces.delete(@testGame.player2.pawn3)
            @testGame.player1.bishop1.location = [4, 5]
            @testGame.player1.queen.location = [1 ,2]
            @testGame.update_board

            expect(@testGame.is_checkmated?(@testGame.board, @testGame.player2, @testGame.player1)).to be_truthy
        end

        it 'returns false if not in checkmate' do
            @testGame.player2.availablePieces.delete(@testGame.player2.pawn3)
            @testGame.player1.pawn3.location = [1 ,2]
            @testGame.update_board

            expect(@testGame.is_checkmated?(@testGame.board, @testGame.player2, @testGame.player1)).to be_falsey
        end

    end
end