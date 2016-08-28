require 'rspec'
require 'rspec/its'
require 'pry'
require 'ruby_holdem'

RSpec.configure do |config|
  config.color = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
