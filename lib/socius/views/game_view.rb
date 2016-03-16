module Socius
  class GameView < Metacosm::View
    include Geometer::PointHelpers
    include Geometer::DimensionHelpers

    attr_accessor :game_id, :dimensions

    has_many :player_views
    has_many :city_views, :through => :player_views

    def render(window, player_id:)
      player_view = player_views.where(player_id: player_id).first
      if player_view
        player_view.render(window) unless player_view.nil? # ?
      else
        window.big_logo.draw(160,100,ZOrder::Background)
      end

      window.socius_logo.draw(0,552,ZOrder::UIOverlay)
    end

    # TODO move this onto player view?
    def command_for_click(window, at:, player_id:)
      p [ :game_view_click, at: at, player_id: player_id ]

      player_view = player_views.where(player_id: player_id).first

      if player_view && player_view.focused_city_view
        city_job_menu = player_view.focused_city_view.job_view_bounding_boxes
        clicked_job_tab = player_view.focused_city_id && city_job_menu.detect do |tab, rect|
          rect.contains?(at)
        end

        if clicked_job_tab && clicked_job_tab.first.citizen_ids.any? && !player_view.holding_citizen
          cmd = PickupCitizenCommand.create(game_id: game_id, citizen_id: clicked_job_tab.first.citizen_ids.last, player_id: player_id)
          p [ :pickup_citizen!, command: cmd ]
          return cmd

        elsif clicked_job_tab && player_view.holding_citizen
          p [ :drop_citizen! ]
          cmd = (DropCitizenCommand.create(game_id: game_id, new_job_name: clicked_job_tab.first.name, player_id: player_id))
          return cmd
        else
          # drop out...
        end
      end

      mouse = mouse_position(window)
      map_location = player_view && player_view.world_view && player_view.world_view.dereference_map_location_from_screen_position(mouse, window: window) rescue nil
      p [ :scroll!, location: map_location ]
      return(ScrollToLocationCommand.create(game_id: game_id, location: map_location, player_id: player_id)) if map_location
    end

    protected
    def mouse_position(window)
      coord(window.mouse_x, window.mouse_y)
    end
  end
end
