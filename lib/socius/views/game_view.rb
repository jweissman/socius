module Socius
  class GameView < Metacosm::View
    attr_accessor :game_id, :dimensions, :progress_towards_step
    has_many :player_views

    def render(window)
      window.font.draw("Welcome to Socius", 100, 10, 1)
      window.font.draw("#{(progress_towards_step*100.0).to_i}%", 100, 40, 1) if progress_towards_step
      player_views.each do |player_view|
        player_view.render(window, progress_towards_step)
      end
    end
  end
end
