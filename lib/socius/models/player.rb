module Socius
  class Player < Metacosm::Model
    attr_accessor :name, :color, :currently_held_citizen
    belongs_to :game
    has_one :society
    has_one :deck
  end
end
