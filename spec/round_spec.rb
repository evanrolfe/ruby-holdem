require 'ostruct'

describe RubyHoldem::Round do
  let(:player1) { OpenStruct.new(name: "Player #1") }
  let(:player2) { OpenStruct.new(name: "Player #2") }
  let(:player3) { OpenStruct.new(name: "Player #3") }
  let(:players) { [player1, player2, player3] }

  let(:round) { RubyHoldem::Round.new(players, 1, 2) }

  describe '#initialize' do
    subject { round }

    # TODO: Convert all instances of "should" to "is_expected"
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
      # TODO: Convert the stubbing of the action_history to a sequence of make_move calls in a
      #       before block
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
    before do
      round.make_move('call')
      round.make_move('call')
      round.make_move('bet', 4)
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
