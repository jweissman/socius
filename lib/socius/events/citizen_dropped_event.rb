module Socius
  class CitizenDroppedEvent < Metacosm::Event
    # TODO needs player_id...
    attr_accessor :game_id, :player_id
  end
end
