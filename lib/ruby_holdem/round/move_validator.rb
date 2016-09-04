module RubyHoldem
  class Round
    class MoveValidator
      attr_reader :round, :player, :move, :amount

      def initialize(round, player, move, amount)
        @round = round
        @player = player
        @move = move
        @amount = amount # TODO: What to do when its a check?
      end

      def validate
        if blinds_turn? && blinds_not_met?
          raise MinRaiseNotMeet, "You must bet blinds."
        end

        send("validate_#{move}")
      end

      private

      def validate_raise
        if amount < min_raise_amount
          raise MinRaiseNotMeet
        end

        if !player_can_afford_raise?
          raise InsufficientFunds
        end
      end

      def validate_call
        if !player_can_afford_raise?
          raise InsufficientFunds
        end
      end

      def validate_check
        if min_raise_amount > 0
          raise MinRaiseNotMeet
        end
      end

      def validate_fold
        true # NOTE: You can always fold as long as its not a blinds turn
      end

      def min_raise_amount
        @min_raise_amount ||= highest_bet_placed - current_bet_amount
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

      def turns_played
        @turns_played ||= round.turns_played
      end

      def small_blinds
        @small_blinds ||= round.small_blinds
      end

      def big_blinds
        @big_blinds ||= round.big_blinds
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
