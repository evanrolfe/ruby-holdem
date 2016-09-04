module RubyHoldem
  class Round
    class MoveFactory
      attr_reader :round, :player, :move_type, :amount

      def initialize(round, player, move_type, amount)
        @round = round
        @player = player
        @move_type = move_type
        @amount = amount
      end

      def build
        {
          player: player,
          stage: stage,
          move_type: move_type,
          amount: actual_amount
        }
      end

      private

      def actual_amount
        if move_type == "call"
          highest_bet_placed - current_bet_amount
        else
          amount
        end
      end

      #
      # Dependencies on Round class
      #
      def stage
        round.stage
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
