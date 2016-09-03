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
          player: round.player_in_turn,
          stage: round.current_stage,
          move: move,
          amount: amount
        }
      end
    end
  end
end
