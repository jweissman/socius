module Socius
  class PlayerScrolledEvent < Metacosm::Event
    attr_accessor :game_id, :location
  end
end
