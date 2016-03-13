module Socius
  class PlayerView < Metacosm::View
    extend Forwardable
    include Geometer::PointHelpers

    attr_accessor :name, :player_id, :focused_city_id
    has_many :city_views
    has_one :resource_meter_widget
    belongs_to :game_view

    after_create { create_resource_meter_widget(origin: coord(0,80)) }

    def_delegators :resource_meter_widget,
      :gold_meter, :research_meter, :production_meter, :faith_meter, :culture_meter

    def render(window)
      resource_meter_widget.render(window)
      focused_city_view.render(window) if focused_city_id
      window.player_hand.draw(168,288,0)
    end

    def focused_city_view
      CityView.find_by(city_id: focused_city_id)
    end
  end
end
