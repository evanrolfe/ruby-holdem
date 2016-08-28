module RubyHoldem
  class RoundPlayer
    extend Forwardable

    attr_reader :player, :id
    attr_accessor :hole_cards, :current_bet_amount

    def_delegators :@player, :id, :bank_roll

    def initialize(player, round)
      @player = player
      @hole_cards = []
      @current_bet_amount = 0
    end
  end
end
