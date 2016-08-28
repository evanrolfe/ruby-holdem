describe RubyHoldem::Dealer do

  let(:players) do
    [
      RubyHoldem::Player.new(0, 100),
      RubyHoldem::Player.new(1, 100),
      RubyHoldem::Player.new(2, 100),
    ]
  end

  let(:round) { RubyHoldem::Round.new(players, 1, 2) }

  describe '#deal_hole_cards' do
    context 'with no hole cards dealt' do
      before do
        round.dealer.deal_hole_cards
      end

      it { expect(round.players[0].hole_cards.length).to eq(2) }
      it { expect(round.players[1].hole_cards.length).to eq(2) }
      it { expect(round.players[2].hole_cards.length).to eq(2) }
    end

    context 'with hole cards already dealt' do
      before do
        round.dealer.deal_hole_cards
      end

      it { expect{round.dealer.deal_hole_cards}.to raise_error }
    end
  end

  describe '#deal_community_cards' do
    context 'on the pre_flop' do
      before do
        round.dealer.deal_community_cards('pre_flop')
      end

      it { expect(round.dealer.community_cards.count).to eq(3) }
    end

    context 'on the flop' do
      before do
        round.dealer.deal_community_cards('flop')
      end

      it { expect(round.dealer.community_cards.count).to eq(1) }
    end

    context 'on the turn' do
      before do
        round.dealer.deal_community_cards('turn')
      end

      it { expect(round.dealer.community_cards.count).to eq(1) }
    end
  end
end
