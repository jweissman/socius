module Socius
  class GameView < Metacosm::View
    include Geometer::PointHelpers
    include Geometer::DimensionHelpers

    attr_accessor :game_id, :dimensions
    has_one :player_view

    def render(window)
      window.font.draw("Welcome to Socius", 100, 0, 1)

      player_view.render(window)
    end

    def clicked(at:)
      p [ :clicked, at: at ]

      clicked_job = city_job_menu.detect do |tab, rect|
        rect.contains?(at)
      end&.first

      if clicked_job
        puts "---> clicked job #{clicked_job}"
      end

      nil
    end

    def city_job_menu
      {
        :farm => Geometer::Rectangle.new(coord(0,0), dim(80,80)),
        :mine => Geometer::Rectangle.new(coord(80,0), dim(80,80)),
        :pray => Geometer::Rectangle.new(coord(160,0), dim(80,80))
      }
    end
  end
end
