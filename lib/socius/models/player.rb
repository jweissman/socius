module Socius
  class Player < Metacosm::Model
    attr_accessor :name
    belongs_to :game
    has_one :society
  end
end
