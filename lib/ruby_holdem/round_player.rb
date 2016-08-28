module RubyHoldem
  class RoundPlayer
    attr_reader :name
    attr_accessor :hole_cards, :current_bet_amount

    def initialize(name)
      @name = name
      @hole_cards = []
      @current_bet_amount = 0
    end
  end
end
