module RubyHoldem
  class Round
    attr_reader :players, :small_blinds, :big_blinds, :pot_amount, :current_stage, :action_history, :board

    STAGES = %w(pre_flop flop turn river show_down)

    def initialize(players, small_blinds, big_blinds)
      @small_blinds, @big_blinds = small_blinds, big_blinds
      @players = players.map { |player| RoundPlayer.new(player, self) }
      @current_stage = STAGES[0]
      @pot_amount = 0
      @action_history = []
    end

    def make_move(move, amount=nil)
      if move == :bet
        apply_bet(amount)
      elsif move == :call
        apply_call
      elsif move == :fold
        apply_fold
      end

      @turns_played += 1
    end

    def player_in_turn  #The player whose turn it is to make a move
      return players[0] if action_history.length == 0
      last_player_index = players.index(action_history.last[:player])
      player_found = false
      increment=1
      until player_found
        next_player = players[(last_player_index + increment) % players.length]   #Wrap around the array once end reached
        player_found = true if players_still_in_round.include?(next_player)
        increment += 1
      end
      next_player
    end

    def players_still_in_round
      players_still_in_game = players.select do |round_player|
        folds = action_history.select { |action| action[:move] == 'fold' && action[:player] == round_player }
        (folds.length == 0)
      end
    end

    def highest_bet_placed
      players_still_in_round.max_by { |player| player.current_bet_amount }.current_bet_amount
    end

    private

    def apply_bet(amount)
      raise MinBetNotMeet if amount < player_in_turn.amount_to_call
      raise NotEnoughMoney unless player_in_turn.can_afford_to_bet?(amount)
      @pot_amount += amount
      action_history << { player: player_in_turn, stage: current_stage, move: 'bet', amount: amount}
    end

    def apply_call
      amount = player_in_turn.amount_to_call
      raise NotEnoughMoney unless player_in_turn.can_afford_to_bet?(amount)
      @pot_amount += amount
      action_history << { player: player_in_turn, stage: current_stage, move: 'call', amount: amount}
    end

    def apply_fold
      action_history << { player: player_in_turn, stage: current_stage, move: 'fold', amount: 0}
    end
  end
end
