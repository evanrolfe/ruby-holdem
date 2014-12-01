module RubyHoldem
  class Game
    def self.hello
      hand1 = ::PokerHand.new("8H 9C TC JD QH")
      hand1.rank
    end
  end
end
