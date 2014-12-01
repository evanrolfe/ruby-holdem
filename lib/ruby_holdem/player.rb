module RubyHoldem
  class Player
    attr_reader :id
    attr_accessor :bank_roll

    def initialize(id, bank_roll)
      @id, @bank_roll = id, bank_roll
    end
  end
end
