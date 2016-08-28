module RubyHoldem
  class RoundPlayer
    extend Forwardable

    attr_reader :player, :id
    attr_accessor :hole_cards

    def_delegators :@player, :id, :bank_roll

    def initialize(player, round)
      @player = player
      @round = round
      @hole_cards = []
    end

    def current_bet_amount
      @round.action_history
        .select { |action| action[:player] == self && action[:stage] == @round.current_stage }
        .inject(0) { |sum, action| sum += action[:amount] }
    end

    def amount_to_call
      @round.highest_bet_placed - current_bet_amount
    end

    # TODO:
    def can_afford_to_bet?(amount)
      true
    end
  end
end
