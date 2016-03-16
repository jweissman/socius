module Socius
  class World < Metacosm::Model
    # include Geometer::DimensionHelpers
    extend Geometer::DimensionHelpers
    include Geometer::PointHelpers

    attr_accessor :name, :dimensions
    belongs_to :game
    has_many :societies
    has_many :cities, :through => :societies
    has_many :tiles

    after_create :build_tiles

    def self.standard_dimensions
      dim(10,10)
    end

    def iterate
      societies.each(&:iterate)
    end

    def creation_event
      WorldCreatedEvent.create(
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

    def claimed_tiles
      tiles.where.not(city_id: nil).all
    end

    def random_available_new_city_site(distance_from_cities: 5.0)
      if cities.any?
        # p [ :picking_new_city_sites, existing_city_locations: cities.map(&:location) ]
        tiles_far_away_from_city = tiles.all.select do |tile|
          # p [ :checking_tile, at: tile.location, grass: tile.grass? ]
          tile.grass? && cities.all.all? do |city|
            if city && city.location # TODO investigate why we need this
              dst = tile.distance_to(city)
              # p [ :distance_to_city, dst ]
              dst >= distance_from_cities
            else
              true
            end
          end
        end
        tiles_far_away_from_city.sample.location
      else
        tiles.where.grass.all.sample.location
      end
    end

    private
    def build_tiles
      t0 = Time.now
      raise "Dimensions must exist (and be a dimensions obj)!" unless dimensions && dimensions.is_a?(Geometer::Dimensions)
      p [ :building_tiles ]
      dimensions.all_locations.each do |xy|
        terrain = rand > 0.1 ? 'grass' : 'water'
        create_tile(location: xy, terrain: terrain)
      end
      p [ :tiles_built, elapsed: Time.now - t0 ]
    end
  end
end
