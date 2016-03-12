module Socius
  class Society < Metacosm::Model
    attr_accessor :name, :production, :game_id

    RESOURCE_LIMIT = 6
    PRODUCTION_LIMIT = RESOURCE_LIMIT

    belongs_to :world
    belongs_to :player
    has_many :cities
    has_many :citizens, :through => :cities

    after_create do
      @production = 0
      @micro_production = 0

      @gold = 0
      @micro_gold = 0

      create_city
    end

    def iterate
      # accumulate 100 micro-resources ---> create a new resource!
      aggregate_resources!
      emit iteration_event
    end

    def iteration_event
      SocietyIteratedEvent.create(
        society_id: self.id,
        player_id: player.id,
        production: @production,
        micro_production: @micro_production,
        gold: @gold,
        micro_gold: @micro_gold
      )
    end

    protected
    def aggregate_resources!
      aggregate_production!
      aggregate_gold!
    end

    def aggregate_gold!
      step = Game::STEP_LENGTH_IN_TICKS
      if @gold < PRODUCTION_LIMIT
        @micro_gold += citizens.sum(:gold)
        if @micro_gold >= step
          @gold += 1
          @micro_gold -= step
        end
      end
    end

    def aggregate_production!
      step = Game::STEP_LENGTH_IN_TICKS
      if @production < PRODUCTION_LIMIT
        @micro_production += citizens.sum(:production)
        if @micro_production >= step
          @production += 1
          @micro_production -= step
        end
      end
    end
  end
end
