module Socius
  class GameSetupEvent < Metacosm::Event
    attr_accessor :game_id, :player_id, :player_name
  end
end
