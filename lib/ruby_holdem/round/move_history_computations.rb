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

        last_player_index = players.index(moves.last[:player])
        next_player_index = (last_player_index + 1) % (players.length)

        players[next_player_index]
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
