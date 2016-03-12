module Socius
  class PickupCitizenCommand < Metacosm::Command
    attr_accessor :game_id, :citizen_id
  end
end
