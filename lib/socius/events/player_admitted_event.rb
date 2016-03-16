module Socius
  class PlayerAdmittedEvent < Metacosm::Event
    attr_accessor :game_id, :player_details, :world_id, :world_map
  end
end
