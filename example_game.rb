require 'ruby_holdem'
require 'ostruct'
line_break = "\n----------------------\n"

player1 = OpenStruct.new(name: "Player #1")
player2 = OpenStruct.new(name: "Player #2")
player3 = OpenStruct.new(name: "Player #3")
players = [player1, player2, player3]

poker_round = RubyHoldem::Round.new(players, 2, 4)

puts "Game started"

until poker_round.has_winner?
  puts "#{line_break}#{poker_round.current_stage} , pot: $#{poker_round.pot_amount}"
  if poker_round.community_cards.any?
    puts "Community cards: #{poker_round.community_cards.join(' ')}#{line_break}"
  end

  until poker_round.ready_for_next_stage?
    next_move_args = [
        ['bet', 4],
        ['call'],
        ['fold']
      ].sample

    poker_round.make_move(*next_move_args)

    if poker_round.last_move[:move] == 'bet'
      puts "Player #{poker_round.last_move[:player].name} raised by #{poker_round.last_move[:amount]}"
    elsif poker_round.last_move[:move] == 'call'
      puts "Player #{poker_round.last_move[:player].name} called by #{poker_round.last_move[:amount]}"
    else
      puts "Player #{poker_round.last_move[:player].name} folded"
    end

    sleep 0.3
  end

  poker_round.next_stage
end

puts "The winner is #{poker_round.winner.name}!"
