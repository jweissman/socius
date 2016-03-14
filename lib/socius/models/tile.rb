module Socius
  class Tile < Metacosm::Model
    include Geometer::LineHelpers

    attr_accessor :location, :terrain
    belongs_to :world
    belongs_to :city

    def distance_to(other_tile)
      dist(location, other_tile.location)
    end

    def neighbors
      root_2 = Math.sqrt(2)
      Tile.all.select { |neighbor| distance_to(neighbor) <= root_2 }
    end

    def self.at(xy)
      where(location: xy)
    end

    def self.grass
      where(terrain: 'grass')
    end
  end
end
