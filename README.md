# RubyHoldem
RubyHoldem is a set of classes which track the game state of a texas holdem poker game.

### Installation
```
git clone git@github.com:evanrolfe/ruby-holdem.git
cd ruby-holdem/
gem install ruby-holdem
```

### Usage
```ruby
require 'ruby_holdem'

players = ["Jack", "Joe", "Jil"]
poker_round = RubyHoldem::Round.new(players, 2, 4)

poker_round.make_move('bet', 2) # Jack bets small blinds
poker_round.make_move('bet', 4) # Joe bets big blinds
poker_round.make_move('fold') # Jil folds
poker_round.make_move('call') # Jack calls
poker_round.make_move('call') # Joe calls
poker_round.next_stage

puts poker_round.community_cards.join(' ')
# => i.e. 3s Js Qd

puts poker_round.pot_amount
# => 8

poker_round.make_move('bet', 3) # Jack bets 3
poker_round.make_move('fold') # Joe folds

puts poker_round.winner
# => Jack
```
