module Socius
  class GameView < Metacosm::View
    include Geometer::PointHelpers
    include Geometer::DimensionHelpers

    attr_accessor :game_id, :dimensions
    attr_accessor :holding_citizen

    has_one :player_view

    def render(window)
      window.background_image.draw(0,0,0)
      window.font.draw(
        "Welcome, #{player_view.name}", 350, 476, 1)

      player_view.render(window)
      draw_cursor(window)
    end

    def draw_cursor(window)
      mouse = mouse_position(window)
      window.cursor.draw(mouse.x, mouse.y,2)

      if holding_citizen
        window.citizen_image.draw(mouse.x, mouse.y, 3)
      end
    end

    def clicked(at:)
      clicked_job_tab = city_job_menu.detect do |tab, rect|
        rect.contains?(at)
      end&.first

      if clicked_job_tab && clicked_job_tab.citizen_ids.any?
        # puts "---> clicked job #{clicked_job_tab.name}"
        PickupCitizenCommand.create(game_id: game_id, citizen_id: clicked_job_tab.citizen_ids.last)
      elsif clicked_job_tab && holding_citizen
        puts "---> clicked to assign job #{clicked_job_tab.name}"
        DropCitizenCommand.create(game_id: game_id, new_job_name: clicked_job_tab.name)
      end
    end

    protected
    def mouse_position(window)
      coord(window.mouse_x, window.mouse_y)
    end

    def focused_city_view
      player_view.focused_city_view
    end

    def city_job_menu
      focused_city_view.job_view_bounding_boxes
    end
  end
end
