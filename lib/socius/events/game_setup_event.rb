module Socius
  class GameSetupEvent < Metacosm::Event
    attr_accessor :world_id, :game_id, :player_id, :player_name, :city_id, :city_name
  end
end
