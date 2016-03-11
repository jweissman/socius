module Socius
  class SocietyIteratedEvent < Metacosm::Event
    attr_accessor :society_id, :production, :micro_production, :player_id
  end
end
