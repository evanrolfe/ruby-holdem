require 'spec_helper'

describe RubyHoldem::Round::MoveHistory do
  let(:player1) { RubyHoldem::Round::Player.new("Jack") }
  let(:player2) { RubyHoldem::Round::Player.new("Joe") }
  let(:player3) { RubyHoldem::Round::Player.new("Jil") }
  let(:players) { [player1, player2, player3] }

  let(:move_history) { RubyHoldem::Round::MoveHistory.new }

  describe "#add_move" do
    let(:move) { double }

    subject! { move_history.add_move(move) }

    it { expect(move_history.moves.last).to eq(move) }
  end

  describe "#last_move" do
    let(:move) { double }

    before do
      move_history.add_move(move)
    end

    subject { move_history.last_move }

    it { is_expected.to eq(move) }
  end

  describe "#turns_played" do
    subject { move_history.turns_played }

    it { is_expected.to eq(0) }
  end

  describe "#next_stage" do
    subject! { move_history.next_stage }

    it { expect(move_history.stage).to eq(RubyHoldem::Round::STAGES[1]) }
  end
end
