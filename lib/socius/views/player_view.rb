module Socius
  class PlayerView < Metacosm::View
    attr_accessor :name, :player_id
    attr_accessor :micro_production, :production
    attr_accessor :micro_gold, :gold

    belongs_to :game_view
    # has_many :resource_meter_views

    def render(window, progress_towards_step)
      window.font.draw("Production (#{name}): #{production}", 100, 100, 1)
      cell_animation = window.production_cell_animation

      if micro_production
        x0,y0 = 8, 124 # origin of the first cell of prod meter
        ResourceMeterView.new.render(window, cell_animation: cell_animation, origin: [x0,y0], progress: (micro_production/100.0), resource_count: production, color: 0xff_a0c0f0)
      end

      if micro_gold
        x0,y0 = 8, 276
        ResourceMeterView.new.render(window, cell_animation: cell_animation, origin: [x0,y0], progress: (micro_gold/100.0), resource_count: gold, color: 0xff_f0f0a0)
      end
    end
  end
end
