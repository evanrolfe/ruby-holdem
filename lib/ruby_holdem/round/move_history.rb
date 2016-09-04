module RubyHoldem
  class Round
    class MoveHistory
      attr_reader :moves, :stage

      def initialize
        @moves = []
        @stage = STAGES.first
      end

      def add_move(move)
        moves << move
      end

      def last_move
        moves.last
      end

      def turns_played
        moves.count
      end

      def next_stage
        @stage = STAGES[STAGES.index(stage)+1]
      end
    end
  end
end
