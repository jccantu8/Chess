class Knight
    attr_accessor :name, :location, :team, :availableMoves

    def initialize(team, pieceNumber)
        @team = team
        @pieceNumber = pieceNumber
        @name = assign_name(@team, 'Kn', @pieceNumber)
        @location = nil
        @availableMoves = self.generateMoves
    end

    def generateMoves

        x = self.location[0]
        y = self.location[1]

        for n in [-1, 1]
            for m in [-1, 1]
                

            end
        end

    end

end