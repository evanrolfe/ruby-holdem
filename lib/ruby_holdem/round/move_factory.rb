module RubyHoldem
  class Round
    class MoveFactory
      attr_reader :round, :move, :amount

      def initialize(round, move, amount)
        @round = round
        @move = move
        @amount = amount
      end

      def build
        {
          player: player,
          stage: stage,
          move: move,
          amount: amount
        }
      end

      #
      # Dependencies on Round class
      #
      def player
        round.player_in_turn
      end

      def stage
        round.current_stage
      end
    end
  end
end
