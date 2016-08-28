module RubyHoldem
  class Round
    extend Forwardable

    attr_reader :players,
                :small_blinds,
                :big_blinds,
                :pot_amount,
                :current_stage,
                :action_history,
                :dealer,
                :turns_played

    def_delegator :@dealer, :community_cards

    STAGES = %w(pre_flop flop turn river show_down)

    def initialize(players, small_blinds, big_blinds)
      @players = players.map { |player| RoundPlayer.new(player, self) }
      @dealer = Dealer.new(@players)

      @small_blinds, @big_blinds = small_blinds, big_blinds
      @current_stage = STAGES[0]
      @pot_amount = 0
      @action_history = []
    end

    def make_move(move, amount=nil)
      if turns_played == 0
        apply_bet(small_blinds)
      elsif turns_played == 1
        apply_bet(big_blinds)
      elsif move == 'bet'
        apply_bet(amount)
      elsif move == 'call'
        apply_call
      elsif move == 'fold'
        apply_fold
      end
    end

    def next_stage
      raise StandardError unless ready_for_next_stage? && @current_stage != 'show_down'

      @current_stage = STAGES[STAGES.index(@current_stage)+1]
    end

    def ready_for_next_stage?
      return false unless every_player_has_called? && turns_played_in_stage > 0

      players_still_in_round.map { |player| (player.current_bet_amount == highest_bet_placed) }.all?
    end

    def has_winner?
      (current_stage == 'show_down' || players_still_in_round.count == 1)
    end

    def winner
      return players_still_in_round[0] if players_still_in_round.count == 1
      return players_still_in_round[2]
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

    def last_move
      action_history.last
    end

    private

    def turns_played
      action_history.length
    end

    def turns_played_in_stage
      action_history.select { |action| action[:stage] == @current_stage }.length
    end

    def every_player_has_called?
      players_num_calls = players_still_in_round.map do |round_player|
        calls = action_history.select { |action| action[:stage] == @current_stage && action[:move] == 'call' && action[:player] == round_player }
        calls.length
      end

      players_num_calls.map { |num_calls| num_calls >= 1 }.all?
    end

    def apply_bet(amount)
      raise MinBetNotMeet if amount < player_in_turn.amount_to_call

      #TODO: Go all in instead of raising an error
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
