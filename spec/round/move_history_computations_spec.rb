require 'spec_helper'

describe RubyHoldem::Round::MoveHistoryComputations do
  let(:player1) { RubyHoldem::Round::Player.new("Jack") }
  let(:player2) { RubyHoldem::Round::Player.new("Joe") }
  let(:player3) { RubyHoldem::Round::Player.new("Jil") }
  let(:players) { [player1, player2, player3] }

  let(:moves) { [] }
  let(:stage) { RubyHoldem::Round::STAGES.first }
  let(:move_history) { RubyHoldem::Round::MoveHistory.new }
  let(:move_history_computations) do
    RubyHoldem::Round::MoveHistoryComputations.new(players, move_history)
  end

  before do
    allow(move_history).to receive(:moves).and_return(moves)
    allow(move_history).to receive(:stage).and_return(stage)
  end

  describe "#highest_bet_placed" do
    before do
      allow(player1).to receive(:current_bet_amount).and_return(0)
      allow(player2).to receive(:current_bet_amount).and_return(5)
      allow(player3).to receive(:current_bet_amount).and_return(10)
    end

    subject { move_history_computations.highest_bet_placed }

    it { is_expected.to eq(10) }
  end

  describe "#ready_for_next_stage?" do
    context "not every player has checked yet" do
      let(:moves) do
        [
          { stage: 'pre_flop', player: players[0], amount: 10, move: 'raise' },
          { stage: 'pre_flop', player: players[1], amount: nil, move: 'fold' },
          { stage: 'pre_flop', player: players[2], amount: nil, move: 'check' },
          { stage: 'pre_flop', player: players[0], amount: nil, move: 'check' },
        ]
      end

      subject { move_history_computations.ready_for_next_stage? }

      it { is_expected.to be_truthy }
    end

    context "no turns have been played yet in this stage" do
      let(:moves) { [] }

      subject { move_history_computations.ready_for_next_stage? }

      it { is_expected.to be_falsey }
    end
  end

  describe "#has_winner?" do
    context "round won after every other player folds" do
      let(:moves) do
        [
          { stage: 'pre_flop', player: players[0], amount: 1, move: 'raise' },
          { stage: 'pre_flop', player: players[1], amount: 4, move: 'raise' },
          { stage: 'pre_flop', player: players[2], amount: 0, move: 'fold'},
          { stage: 'pre_flop', player: players[0], amount: 3, move: 'check' },
          { stage: 'flop', player: players[1], amount: 0, move: 'check' },
          { stage: 'flop', player: players[0], amount: 0, move: 'fold' }
        ]
      end

      subject { move_history_computations.has_winner? }

      it { is_expected.to be_truthy }
    end

    context "in stage showdown" do
      let(:stage) { RubyHoldem::Round::STAGES.last }

      subject { move_history_computations.has_winner? }

      it { is_expected.to be_truthy }
    end
  end

  describe "#winner" do
    context "round won after every other player folds" do
      let(:moves) do
        [
          { stage: 'pre_flop', player: players[0], amount: 1, move: 'raise' },
          { stage: 'pre_flop', player: players[1], amount: 4, move: 'raise' },
          { stage: 'pre_flop', player: players[2], amount: 0, move: 'fold'},
          { stage: 'pre_flop', player: players[0], amount: 3, move: 'check' },
          { stage: 'flop', player: players[1], amount: 0, move: 'check' },
          { stage: 'flop', player: players[0], amount: 0, move: 'fold' }
        ]
      end

      subject { move_history_computations.winner }

      it "returns the only player who hasn't folded" do
        is_expected.to eq(players[1])
      end
    end

    context "in stage showdown" do
      let(:stage) { RubyHoldem::Round::STAGES.last }

      subject { move_history_computations.winner }

      xit "returns the player with the better hand" do

      end
    end
  end

  describe "#turns_played_in_stage" do
    context "no turns played" do
      let(:moves) { [] }

      subject { move_history_computations.turns_played_in_stage }

      it { is_expected.to eq(0) }
    end

    context "turns played in pre_flop" do
      let(:moves) do
        [
          { stage: 'pre_flop', player: players[0], amount: 1, move: 'raise' },
          { stage: 'pre_flop', player: players[1], amount: 4, move: 'raise' },
          { stage: 'pre_flop', player: players[2], amount: 0, move: 'fold'},
        ]
      end

      subject { move_history_computations.turns_played_in_stage }

      it { is_expected.to eq(3) }
    end

    context "turns played in pre_flop but no turns played in flop" do
      let(:stage) { 'flop' }
      let(:moves) do
        [
          { stage: 'pre_flop', player: players[0], amount: 1, move: 'raise' },
          { stage: 'pre_flop', player: players[1], amount: 4, move: 'raise' },
          { stage: 'pre_flop', player: players[2], amount: 0, move: 'fold'},
          { stage: 'pre_flop', player: players[0], amount: 3, move: 'check' }
        ]
      end

      subject { move_history_computations.turns_played_in_stage }

      it { is_expected.to eq(0) }
    end

    context "turns played in pre_flop and turns played in flop" do
      let(:stage) { 'flop' }
      let(:moves) do
        [
          { stage: 'pre_flop', player: players[0], amount: 1, move: 'raise' },
          { stage: 'pre_flop', player: players[1], amount: 4, move: 'raise' },
          { stage: 'pre_flop', player: players[2], amount: 0, move: 'fold'},
          { stage: 'pre_flop', player: players[0], amount: 3, move: 'check' },
          { stage: 'flop', player: players[1], amount: 0, move: 'check' },
          { stage: 'flop', player: players[0], amount: 0, move: 'fold' }
        ]
      end

      subject { move_history_computations.turns_played_in_stage }

      it { is_expected.to eq(2) }
    end
  end

  describe "#player_in_turn" do
    context "no turns played" do
      let(:moves) { [] }

      subject { move_history_computations.player_in_turn }

      it { is_expected.to eq(player1) }
    end

    context "two turns played" do
      let(:moves) do
        [
          { stage: 'pre_flop', player: players[0], amount: 1, move: 'raise' },
          { stage: 'pre_flop', player: players[1], move: 'fold' }
        ]
      end

      subject { move_history_computations.player_in_turn }

      it { is_expected.to eq(player3) }
    end

    context "three turns played" do
      let(:moves) do
        [
          { stage: 'pre_flop', player: players[0], amount: 1, move: 'raise' },
          { stage: 'pre_flop', player: players[1], move: 'fold' },
          { stage: 'pre_flop', player: players[2], amount: 1, move: 'raise' }
        ]
      end

      subject { move_history_computations.player_in_turn }

      it { is_expected.to eq(player1) }
    end
  end

  describe "#every_player_has_checked?" do
    context "every player has checked yet" do
      let(:moves) do
        [
          { stage: 'pre_flop', player: players[0], amount: 10, move: 'raise' },
          { stage: 'pre_flop', player: players[1], amount: nil, move: 'fold' },
          { stage: 'pre_flop', player: players[2], amount: nil, move: 'check' },
          { stage: 'pre_flop', player: players[0], amount: nil, move: 'check' },
        ]
      end

      subject { move_history_computations.every_player_has_checked? }

      it { is_expected.to be_truthy }
    end

    context "not every player has checked yet" do
      let(:moves) do
        [
          { stage: 'pre_flop', player: players[0], amount: 10, move: 'raise' },
          { stage: 'pre_flop', player: players[1], amount: nil, move: 'fold' },
          { stage: 'pre_flop', player: players[2], amount: nil, move: 'check' }
        ]
      end

      subject { move_history_computations.every_player_has_checked? }

      it { is_expected.to be_falsey }
    end
  end

  describe "#players_still_in_round" do
    context "no players have folded" do
      let(:moves) do
        [
          { stage: 'pre_flop', player: players[0], amount: 10, move: 'raise' },
          { stage: 'pre_flop', player: players[1], amount: 10, move: 'raise' },
          { stage: 'pre_flop', player: players[2], amount: 10, move: 'raise' }
        ]
      end

      subject { move_history_computations.players_still_in_round }

      it { is_expected.to eq([player1, player2, player3]) }
    end

    context "a player has folded" do
      let(:moves) do
        [
          { stage: 'pre_flop', player: players[0], amount: 10, move: 'raise' },
          { stage: 'pre_flop', player: players[1], amount: nil, move: 'fold' },
          { stage: 'pre_flop', player: players[2], amount: nil, move: 'check' }
        ]
      end

      subject { move_history_computations.players_still_in_round }

      it { is_expected.to eq([player1, player3]) }
    end
  end
end
