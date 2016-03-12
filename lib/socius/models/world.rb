module Socius
  class World < Metacosm::Model
    attr_accessor :name, :dimensions
    belongs_to :game
    has_many :societies
    has_many :cities, :through => :societies

    def iterate
      societies.each(&:iterate)
    end
  end
end
