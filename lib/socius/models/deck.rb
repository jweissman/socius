module Socius
  class Deck < Metacosm::Model
    belongs_to :player
    has_many :cards

    after_create do
      3.times { cards.push(Card.build_city) }
    end
  end
end
