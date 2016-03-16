module Socius
  class ScrollToLocationCommand < Metacosm::Command
    attr_accessor :game_id, :player_id, :location
  end
end
