module RubyHoldem
  class Round
    class MoveHistoryComputations
      attr_reader :players, :move_history

      def initialize(players, move_history)
        @players = players
        @move_history = move_history
      end

      def highest_bet_placed
        get_current_bet_amount_for_player(
          players_still_in_round.max_by(&:current_bet_amount)
        )
      end

      def ready_for_next_stage?
        every_player_has_checked? && turns_played_in_stage > 0
      end

      def has_winner?
        (stage == 'show_down' || players_still_in_round.count == 1)
      end

      # TODO: Compare the hands of the two players
      def winner
        return players_still_in_round[0] if players_still_in_round.count == 1
      end

      def turns_played_in_stage
        moves.select { |move| move[:stage] == stage }.length
      end

      def player_in_turn  #The player whose turn it is to make a move
        return players[0] if moves.length == 0

        last_player = moves.last[:player]
        i = (players.index(last_player) + 1) % players.length

        player_found = false
        until player_found
          at_end_of_array = (i == (players.length - 1))

          if player_is_folded?(players[i]) && !at_end_of_array
            i += 1
          elsif player_is_folded?(players[i]) && at_end_of_array
            i = 0
          else
            player_found = true
          end
        end
        players[i]
      end

      def every_player_has_checked?
        players_num_checks = players_still_in_round.map do |round_player|
          checks = moves.select do |move|
            move[:stage] == stage &&
              move[:move_type] == 'check' &&
              move[:player] == round_player
          end
          checks.length
        end

        players_num_checks.map { |num_checks| num_checks >= 1 }.all?
      end

      def players_still_in_round
        players.select do |round_player|
          folds = moves.select do |move|
            move[:move_type] == 'fold' && move[:player] == round_player
          end

          folds.length == 0
        end
      end

      private

      def player_is_folded?(player)
        moves.select do |move|
          move[:move_type] == 'fold' && move[:player] == player
        end.any?
      end

      #
      # Dependencies on MoveHistory class
      #
      def moves
        move_history.moves
      end

      def stage
        move_history.stage
      end

      #
      # Dependencies on Player class
      #
      def get_current_bet_amount_for_player(player)
        player.current_bet_amount
      end
    end
  end
end
