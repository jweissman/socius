module Socius
  class GameView < Metacosm::View
    attr_accessor :game_id, :dimensions
    has_many :player_views

    def render(window)
      window.font.draw("Welcome to Socius", 100, 0, 1)
      player_views.each do |player_view|
        player_view.render(window)
      end
    end
  end
end
