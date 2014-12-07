describe RubyHoldem::RoundPlayer do
  let(:players) do
    [
      RubyHoldem::Player.new(0, 100),
      RubyHoldem::Player.new(1, 100),
      RubyHoldem::Player.new(2, 100),
    ]
  end

  let(:round) { RubyHoldem::Round.new(players, 1, 2) }

  #TODO: Change this into before: make_move()...
  let(:action_history) do
    [
      { stage: 'pre_flop', player: round.players[0], amount: 1, move: 'bet' },
      { stage: 'pre_flop', player: round.players[1], amount: 4, move: 'bet' },
      { stage: 'pre_flop', player: round.players[2], amount: 0, move: 'fold'},
      { stage: 'pre_flop', player: round.players[0], amount: 1, move: 'bet' }
    ]
  end

  before do
    allow(round).to receive(:action_history).and_return(action_history)
  end

  describe 'delegates methods to @player' do
    describe '#id' do
      it { expect(round.players[0].id).to eq(players[0].id) }
      it { expect(round.players[1].id).to eq(players[1].id) }
      it { expect(round.players[2].id).to eq(players[2].id) }
    end

    describe '#bank_roll' do
      it { expect(round.players[0].bank_roll).to eq(100) }
      it { expect(round.players[1].bank_roll).to eq(100) }
      it { expect(round.players[2].bank_roll).to eq(100) }
    end
  end

  describe '#current_bet_amount' do
    describe 'for player 0' do
      subject { round.players[0].current_bet_amount }
      it { should eq(2) }
    end

    describe 'for player 1' do
      subject { round.players[1].current_bet_amount }
      it { should eq(4) }
    end

    describe 'for player 2' do
      subject { round.players[2].current_bet_amount }
      it { should eq(0) }
    end
  end

  describe '#amount_to_call' do
    describe 'for player 0' do
      subject { round.players[0].amount_to_call }
      it { should eq(2) }
    end

    describe 'for player 1' do
      subject { round.players[1].amount_to_call }
      it { should eq(0) }
    end

    describe 'for player 2' do
      subject { round.players[2].amount_to_call }
      it { should eq(4) }
    end
  end

  describe '#can_afford_to_bet?' do
    describe 'for player 0' do
      subject { round.players[0].can_afford_to_bet?(1) }
      xit { should eq(2) }
    end

    describe 'for player 1' do
      subject { round.players[1].can_afford_to_bet?(1) }
      xit { should eq(0) }
    end

    describe 'for player 2' do
      subject { round.players[2].can_afford_to_bet?(1) }
      xit { should eq(4) }
    end
  end

end
