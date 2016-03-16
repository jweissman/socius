module Socius
  class Card < Metacosm::Model
    belongs_to :deck
    attr_accessor :name

    # has_many :effects
    # rarity? type? cost? flavor?

    def self.build_city
      @build_city ||= Card.create(name: "Found City")
    end
  end
end
