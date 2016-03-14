module Socius
  class Tile < Metacosm::Model
    attr_accessor :location, :terrain
    belongs_to :world
    belongs_to :city

    def self.at(xy)
      where(location: xy)
    end

    def self.grass
      where(terrain: 'grass')
    end
  end
end
