module Socius
  class PlayerView < Metacosm::View
    attr_accessor :name, :player_id
    # attr_accessor :production, :production_progress
    # attr_accessor :gold, :gold_progress
    # attr_accessor :research, :research_progress

    after_create {
      create_resource_meter_view(resource: 'production', origin: [8,124], color: 0xff_b0d0f0)
      create_resource_meter_view(resource: 'gold', origin: [8,276], color: 0xff_f0f0a0)
      create_resource_meter_view(resource: 'research', origin: [8,200], color: 0xff_a0a0f0)
    }

    has_many :resource_meter_views
    belongs_to :game_view

    def gold_meter
      resource_meter_views.where(resource: 'gold').first
    end

    def research_meter
      resource_meter_views.where(resource: 'research').first
    end

    def production_meter
      resource_meter_views.where(resource: 'production').first
    end

    def render(window)
      cell_animation = window.production_cell_animation
      resource_meter_views.each do |resource_meter_view|
        resource_meter_view.render(window, cell_animation: cell_animation)
      end

      # if production
      #   x0,y0 = 8, 124 # origin of the first cell of prod meter
      #   ResourceMeterView.new.render(window, cell_animation: cell_animation, origin: [x0,y0], progress: production_progress, resource_count: production, color: 0xff_a0c0f0)
      # end

      # if gold
      #   x0,y0 = 8, 276
      #   ResourceMeterView.new.render(window, cell_animation: cell_animation, origin: [x0,y0], progress: gold_progress, resource_count: gold, color: 0xff_f0f0a0)
      # end

      # if research
      #   x0,y0 = 8,200
      #   ResourceMeterView.new.render(window, cell_animation: cell_animation, origin: [x0,y0], progress: research_progress, resource_count: research, color: 0xffa0a0f0)
      # end
    end
  end
end
