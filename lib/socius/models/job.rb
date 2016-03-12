module Socius
  class Job < Metacosm::Model
    attr_accessor :name
    attr_accessor :production, :food, :research, :gold, :faith, :culture
    has_many :citizens

    def self.farmer
      @farmer ||= Job.create(
        name: "farm",
        production: 1,
        food: 3,
        research: 2,
        gold: 3,
        faith: 1,
        culture: 2
      )
    end

    def self.dreamer
      @dreamer ||= Job.create(
        name: "dream",
        production: 0,
        food: 0,
        research: 1,
        gold: 0,
        faith: 0,
        culture: 3
      )
    end
  end
end
