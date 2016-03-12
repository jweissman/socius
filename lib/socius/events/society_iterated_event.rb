module Socius
  class SocietyIteratedEvent < Metacosm::Event
    attr_accessor :society_id, :player_id
    attr_accessor :production, :micro_production
    attr_accessor :gold, :micro_gold
  end
end
