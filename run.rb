require 'ruby_holdem'

round = RubyHoldem::Round.new(3, 2, 4)

puts "Game started"

round_i=0
until round.has_winner?
  puts "----------------------\n#{round.current_stage} , pot: $#{round.pot_amount}\n----------------------"

  i=0
  until round.ready_for_next_stage?

    next_move_args = [
        ['bet', 4],
        ['call'],
        ['fold']
      ].sample

    round.make_move(*next_move_args)

    if round.last_move[:move] == 'bet'
      puts "Player #{round.last_move[:player].name} raised by #{round.last_move[:amount]}"
    elsif round.last_move[:move] == 'call'
      puts "Player #{round.last_move[:player].name} called by #{round.last_move[:amount]}"
    else
      puts "Player #{round.last_move[:player].name} folded"
    end

    sleep 0.3
    i += 1
  end

  round.next_stage
  round_i += 1
end
