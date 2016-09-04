module RubyHoldem
  class Round
    class MoveFactory
      attr_reader :round, :player, :move, :amount

      def initialize(round, player, move, amount)
        @round = round
        @player = player
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
      def stage
        round.current_stage
      end
    end
  end
end
