module Socius
  class Job < Metacosm::Model
    attr_accessor :name
    attr_accessor :production, :food, :research, :gold, :faith, :culture
    has_many :citizens

    def self.citizen_job_list
      [ farmer, dreamer, miner, acolyte, merchant, scholar ]
    end

    def self.farmer
      @farmer ||= Job.create(
        name: "farm",
        production: 0,
        food: 3,
        research: 0,
        gold: 0,
        faith: 0,
        culture: 0
      )
    end

    def self.dreamer
      @dreamer ||= Job.create(
        name: "dream",
        production: 0,
        food: -1,
        research: 1,
        gold: 0,
        faith: 0,
        culture: 3
      )
    end

    def self.miner
      @miner ||= Job.create(
        name: "mine",
        production: 2,
        food: 0,
        research: 0,
        gold: 1,
        faith: 0,
        culture: 0 
      )

    end

    def self.acolyte
      @acolyte ||= Job.create(
        name: "pray",
        production: 0,
        food: -1,
        research: 0,
        gold: 0,
        faith: 2,
        culture: 1
      )
    end

    def self.scholar
      @scholar ||= Job.create(
        name: "study",
        production: 0,
        food: -1,
        research: 2,
        gold: 0,
        faith: 0,
        culture: 1
      )
    end

    def self.merchant
      @merchant ||= Job.create(
        name: "trade",
        production: 1,
        food: -1,
        research: 0,
        gold: 2,
        faith: 0,
        culture: 0
      )
    end
  end
end
