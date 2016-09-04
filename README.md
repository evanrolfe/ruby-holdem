# RubyHoldem
RubyHoldem is a set of classes which track the game state of a texas holdem poker game.

### Installation
```
gem install ruby_holdem
```

### Usage
```ruby
require 'ruby_holdem'

players = ["Jack", "Joe", "Jil"]
poker_round = RubyHoldem::Round.new(players, 2, 4)

poker_round.make_move('raise', 2) # Jack raises small blinds
poker_round.make_move('raise', 4) # Joe raises big blinds
poker_round.make_move('fold') # Jil folds
poker_round.make_move('call') # Jack calls
poker_round.make_move('check') # Joe calls
poker_round.next_stage

puts poker_round.community_cards.join(' ')
# => i.e. 3s Js Qd

puts poker_round.pot_amount
# => 8

poker_round.make_move('raise', 3) # Jack raises 3
poker_round.make_move('fold') # Joe folds

puts poker_round.winner
# => Jack
```

### TODO
- Break monolithic ```Round``` class into smaller classes, i.e. ```Round```, ```RoundState``` and ```RoundPlayerMove```
- Use rspec 3 style (subjects, expects etc.)
- Get rid of the stubbing of action_history instance var in round_spec.rb
- Have ```Game``` keep track of an entire poker game consisting of multiple rounds

### License

RubyHoldem uses the MIT license. Please check the [LICENSE](https://github.com/evanrolfe/ruby-holdem/blob/master/LICENSE) file for more details.
