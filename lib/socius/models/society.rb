module Socius
  class Society < Metacosm::Model
    attr_accessor :name, :game_id

    RESOURCE_LIMIT = 6
    RESOURCE_NAMES = %w[ production gold research faith culture ]

    belongs_to :world
    belongs_to :player

    has_many :resources
    has_many :cities
    has_many :citizens, :through => :cities

    after_create do
      RESOURCE_NAMES.each do |resource_name|
        create_resource(name: resource_name)
      end
      create_city
    end

    def iterate
      resources.each(&:aggregate!)
      emit iteration_event
    end

    RESOURCE_NAMES.each do |resource_name|
      define_method(resource_name.to_sym) do
        resources.where(name: resource_name).first
      end
    end

    protected
    def iteration_event
      SocietyIteratedEvent.create(
        society_id: self.id,
        player_id: player.id,

        production: production.amount,
        production_progress: production.progress_as_percent,

        gold: gold.amount,
        gold_progress: gold.progress_as_percent,

        research: research.amount,
        research_progress: research.progress_as_percent,

        faith: faith.amount,
        faith_progress: faith.progress_as_percent,

        culture: culture.amount,
        culture_progress: culture.progress_as_percent
      )
    end
  end
end
