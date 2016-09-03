module RubyHoldem
  class Round
    class MoveHistory
      attr_reader :players, :moves, :stage

      def initialize(players)
        @players = players
        @moves = []
        @stage = STAGES[0]
      end

      #
      # Write operations
      #
      def add_move(move)
        moves << move
      end

      def last_move
        moves.last
      end

      def turns_played
        moves.count
      end

      def next_stage
        @stage = STAGES[STAGES.index(stage)+1]
      end

      #
      # Read operations
      #
      def highest_bet_placed
        players_still_in_round.max_by(&:current_bet_amount).current_bet_amount
      end

      def has_winner?
        (stage == 'show_down' || players_still_in_round.count == 1)
      end

      def winner
        return players_still_in_round[0] if players_still_in_round.count == 1
      end

      def ready_for_next_stage?
        return false unless every_player_has_called? && turns_played_in_stage > 0

        players_still_in_round.map { |player| (player.current_bet_amount == highest_bet_placed) }.all?
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

      def every_player_has_called?
        players_num_calls = players_still_in_round.map do |round_player|
          calls = moves.select do |move|
            move[:stage] == stage &&
              move[:move] == 'call' &&
              move[:player] == round_player
          end
          calls.length
        end

        players_num_calls.map { |num_calls| num_calls >= 1 }.all?
      end

      def players_still_in_round
        players.select do |round_player|
          folds = moves.select do |move|
            move[:move] == 'fold' && move[:player] == round_player
          end

          folds.length == 0
        end
      end
    end
  end
end
