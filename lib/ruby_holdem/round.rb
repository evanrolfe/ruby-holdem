require 'forwardable'

module RubyHoldem
  class Round
    extend Forwardable

    attr_reader :small_blinds,
                :big_blinds,
                :pot_amount,
                :players,
                :state

    def_delegator :@dealer, :community_cards

    def_delegators :@move_history_computations, :ready_for_next_stage?,
                                                :has_winner?,
                                                :winner,
                                                :player_in_turn,
                                                :players_still_in_round,
                                                :highest_bet_placed

    def_delegators :@move_history, :stage,
                                   :last_move,
                                   :turns_played,
                                   :moves

    STAGES = %w(pre_flop flop turn river show_down)

    def initialize(players, small_blinds, big_blinds)
      @small_blinds = small_blinds
      @big_blinds = big_blinds
      @pot_amount = 0

      @players = players.map { |player| Player.new(player) }
      @move_history = MoveHistory.new
      @move_history_computations = MoveHistoryComputations.new(@players, @move_history)

      @dealer = Dealer.new
      @dealer.deal_hole_cards(@players)
    end

    def make_move(move_type, amount=nil)
      move = MoveFactory.new(self, player_in_turn, move_type, amount).build

      MoveValidator.new(self, move).validate

      unless move[:amount].nil?
        player_in_turn.current_bet_amount += move[:amount]
        @pot_amount += move[:amount]
      end

      @move_history.add_move(move)
    end

    def next_stage
      raise StandardError unless @state.ready_for_next_stage? && @current_stage != 'show_down'

      @dealer.deal_community_cards(@current_stage)
    end
  end
end
