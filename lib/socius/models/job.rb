module Socius
  class Job < Metacosm::Model
    attr_accessor :name
    attr_accessor :production, :food, :research, :gold
    # attr_accessor :faith, :culture, :morale

    has_many :citizens
    after_create { @production ||= 1 }

    def self.farmer
      @farmer ||= Job.create(name: "Farmer", production: 1, food: 3, research: 0, gold: 1)
    end
  end
end
