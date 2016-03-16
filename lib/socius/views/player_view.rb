module Socius
  class PlayerView < Metacosm::View
    extend Forwardable
    include Geometer::PointHelpers

    attr_accessor :name, :player_id, :focused_city_id, :holding_citizen, :color

    has_one :world_view

    has_many :city_views
    has_one :resource_meter_widget

    belongs_to :game_view

    after_create { create_resource_meter_widget(origin: coord(0,80)) }

    def_delegators :resource_meter_widget,
      :gold_meter, :research_meter, :production_meter, :faith_meter, :culture_meter

    def render(window)
      world_view.render(window)
      resource_meter_widget.render(window)

      focused_city_view.render_job_tallies_widget(window) if focused_city_id
      window.player_hand.draw(268,418,3)
      draw_cursor(window)
    end

    def focused_city_view
      CityView.find_by(city_id: focused_city_id)
    end

    def draw_cursor(window)
      mouse = mouse_position(window)
      window.cursor.draw(mouse.x, mouse.y,ZOrder::Cursor)

      if holding_citizen
        window.citizen_image.draw(mouse.x, mouse.y, ZOrder::CursorOverlay)
      end
    end

    def mouse_position(window)
      coord(window.mouse_x, window.mouse_y)
    end
  end
end
