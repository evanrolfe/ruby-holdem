module RubyHoldem
  class Round
    class MoveValidator
      attr_reader :round, :move, :amount

      def initialize(round, move, amount)
        @round = round
        @move = move
        @amount = amount # TODO: What to do when its a call?
      end

      def valid?
        return false if blinds_turn? && blinds_not_met?

        send("valid_#{move}?")
      end

      private

      def valid_raise?
        amount >= min_raise_amount && player_can_afford_raise?
      end

      def valid_call?
        @amount = min_raise_amount
        player_can_afford_raise?
      end

      def valid_fold?
        true # NOTE: You can always fold as long as its not a blinds turn
      end

      def min_raise_amount
        @min_raise_amount ||= highest_bet_placed - player_in_turn.current_bet_amount
      end

      # TODO:
      def player_can_afford_raise?
        true
      end

      def blinds_turn?
        turns_played == 0 || turns_played == 1
      end

      def blinds_not_met?
        if turns_played == 0
          amount < small_blinds
        elsif turns_played == 1
          amount < big_blinds
        end
      end

      #
      # Dependencies on Round class
      #
      def highest_bet_placed
        @highest_bet_placed ||= round.highest_bet_placed
      end

      def player_in_turn
        @player_in_turn ||= round.player_in_turn
      end

      def turns_played
        @turns_played ||= round.turns_played
      end

      def small_blinds
        @small_blinds ||= round.small_blinds
      end

      def big_blinds
        @big_blinds ||= round.big_blinds
      end
    end
  end
end
