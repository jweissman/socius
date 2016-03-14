module Socius
  class World < Metacosm::Model
    include Geometer::DimensionHelpers
    include Geometer::PointHelpers

    attr_accessor :name, :dimensions
    belongs_to :game
    has_many :societies
    has_many :cities, :through => :societies
    has_many :tiles

    before_create :ensure_dimensions_exist
    after_create :build_tiles

    def iterate
      societies.each(&:iterate)
      emit(iteration_event)
    end

    protected
    def iteration_event
      WorldIteratedEvent.create(
        world_id: self.id,
        tile_map: tile_map
      )
    end

    def tile_map
      Hash[
        tiles.map do |tile|
          [ tile.location, tile.terrain ]
        end
      ]
    end

    private
    def ensure_dimensions_exist
      @dimensions = dim(20,20)
    end

    def build_tiles
      dimensions.all_locations.each do |xy|
        terrain = rand > 0.1 ? 'grass' : 'water'
        create_tile(location: xy, terrain: terrain)
      end
    end
  end
end
