require 'bundler'
Bundler.require
Dir.glob('./lib/*.rb') do |model|
  require model
end
# require './lib/game.rb'
# require './lib/player_list.rb'
# require './lib/mafia_list.rb'
# require './lib/character_list.rb'
# require './lib/civilian_list.rb'
require 'twilio-ruby'

class App < Sinatra::Application

  # currently only includes test sid/token/number
  account_sid = "AC24cbd663ebeb7a86d0219d62206409a8"
  # ENV['TWILIO_ACCOUNT_SID']
  auth_token = "e12190dedbe20350bafb19f062edec98"
  # ENV['TWILIO_AUTH_TOKEN']
  twilio_number = "+15005550006"
  # ENV['TWILIO_NUMBER']
  twilio = Twilio::REST::Client.new account_sid, auth_token

  from  = twilio_number

  possible_players = Player.new
  players = MafiaGame.new(possible_players.playing)
  players.player_count
  players.mafia_roles
  players.civilian_roles
  players.civilians
  role_hash = players.assign_roles_hash

  role_hash.each do |key, value|
    twilio.account.messages.create(
      :from => from,
      :to => key,
      :body => value
      )
    puts "Sent message to #{value}"
  end

end



