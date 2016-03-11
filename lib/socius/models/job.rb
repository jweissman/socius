module Socius
  class Job < Metacosm::Model
    attr_accessor :name
    attr_accessor :production, :food, :research, :gold
    # attr_accessor :faith, :culture, :morale

    has_many :citizens
    after_create { @production ||= 1 }

    def self.farmer
      @farmer ||= Job.create(name: "Farmer", production: 1, food: 2, research: 0, gold: 0)
    end
  end
end
