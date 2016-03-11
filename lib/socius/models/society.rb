module Socius
  class Society < Metacosm::Model
    attr_accessor :name, :production, :game_id

    PRODUCTION_LIMIT = 6

    belongs_to :world
    belongs_to :player
    has_many :cities
    has_many :citizens, :through => :cities

    after_create { @production = 0; create_city }

    def iterate
      aggregate_production!
      emit(SocietyIteratedEvent.create(society_id: id, production: @production, player_id: player.id))
    end

    protected
    def aggregate_production!
      if @production < PRODUCTION_LIMIT
        @production += citizens.sum :production
      end
    end
  end
end
