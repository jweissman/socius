module Socius
  class PlayerScrolledEvent < Metacosm::Event
    attr_accessor :game_id, :location, :player_id
  end
end
