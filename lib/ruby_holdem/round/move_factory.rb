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
          amount: actual_amount
        }
      end

      private

      def actual_amount
        if move == "call"
          highest_bet_placed - current_bet_amount
        else
          amount
        end
      end

      #
      # Dependencies on Round class
      #
      def stage
        round.current_stage
      end

      def highest_bet_placed
        @highest_bet_placed ||= round.highest_bet_placed
      end

      #
      # Dependencies on Player class
      #
      def current_bet_amount
        @current_bet_amount ||= player.current_bet_amount
      end
    end
  end
end
