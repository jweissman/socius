module Socius
  class PlayerView < Metacosm::View
    attr_accessor :name, :player_id

    after_create {
      create_resource_meter_view(resource: 'production', origin: [8,124], color: 0xff_b0d0f0)
      create_resource_meter_view(resource: 'gold',       origin: [8,276], color: 0xff_f0f0a0)
      create_resource_meter_view(resource: 'research',   origin: [8,200], color: 0xff_a0a0f0)
      create_resource_meter_view(resource: 'faith',      origin: [8,352], color: 0xff_f0f0f0)
      create_resource_meter_view(resource: 'culture',    origin: [8,428], color: 0xff_f0a0f0)
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

    def faith_meter
      resource_meter_views.where(resource: 'faith').first
    end

    def culture_meter
      resource_meter_views.where(resource: 'culture').first
    end

    def render(window)
      cell_animation = window.production_cell_animation
      resource_meter_views.each do |resource_meter_view|
        resource_meter_view.render(window, cell_animation: cell_animation)
      end
    end
  end
end
