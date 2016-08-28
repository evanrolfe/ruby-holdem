module RubyHoldem
  class Dealer
    attr_reader :community_cards

    def initialize
      @deck = Deck.new
      @deck.shuffle
      @community_cards = []
    end

    def deal_hole_cards(players)
      raise ArgumentError unless players.map { |player| player.hole_cards.count == 0 }.all?
      players.each do |player|
        2.times { player.hole_cards << @deck.deal }
      end
    end

    def deal_community_cards(stage)
      raise ArgumentError unless %w(pre_flop flop turn river show_down).include?(stage)

      if stage == 'pre_flop'
        3.times { community_cards << @deck.deal }
      elsif %w(flop turn).include?(stage)
        community_cards << @deck.deal
      end
    end
  end
end
