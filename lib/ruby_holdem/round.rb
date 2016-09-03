require 'forwardable'

module RubyHoldem
  class Round
    extend Forwardable

    attr_reader :small_blinds,
                :big_blinds,
                :pot_amount,
                :current_stage,
                :players,
                :state

    def_delegator :@dealer, :community_cards

    def_delegators :@move_history, :ready_for_next_stage?,
                                   :has_winner?,
                                   :winner,
                                   :player_in_turn,
                                   :players_still_in_round,
                                   :highest_bet_placed,
                                   :last_move,
                                   :turns_played

    STAGES = %w(pre_flop flop turn river show_down)

    def initialize(players, small_blinds, big_blinds)
      @small_blinds = small_blinds
      @big_blinds = big_blinds
      @pot_amount = 0

      @players = players.map { |player| RoundPlayer.new(player) }
      @move_history = MoveHistory.new(@players)

      @dealer = Dealer.new
      @dealer.deal_hole_cards(@players)
    end

    def make_move(move, amount=nil)
      if MoveValidator.new(self, move, amount).valid?
        move = MoveFactory.new(self, move, amount).build
        @move_history.add_move(move)
      end
    end

    def next_stage
      raise StandardError unless @state.ready_for_next_stage? && @current_stage != 'show_down'

      @dealer.deal_community_cards(@current_stage)
    end
  end
end
