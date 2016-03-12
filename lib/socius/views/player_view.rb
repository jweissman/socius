module Socius
  class PlayerView < Metacosm::View
    attr_accessor :name, :player_id
    attr_accessor :production, :production_progress
    attr_accessor :gold, :gold_progress
    attr_accessor :research, :research_progress

    belongs_to :game_view

    def render(window)
      cell_animation = window.production_cell_animation

      if production
        x0,y0 = 8, 124 # origin of the first cell of prod meter
        ResourceMeterView.new.render(window, cell_animation: cell_animation, origin: [x0,y0], progress: production_progress, resource_count: production, color: 0xff_a0c0f0)
      end

      if gold
        x0,y0 = 8, 276
        ResourceMeterView.new.render(window, cell_animation: cell_animation, origin: [x0,y0], progress: gold_progress, resource_count: gold, color: 0xff_f0f0a0)
      end

      if research
        x0,y0 = 8,200
        ResourceMeterView.new.render(window, cell_animation: cell_animation, origin: [x0,y0], progress: research_progress, resource_count: research, color: 0xffa0a0f0)
      end
    end
  end
end
