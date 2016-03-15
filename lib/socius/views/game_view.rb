module Socius
  class GameView < Metacosm::View
    include Geometer::PointHelpers
    include Geometer::DimensionHelpers

    attr_accessor :game_id, :dimensions
    attr_accessor :holding_citizen

    has_one :world_view
    has_one :player_view
    has_many :city_views, :through => :player_view

    def render(window)
      window.socius_logo.draw(0,552,1)
      if player_view&.focused_city_view&.location
        # TODO move this update into listener?
        world_view.center = player_view.focused_city_view.location
        world_view.render(window)
      else
        # TODO track current center...?
        world_view&.render(window)
      end

      player_view&.render(window)

      window.big_logo.draw(160,100,0) if player_view.nil?

      draw_cursor(window)
    end

    def draw_cursor(window, debug: false)
      mouse = mouse_position(window)
      window.cursor.draw(mouse.x, mouse.y,2)

      if holding_citizen
        window.citizen_image.draw(mouse.x, mouse.y, 3)
      end

      if debug && world_view && world_view.center
        tile_location = world_view.dereference_map_location_from_screen_position(mouse, window: window)
        window.font.draw(tile_location.to_s, 10, 10, 1)
      end
    end

    def clicked(window, at:)
      clicked_job_tab = player_view.focused_city_id && city_job_menu.detect do |tab, rect|
        rect.contains?(at)
      end&.first

      if clicked_job_tab && clicked_job_tab.citizen_ids.any? && !holding_citizen
        # puts "---> clicked job #{clicked_job_tab.name}"
        PickupCitizenCommand.create(game_id: game_id, citizen_id: clicked_job_tab.citizen_ids.last)
      elsif clicked_job_tab && holding_citizen
        puts "---> clicked to assign job #{clicked_job_tab.name}"
        DropCitizenCommand.create(game_id: game_id, new_job_name: clicked_job_tab.name)

      else # assume we're trying to click to scroll somewhere in the world
        # need to dereference mouse location...
        mouse = mouse_position(window)
        map_location = world_view.dereference_map_location_from_screen_position(mouse, window: window)

        ScrollToLocationCommand.create(game_id: game_id, location: map_location)
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
