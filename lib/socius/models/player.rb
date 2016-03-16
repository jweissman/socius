module Socius
  class Player < Metacosm::Model
    attr_accessor :name, :color
    belongs_to :game
    has_one :society
    has_one :deck
  end
end
