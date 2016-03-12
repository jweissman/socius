module Socius
  class Job < Metacosm::Model
    attr_accessor :name
    attr_accessor :production, :food, :research, :gold, :faith, :culture
    # attr_accessor :faith, :culture, :morale

    has_many :citizens
    after_create { 
      # zero out anything the job didn't specify
      # @production ||= 0 
      # @food ||= 0 
      # @gold ||= 0 
      # @faith ||= 0 
      # @culture ||= 0 
      # @research ||= 0 
    }

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
