module Socius
  class PlayerView < Metacosm::View
    attr_accessor :name, :player_id, :micro_production, :production
    belongs_to :game_view
    # has_many :resource_meter_views

    def render(window, progress_towards_step)
      window.font.draw("Production (#{name}): #{production}", 100, 100, 1)
      cell_animation = window.production_cell_animation

      # origin of the first cell of prod meter
      x0,y0 = 8, 124

      if micro_production
        ResourceMeterView.new.render(window, cell_animation: cell_animation, origin: [x0,y0], progress: (micro_production/100.0), resource_count: production)
      end
    end
  end
end
