require 'spec_helper'


describe RubyHoldem::Round::MoveValidator do
  describe "#validate" do
    let(:round) { double(RubyHoldem::Round) }
    let(:player) { double(RubyHoldem::Round::Player) }

    context "with a move_type of raise" do
      pending
    end

    context "with a move_type of call" do
      pending
    end

    context "with a move_type of check" do
      pending
    end

    context "with a move_type of fold" do
      pending
    end
  end
end
