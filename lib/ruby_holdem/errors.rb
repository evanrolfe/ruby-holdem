module RubyHoldem
  class PokerError < StandardError
  end

  class MinBetNotMeet < PokerError
  end

  class NotEnoughMoney < PokerError
  end

  class MustBetSmallBlinds < PokerError
  end

  class MustBetBigBlinds < PokerError
  end
end
