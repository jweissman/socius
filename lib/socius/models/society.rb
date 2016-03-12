module Socius
  class Society < Metacosm::Model
    attr_accessor :name, :game_id

    RESOURCE_LIMIT = 6
    PRODUCTION_LIMIT = RESOURCE_LIMIT

    belongs_to :world
    belongs_to :player

    has_many :resources
    has_many :cities
    has_many :citizens, :through => :cities

    after_create do
      create_resource(name: 'production')
      create_resource(name: 'gold')
      create_resource(name: 'research')

      create_city
    end

    def production
      resources.where(name: 'production').first
    end

    def gold
      resources.where(name: 'gold').first
    end

    def research
      resources.where(name: 'research').first
    end

    def iterate
      resources.each(&:aggregate!)
      # accumulate 100 micro-resources ---> create a new resource!
      # aggregate_resources!
      emit iteration_event
    end

    def iteration_event
      SocietyIteratedEvent.create(
        society_id: self.id,
        player_id: player.id,
        production: production.amount,
        production_progress: production.progress_as_percent,
        gold: gold.amount,
        gold_progress: gold.progress_as_percent,
        research: research.amount,
        research_progress: research.progress_as_percent
      )
    end
  end
end
