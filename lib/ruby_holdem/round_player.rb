module RubyHoldem
  class RoundPlayer < SimpleDelegator
    attr_accessor :hole_cards, :current_bet_amount

    def initialize(player)
      @hole_cards = []
      @current_bet_amount = 0
      super(player)
    end
  end
end
