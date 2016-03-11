module Socius
  class SocietyIteratedEvent < Metacosm::Event
    attr_accessor :society_id, :production, :player_id
  end
end
