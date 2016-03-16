module Socius
  class SocietyIteratedEvent < Metacosm::Event
    attr_accessor :society_id, :player_id
    attr_accessor :resources
  end
end
