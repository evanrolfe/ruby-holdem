require 'forwardable'

module RubyHoldem
  class Round
    extend Forwardable

    attr_reader :players,
                :small_blinds,
                :big_blinds,
                :pot_amount,
                :current_stage,
                :action_history

    attr_accessor :pot_amount

    def_delegator :@dealer, :community_cards

    STAGES = %w(pre_flop flop turn river show_down)

    def initialize(players, small_blinds, big_blinds)
      @small_blinds = small_blinds
      @big_blinds = big_blinds
      @current_stage = STAGES[0]
      @pot_amount = 0
      @action_history = []

      @players = players.map { |player| RoundPlayer.new(player) }
      @dealer = Dealer.new
      @dealer.deal_hole_cards(@players)
    end

    def make_move(move, amount=nil)
      MoveMaker.new(self, turns_played, @small_blinds, @big_blinds, highest_bet_placed, player_in_turn)
        .make_move(move, amount)
    end

    def next_stage
      raise StandardError unless ready_for_next_stage? && @current_stage != 'show_down'

      @current_stage = STAGES[STAGES.index(@current_stage)+1]
      @dealer.deal_community_cards(@current_stage)
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
    end

    def player_in_turn  #The player whose turn it is to make a move
      return players[0] if action_history.length == 0

      last_player_index = players.index(action_history.last[:player])
      next_player_index = (last_player_index + 1) % (players.length)

      players[next_player_index]
    end

    def players_still_in_round
      players.select do |round_player|
        folds = action_history.select { |action| action[:move] == 'fold' && action[:player] == round_player }
        (folds.length == 0)
      end
    end

    def highest_bet_placed
      players_still_in_round.max_by(&:current_bet_amount).current_bet_amount
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
  end
end
