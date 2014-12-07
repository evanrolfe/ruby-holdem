require 'ruby_holdem'

players = [
  RubyHoldem::Player.new(0, 100),
  RubyHoldem::Player.new(1, 100),
  RubyHoldem::Player.new(2, 100),
]

round = RubyHoldem::Round.new(players, 2, 4)

puts "Game started"

round_i=0
until round.has_winner?
  puts "----------------------\n#{round.current_stage} , pot: $#{round.pot_amount}\n----------------------"

  i=0
  until round.ready_for_next_stage?

    if round_i == 2
      if round.player_in_turn.id == 1 && i == 2
        round.make_move('bet', 5)
      else
        round.make_move('call')
      end
    else
      round.make_move('call')
    end

    if round.last_move[:move] == 'bet'
      puts "Player #{round.last_move[:player].id} raised by #{round.last_move[:amount]}"
    elsif round.last_move[:move] == 'call'
      puts "Player #{round.last_move[:player].id} called by #{round.last_move[:amount]}"
    else
      puts "Player #{round.last_move[:player].id} folded"
    end

    sleep 0.3
    i += 1
  end

  round.next_stage
  round_i += 1
end
