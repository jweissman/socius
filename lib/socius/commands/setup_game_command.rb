module Socius
  class SetupGameCommand < Metacosm::Command
    attr_accessor :game_id, :player_name, :player_id, :city_name, :city_id
  end
end
