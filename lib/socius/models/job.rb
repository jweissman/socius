module Socius
  class Job < Metacosm::Model
    attr_accessor :name
    attr_accessor :production, :food, :research, :gold, :faith, :culture
    has_many :citizens

    def self.farmer
      @farmer ||= Job.create(
        name: "Farmer",
        production: 1,
        food: 3,
        research: 2,
        gold: 3,
        faith: 1,
        culture: 2
      )
    end
  end
end
