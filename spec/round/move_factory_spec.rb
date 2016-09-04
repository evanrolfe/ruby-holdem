require 'spec_helper'


describe RubyHoldem::Round::MoveFactory do
  describe "#build" do
    let(:round) { double(RubyHoldem::Round) }
    let(:stage) { RubyHoldem::Round::STAGES.first }
    let(:player) { double(RubyHoldem::Round::Player) }

    subject { move_factory.build }

    context "with a move_type of call" do
      let(:move_type) { "call" }
      let(:amount) { nil }
      let(:move_factory) { RubyHoldem::Round::MoveFactory.new(round, player, move_type, amount) }
      let(:highest_bet_placed) { 100 }
      let(:current_bet_amount) { 90 }
      let(:expected_amount) { highest_bet_placed - current_bet_amount }

      before do
        allow(round).to receive(:stage).and_return(stage)
        allow(round).to receive(:highest_bet_placed).and_return(highest_bet_placed)
        allow(player).to receive(:current_bet_amount).and_return(current_bet_amount)
      end

      it do
        is_expected.to eq(
          player: player,
          stage: stage,
          move_type: move_type,
          amount: expected_amount
        )
      end
    end

    {
      "raise" => 10,
      "check" => nil,
      "fold" => nil
    }.each do |move_type, amount|
      context "with a move_type of #{move_type}" do
        let(:move_factory) { RubyHoldem::Round::MoveFactory.new(round, player, move_type, amount) }

        before do
          allow(round).to receive(:stage).and_return(stage)
        end

        it do
          is_expected.to eq(
            player: player,
            stage: stage,
            move_type: move_type,
            amount: amount
          )
        end
      end
    end
  end
end
