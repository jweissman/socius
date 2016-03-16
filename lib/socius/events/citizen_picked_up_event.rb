module Socius
  class CitizenPickedUpEvent < Metacosm::Event
    attr_accessor :game_id, :player_id
  end
end
