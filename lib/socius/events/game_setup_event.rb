module Socius
  class GameSetupEvent < Metacosm::Event
    attr_accessor :world_id, :world_map, :game_dimensions, :game_id
    attr_accessor :player_one_details, :player_two_details
  end
end
