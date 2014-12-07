describe RubyHoldem::Round do

  let(:players) do
    [
      RubyHoldem::Player.new(0, 100),
      RubyHoldem::Player.new(1, 100),
      RubyHoldem::Player.new(2, 100),
    ]
  end

  let(:round) { RubyHoldem::Round.new(players, 1, 2) }

  describe '#initialize' do
    subject { round }

    it 'creates three RoundPlayers' do
      expect(subject.players[0].player).to eq(players[0])
      expect(subject.players[1].player).to eq(players[1])
      expect(subject.players[2].player).to eq(players[2])
    end
    its(:small_blinds) { should eq(1) }
    its(:big_blinds) { should eq(2) }
    its(:current_stage) { should eq('pre_flop') }
    its(:action_history) { should eq([]) }
  end

  describe '#next_stage' do
    before do
      allow(round).to receive(:action_history).and_return(action_history)
    end

    context 'on the pre_flop' do
      let(:action_history) do
        [
          { stage: 'pre_flop', player: round.players[0], amount: 1, move: 'bet' },
          { stage: 'pre_flop', player: round.players[1], amount: 0, move: 'fold' },
          { stage: 'pre_flop', player: round.players[2], amount: 1, move: 'call' },
          { stage: 'pre_flop', player: round.players[0], amount: 0, move: 'call' }
        ]
      end

      before do
        round.next_stage
      end

      it { expect(round.current_stage).to eq('flop') }
    end
  end

  describe '#ready_for_next_stage?' do
    before do
      allow(round).to receive(:action_history).and_return(action_history)
    end

    subject { round.ready_for_next_stage? }

    context 'on game start' do
      let(:action_history) { [] }

      it { should eq(false) }
    end

    context 'on the pre_flop' do

      context 'situation 1' do
        let(:action_history) do
          [
            { stage: 'pre_flop', player: round.players[0], amount: 1, move: 'bet' },
            { stage: 'pre_flop', player: round.players[1], amount: 0, move: 'fold' }
          ]
        end
        it { should eq(false) }
      end

      context 'situation 2' do
        let(:action_history) do
          [
            { stage: 'pre_flop', player: round.players[0], amount: 1, move: 'bet' },
            { stage: 'pre_flop', player: round.players[1], amount: 0, move: 'fold' },
            { stage: 'pre_flop', player: round.players[2], amount: 1, move: 'call' },
            { stage: 'pre_flop', player: round.players[0], amount: 0, move: 'call' }
          ]
        end

        it { should eq(true) }
      end

    end

    context 'on the flop' do

      context 'situation 1' do
        let(:action_history) do
          [
            { stage: 'pre_flop', player: round.players[0], amount: 1, move: 'bet' },
            { stage: 'pre_flop', player: round.players[1], amount: 0, move: 'fold' },
            { stage: 'pre_flop', player: round.players[2], amount: 1, move: 'call' },
            { stage: 'flop', player: round.players[0], amount: 1, move: 'bet' }
          ]
        end

        before do
          allow(round).to receive(:current_stage).and_return('flop')
        end

        it { should eq(false) }
      end

      context 'situation 2' do
        let(:action_history) do
          [
            { stage: 'pre_flop', player: round.players[0], amount: 1, move: 'bet' },
            { stage: 'pre_flop', player: round.players[1], amount: 0, move: 'fold' },
            { stage: 'pre_flop', player: round.players[2], amount: 1, move: 'call' },
            { stage: 'pre_flop', player: round.players[0], amount: 0, move: 'call' },
            { stage: 'flop', player: round.players[0], amount: 3, move: 'bet' },
            { stage: 'flop', player: round.players[2], amount: 3, move: 'call' },
            { stage: 'flop', player: round.players[0], amount: 0, move: 'call' }
          ]
        end

        before do
          allow(round).to receive(:current_stage).and_return('flop')
        end

        it { should eq(true) }
      end

    end
  end

  describe '#player_in_turn' do
    let(:action_history) do
      [
        { stage: 'pre_flop', player: round.players[0], amount: 1, move: 'bet' },
        { stage: 'pre_flop', player: round.players[1], amount: 0, move: 'fold' }
      ]
    end

    before do
      allow(round).to receive(:action_history).and_return(action_history)
    end

    subject { round.send(:player_in_turn) }

    it { should == round.players[2] }
  end

  describe '#players_still_in_round' do
    let(:action_history) do
      [
        { stage: 'pre_flop', player: round.players[0], amount: 1, move: 'bet' },
        { stage: 'pre_flop', player: round.players[1], amount: 0, move: 'fold' }
      ]
    end

    before do
      allow(round).to receive(:action_history).and_return(action_history)
    end

    subject { round.send(:players_still_in_round) }

    its([0]) { should eq(round.players[0]) }
    its([1]) { should eq(round.players[2]) }
  end

  describe '#highest_bet_placed' do
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

    subject { round.send(:highest_bet_placed) }

    it { should eq(4) }
  end

  describe '#has_winner?' do
    subject { round.has_winner? }

    context 'round won after folds' do
      let(:action_history) do
        [
          { stage: 'pre_flop', player: round.players[0], amount: 1, move: 'bet' },
          { stage: 'pre_flop', player: round.players[1], amount: 4, move: 'bet' },
          { stage: 'pre_flop', player: round.players[2], amount: 0, move: 'fold'},
          { stage: 'pre_flop', player: round.players[0], amount: 3, move: 'call' },
          { stage: 'flop', player: round.players[1], amount: 0, move: 'call' },
          { stage: 'flop', player: round.players[0], amount: 0, move: 'fold' }
        ]
      end

      before do
        allow(round).to receive(:action_history).and_return(action_history)
      end

      it { should eq(true) }
    end

    context 'showdown between remaining players' do
      before do
        allow(round).to receive(:current_stage).and_return('show_down')
      end

      it { should eq(true) }
    end
  end

  describe '#winner' do

  end

  describe '#apply_bet' do
    context 'at the start of the round' do
      before do
        round.send(:apply_bet, 1)
      end

      subject { round }

      its(:action_history) { should eq([{ player: round.players[0], stage: 'pre_flop', move: 'bet', amount: 1 }]) }
      its(:pot_amount) {  should eq(1) }
    end

    context 'when the amount to call is 2' do
      before do
        allow(round.players[0]).to receive(:amount_to_call).and_return(2)
      end

      it { expect{ round.send(:apply_bet, 1) }.to raise_error(RubyHoldem::MinBetNotMeet) }
    end
  end

  describe '#apply_call' do
    context 'at the start of the round' do
      before do
        round.send(:apply_call)
      end

      subject { round }

      its(:action_history) { should eq([{ player: round.players[0], stage: 'pre_flop', move: 'call', amount: 0 }]) }
      its(:pot_amount) {  should eq(0) }
    end

    context 'when the previous player has raised' do

    end
  end

  describe '#apply_fold' do
    context 'at the start of the round' do
      before do
        round.send(:apply_fold)
      end

      subject { round }

      its(:action_history) { should eq([{ player: round.players[0], stage: 'pre_flop', move: 'fold', amount: 0 }]) }
      its(:pot_amount) {  should eq(0) }
    end
  end
end
