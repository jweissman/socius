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

    def clicked(at:)
      # hit_city_job_tab = city_job_menu.tabs.detect { |tab| tab.hit?(at) }
      # if hit_city_job_tab
      #   # need to fire a command...
      #   GrabCitizenByTheHairCommand.create()
      # end
    end

    # def city_job_menu

    # end
  end
end
