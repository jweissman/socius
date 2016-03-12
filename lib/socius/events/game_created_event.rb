module Socius
  class GameCreatedEvent < Metacosm::Event
    attr_accessor :game_id, :dimensions
  end
end
