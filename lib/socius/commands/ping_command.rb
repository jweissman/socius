module Socius
  class PingCommand < Metacosm::Command
    attr_accessor :game_id, :player_name, :player_id
  end
end