require 'pry'
module RubyHoldem
  class Round
    class MoveMaker
      def initialize(round, turns_played, small_blinds, big_blinds, highest_bet_placed, player_in_turn)
        @round = round
        @small_blinds = small_blinds
        @big_blinds = big_blinds
        @turns_played = turns_played
        @highest_bet_placed = highest_bet_placed
        @player_in_turn = player_in_turn
      end

      def make_move(move, amount = nil)
        #if @turns_played == 0
        #raise MinBetNotMeet, "Must bet small blinds"
#
        #if move == 'bet'
        #  apply_bet(amount)

        elsif move == 'call'
          apply_call

        elsif move == 'fold'
          apply_fold

        end
      end

      private

      def apply_bet(amount)
        raise MinBetNotMeet if amount < amount_to_call
        raise NotEnoughMoney unless player_can_afford_bet?(amount)

        @round.pot_amount += amount
        @player_in_turn.current_bet_amount += amount

        @round.action_history << {
          player: @player_in_turn,
          stage: @round.current_stage,
          move: 'bet',
          amount: amount
        }
      end

      def apply_call
        raise NotEnoughMoney unless player_can_afford_bet?(amount_to_call)

        @round.pot_amount += amount_to_call
        @player_in_turn.current_bet_amount += amount_to_call

        @round.action_history << {
          player: @player_in_turn,
          stage: @round.current_stage,
          move: 'call',
          amount: amount_to_call
        }
      end

      def apply_fold
        @round.action_history << {
          player: @player_in_turn,
          stage: @round.current_stage,
          move: 'fold',
          amount: 0
        }
      end

      def amount_to_call
        @min_bet_amount ||= @highest_bet_placed - @player_in_turn.current_bet_amount
      end

      # TODO:
      def player_can_afford_bet?(amount)
        true
      end
    end
  end
end
