module Socius
  class SocietyIteratedEvent < Metacosm::Event
    attr_accessor :society_id, :player_id
    attr_accessor :production, :production_progress
    attr_accessor :gold, :gold_progress
    attr_accessor :research, :research_progress
    attr_accessor :faith, :faith_progress
    attr_accessor :culture, :culture_progress
  end
end
